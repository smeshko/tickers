import Foundation
import Combine
import Observation
import OSLog

@Observable
@MainActor
final class PriceFeedViewModel {
    private(set) var stocks: [Stock] = []
    private(set) var isStreaming = false
    private(set) var isConnected = false

    private let repository: PriceFeedRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()

    var sortedStocks: [Stock] {
        stocks.sorted { $0.price > $1.price }
    }

    init(repository: PriceFeedRepositoryProtocol) {
        self.repository = repository
        setupSubscriptions()

        Task {
            await loadStocks()
        }
    }

    func startStreaming() {
        guard !isStreaming else { return }
        isStreaming = true
        repository.startStreaming(for: stocks)
    }

    func stopStreaming() {
        isStreaming = false
        repository.stopStreaming()
    }

    func toggleStreaming() {
        if isStreaming {
            stopStreaming()
        } else {
            startStreaming()
        }
    }

    func stock(for symbol: String) -> Stock? {
        stocks.first { $0.symbol == symbol }
    }

    func stockInfo(for symbol: String) -> StockInfo? {
        repository.stockInfo(for: symbol)
    }
}

private extension PriceFeedViewModel {

    private func loadStocks() async {
        stocks = await repository.fetchStocks()
        Log.viewModel.info("Loaded \(self.stocks.count) stocks")
    }

    private func setupSubscriptions() {
        repository.isConnectedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] connected in
                self?.isConnected = connected
            }
            .store(in: &cancellables)

        repository.priceUpdatesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] updates in
                self?.applyPriceUpdates(updates)
            }
            .store(in: &cancellables)
    }

    private func applyPriceUpdates(_ updates: [PriceUpdate]) {
        Log.viewModel.debug("Applying \(updates.count) price updates")
        var updatedStocks = stocks

        // TODO: Improve performance
        for update in updates {
            if let index = updatedStocks.firstIndex(where: { $0.symbol == update.symbol }) {
                updatedStocks[index].previousPrice = updatedStocks[index].price
                updatedStocks[index].price = update.price
            }
        }

        stocks = updatedStocks
    }
}

// MARK: - Preview Support

extension PriceFeedViewModel {
    @MainActor
    static var preview: PriceFeedViewModel {
        PriceFeedViewModel(repository: MockPriceFeedRepository())
    }
}
