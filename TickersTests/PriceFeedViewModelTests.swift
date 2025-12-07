import Testing
import Combine
@testable import Tickers

@Suite("PriceFeedViewModel Tests")
struct PriceFeedViewModelTests {

    @Test("Sorted stocks returns stocks ordered by price descending")
    @MainActor
    func sortedStocksDescending() async {
        let repository = TestPriceFeedRepository(stocks: [
            Stock(symbol: "LOW", name: "Low Price", price: 50.0),
            Stock(symbol: "HIGH", name: "High Price", price: 500.0),
            Stock(symbol: "MID", name: "Mid Price", price: 200.0)
        ])
        let viewModel = PriceFeedViewModel(repository: repository)

        try? await Task.sleep(for: .milliseconds(50))

        let sorted = viewModel.sortedStocks

        #expect(sorted[0].symbol == "HIGH")
        #expect(sorted[1].symbol == "MID")
        #expect(sorted[2].symbol == "LOW")
    }

    @Test("Sorted stocks handles empty array")
    @MainActor
    func sortedStocksEmpty() async {
        let repository = TestPriceFeedRepository(stocks: [])
        let viewModel = PriceFeedViewModel(repository: repository)

        try? await Task.sleep(for: .milliseconds(50))

        #expect(viewModel.sortedStocks.isEmpty)
    }

    @Test("isStreaming starts as false")
    @MainActor
    func initialStreamingState() {
        let repository = TestPriceFeedRepository(stocks: [])
        let viewModel = PriceFeedViewModel(repository: repository)

        #expect(viewModel.isStreaming == false)
    }

    @Test("startStreaming sets isStreaming to true")
    @MainActor
    func startStreamingSetsState() async {
        let repository = TestPriceFeedRepository(stocks: [
            Stock(symbol: "AAPL", name: "Apple", price: 150.0)
        ])
        let viewModel = PriceFeedViewModel(repository: repository)

        try? await Task.sleep(for: .milliseconds(50))

        viewModel.startStreaming()

        #expect(viewModel.isStreaming == true)
    }

    @Test("stopStreaming sets isStreaming to false")
    @MainActor
    func stopStreamingSetsState() async {
        let repository = TestPriceFeedRepository(stocks: [
            Stock(symbol: "AAPL", name: "Apple", price: 150.0)
        ])
        let viewModel = PriceFeedViewModel(repository: repository)

        try? await Task.sleep(for: .milliseconds(50))

        viewModel.startStreaming()
        viewModel.stopStreaming()

        #expect(viewModel.isStreaming == false)
    }

    @Test("toggleStreaming switches state")
    @MainActor
    func toggleStreamingSwitchesState() async {
        let repository = TestPriceFeedRepository(stocks: [
            Stock(symbol: "AAPL", name: "Apple", price: 150.0)
        ])
        let viewModel = PriceFeedViewModel(repository: repository)

        try? await Task.sleep(for: .milliseconds(50))

        #expect(viewModel.isStreaming == false)

        viewModel.toggleStreaming()
        #expect(viewModel.isStreaming == true)

        viewModel.toggleStreaming()
        #expect(viewModel.isStreaming == false)
    }

    @Test("startStreaming does nothing if already streaming")
    @MainActor
    func startStreamingIdempotent() async {
        let repository = TestPriceFeedRepository(stocks: [
            Stock(symbol: "AAPL", name: "Apple", price: 150.0)
        ])
        let viewModel = PriceFeedViewModel(repository: repository)

        try? await Task.sleep(for: .milliseconds(50))

        viewModel.startStreaming()
        viewModel.startStreaming()

        #expect(viewModel.isStreaming == true)
        #expect(repository.startStreamingCallCount == 1)
    }

    @Test("stock(for:) returns matching stock")
    @MainActor
    func stockForSymbolReturnsMatch() async {
        let repository = TestPriceFeedRepository(stocks: [
            Stock(symbol: "AAPL", name: "Apple", price: 150.0),
            Stock(symbol: "MSFT", name: "Microsoft", price: 350.0)
        ])
        let viewModel = PriceFeedViewModel(repository: repository)

        try? await Task.sleep(for: .milliseconds(50))

        let stock = viewModel.stock(for: "MSFT")

        #expect(stock?.symbol == "MSFT")
        #expect(stock?.price == 350.0)
    }

    @Test("stock(for:) returns nil for non-existent symbol")
    @MainActor
    func stockForSymbolReturnsNil() async {
        let repository = TestPriceFeedRepository(stocks: [
            Stock(symbol: "AAPL", name: "Apple", price: 150.0)
        ])
        let viewModel = PriceFeedViewModel(repository: repository)

        try? await Task.sleep(for: .milliseconds(50))

        let stock = viewModel.stock(for: "UNKNOWN")

        #expect(stock == nil)
    }
}

private final class TestPriceFeedRepository: PriceFeedRepositoryProtocol {
    private let stocks: [Stock]
    private(set) var startStreamingCallCount = 0
    private(set) var stopStreamingCallCount = 0

    private let isConnectedSubject = CurrentValueSubject<Bool, Never>(false)
    private let priceUpdatesSubject = PassthroughSubject<[PriceUpdate], Never>()

    var isConnectedPublisher: AnyPublisher<Bool, Never> {
        isConnectedSubject.eraseToAnyPublisher()
    }

    var priceUpdatesPublisher: AnyPublisher<[PriceUpdate], Never> {
        priceUpdatesSubject.eraseToAnyPublisher()
    }

    init(stocks: [Stock]) {
        self.stocks = stocks
    }

    func fetchStocks() async -> [Stock] {
        stocks
    }

    func stockInfo(for symbol: String) -> StockInfo? {
        nil
    }

    func startStreaming(for stocks: [Stock]) {
        startStreamingCallCount += 1
        isConnectedSubject.send(true)
    }

    func stopStreaming() {
        stopStreamingCallCount += 1
        isConnectedSubject.send(false)
    }

    func sendPriceUpdate(_ update: PriceUpdate) {
        priceUpdatesSubject.send([update])
    }
}
