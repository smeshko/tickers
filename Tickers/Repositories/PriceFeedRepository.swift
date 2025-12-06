import Foundation
import Combine
import OSLog

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
    private var currentStocks: [StockDTO] = []
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
        StockData
            .createInitialStocks()
            .map(Stock.init(dto:))
    }

    func stockInfo(for symbol: String) -> StockInfo? {
        guard let dto = StockData.stockInfo(for: symbol) else { return nil }
        return StockInfo(dto: dto)
    }

    func startStreaming(for stocks: [Stock]) {
        Log.repository.info("Starting stream for \(stocks.count) stocks")
        currentStocks = stocks.map { stock in
            StockDTO(
                symbol: stock.symbol,
                name: stock.name,
                price: stock.price,
                previousPrice: stock.previousPrice
            )
        }
        webSocketService.connect()

        timerCancellable = Timer.publish(every: 2.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.generateAndSendPriceUpdates()
            }
    }

    func stopStreaming() {
        Log.repository.info("Stopping stream")
        timerCancellable?.cancel()
        timerCancellable = nil
        webSocketService.disconnect()
    }
}

private extension PriceFeedRepository {

    func setupMessageHandling() {
        webSocketService.messagePublisher
            .compactMap { [weak self] message -> [PriceUpdate]? in
                guard let dtos = self?.decodePriceUpdates(from: message) else { return nil }
                return dtos.map { PriceUpdate(dto: $0) }
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
            return PriceUpdateDTO(symbol: stock.symbol, price: newPrice)
        }

        guard let jsonString = encodePriceUpdates(updates) else { return }
        webSocketService.send(jsonString)
    }

    func encodePriceUpdates(_ updates: [PriceUpdateDTO]) -> String? {
        guard let data = try? encoder.encode(updates),
              let jsonString = String(data: data, encoding: .utf8) else {
            Log.repository.error("Failed to encode price updates")
            return nil
        }
        return jsonString
    }

    func decodePriceUpdates(from message: String) -> [PriceUpdateDTO]? {
        guard let data = message.data(using: .utf8),
              let decoded = try? decoder.decode([PriceUpdateDTO].self, from: data) else {
            Log.repository.error("Failed to decode price updates")
            return nil
        }
        return decoded
    }
}
