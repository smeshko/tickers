import Foundation
import Combine

@MainActor
final class PriceFeedViewModel: ObservableObject {
    @Published private(set) var stocks: [Stock] = []
    @Published private(set) var isStreaming = false
    @Published private(set) var isConnected = false

    private var timerCancellable: AnyCancellable?
    private let priceFluctuationRange: ClosedRange<Double> = -0.02...0.02

    var sortedStocks: [Stock] {
        stocks.sorted { $0.price > $1.price }
    }

    init() {
        stocks = StockData.createInitialStocks()
    }

    func startStreaming() {
        guard !isStreaming else { return }

        isStreaming = true
        isConnected = true

        timerCancellable = Timer.publish(every: 2.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.generatePriceUpdates()
            }
    }

    func stopStreaming() {
        timerCancellable?.cancel()
        timerCancellable = nil
        isStreaming = false
        isConnected = false
    }

    func toggleStreaming() {
        if isStreaming {
            stopStreaming()
        } else {
            startStreaming()
        }
    }

    private func generatePriceUpdates() {
        stocks = stocks.map { stock in
            var updatedStock = stock
            let percentChange = Double.random(in: priceFluctuationRange)
            let newPrice = stock.price * (1 + percentChange)

            updatedStock.previousPrice = stock.price
            updatedStock.price = max(0.01, newPrice)

            return updatedStock
        }
    }

    func stock(for symbol: String) -> Stock? {
        stocks.first { $0.symbol == symbol }
    }
}
