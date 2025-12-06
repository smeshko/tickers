import Foundation
import Combine

protocol PriceFeedRepositoryProtocol {
    var isConnectedPublisher: AnyPublisher<Bool, Never> { get }
    var priceUpdatesPublisher: AnyPublisher<[PriceUpdate], Never> { get }

    func fetchStocks() async -> [Stock]
    func stockInfo(for symbol: String) -> StockInfo?
    func startStreaming(for stocks: [Stock])
    func stopStreaming()
}

final class PriceFeedRepository: PriceFeedRepositoryProtocol {
    private let webSocketService: WebSocketServiceProtocol
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private var cancellables = Set<AnyCancellable>()
    private var timerCancellable: AnyCancellable?
    
    private let priceUpdatesSubject = PassthroughSubject<[PriceUpdate], Never>()
    private var currentStocks: [Stock] = []
    private let priceFluctuationRange: ClosedRange<Double> = -0.02...0.02
    
    var isConnectedPublisher: AnyPublisher<Bool, Never> {
        webSocketService.isConnectedPublisher
    }
    
    var priceUpdatesPublisher: AnyPublisher<[PriceUpdate], Never> {
        priceUpdatesSubject.eraseToAnyPublisher()
    }
    
    init(webSocketService: WebSocketServiceProtocol) {
        self.webSocketService = webSocketService
        setupMessageHandling()
    }
    
    func fetchStocks() async -> [Stock] {
        StockData.createInitialStocks()
    }

    func stockInfo(for symbol: String) -> StockInfo? {
        StockData.stockInfo(for: symbol)
    }

    func startStreaming(for stocks: [Stock]) {
        currentStocks = stocks
        webSocketService.connect()
        
        timerCancellable = Timer.publish(every: 2.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.generateAndSendPriceUpdates()
            }
    }
    
    func stopStreaming() {
        timerCancellable?.cancel()
        timerCancellable = nil
        webSocketService.disconnect()
    }
}

private extension PriceFeedRepository {
    
    func setupMessageHandling() {
        webSocketService.messagePublisher
            .compactMap { [weak self] message -> [PriceUpdate]? in
                self?.decodePriceUpdates(from: message)
            }
            .sink { [weak self] updates in
                self?.priceUpdatesSubject.send(updates)
            }
            .store(in: &cancellables)
    }
    func generateAndSendPriceUpdates() {
        let updates = currentStocks.map { stock in
            let percentChange = Double.random(in: priceFluctuationRange)
            let newPrice = max(0.01, stock.price * (1 + percentChange))
            return PriceUpdate(symbol: stock.symbol, price: newPrice)
        }
        
        guard let jsonString = encodePriceUpdates(updates) else { return }
        webSocketService.send(jsonString)
    }
    
    func encodePriceUpdates(_ updates: [PriceUpdate]) -> String? {
        let codableUpdates = updates.map { PriceUpdate(symbol: $0.symbol, price: $0.price) }
        guard let data = try? encoder.encode(codableUpdates),
              let jsonString = String(data: data, encoding: .utf8) else {
            return nil
        }
        return jsonString
    }
    
    func decodePriceUpdates(from message: String) -> [PriceUpdate]? {
        guard let data = message.data(using: .utf8),
              let decoded = try? decoder.decode([PriceUpdate].self, from: data) else {
            return nil
        }
        return decoded.map { PriceUpdate(symbol: $0.symbol, price: $0.price) }
    }
    
}
