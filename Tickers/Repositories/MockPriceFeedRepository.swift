import Foundation
import Combine

final class MockPriceFeedRepository: PriceFeedRepositoryProtocol {
    var isConnectedPublisher: AnyPublisher<Bool, Never> {
        Just(false).eraseToAnyPublisher()
    }

    var priceUpdatesPublisher: AnyPublisher<[PriceUpdate], Never> {
        Empty().eraseToAnyPublisher()
    }

    func fetchStocks() async -> [Stock] {
        StockData.createInitialStocks()
    }

    func stockInfo(for symbol: String) -> StockInfo? {
        StockData.stockInfo(for: symbol)
    }

    func startStreaming(for stocks: [Stock]) {}
    func stopStreaming() {}
}
