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
        let dtos = StockData.createInitialStocks()
        return dtos.map { Stock(dto: $0) }
    }

    func stockInfo(for symbol: String) -> StockInfo? {
        guard let dto = StockData.stockInfo(for: symbol) else { return nil }
        return StockInfo(dto: dto)
    }

    func startStreaming(for stocks: [Stock]) {}
    func stopStreaming() {}
}
