import Testing
@testable import Tickers

@Suite("Stock Model Tests")
struct StockTests {

    @Test("Price direction is up when price > previousPrice")
    func priceDirectionUp() {
        let stock = Stock(symbol: "AAPL", name: "Apple", price: 150.0, previousPrice: 145.0)

        #expect(stock.priceDirection == .up)
    }

    @Test("Price direction is down when price < previousPrice")
    func priceDirectionDown() {
        let stock = Stock(symbol: "AAPL", name: "Apple", price: 140.0, previousPrice: 145.0)

        #expect(stock.priceDirection == .down)
    }

    @Test("Price direction is unchanged when price == previousPrice")
    func priceDirectionUnchanged() {
        let stock = Stock(symbol: "AAPL", name: "Apple", price: 145.0, previousPrice: 145.0)

        #expect(stock.priceDirection == .unchanged)
    }

    @Test("Price direction defaults to unchanged when no previousPrice provided")
    func priceDirectionDefaultsToUnchanged() {
        let stock = Stock(symbol: "AAPL", name: "Apple", price: 145.0)

        #expect(stock.priceDirection == .unchanged)
    }

    @Test("Price change calculates correctly for increase")
    func priceChangePositive() {
        let stock = Stock(symbol: "AAPL", name: "Apple", price: 150.0, previousPrice: 145.0)

        #expect(stock.priceChange == 5.0)
    }

    @Test("Price change calculates correctly for decrease")
    func priceChangeNegative() {
        let stock = Stock(symbol: "AAPL", name: "Apple", price: 140.0, previousPrice: 145.0)

        #expect(stock.priceChange == -5.0)
    }

    @Test("Price change percent calculates correctly")
    func priceChangePercent() {
        let stock = Stock(symbol: "AAPL", name: "Apple", price: 110.0, previousPrice: 100.0)

        #expect(stock.priceChangePercent == 0.1) // 10%
    }

    @Test("Price change percent handles zero previousPrice without crash")
    func priceChangePercentZeroPreviousPrice() {
        let stock = Stock(symbol: "AAPL", name: "Apple", price: 100.0, previousPrice: 0.0)

        #expect(stock.priceChangePercent == 0)
    }

    @Test("Up direction has correct icon name")
    func upDirectionIconName() {
        #expect(Stock.PriceDirection.up.iconName == "arrow.up")
    }

    @Test("Down direction has correct icon name")
    func downDirectionIconName() {
        #expect(Stock.PriceDirection.down.iconName == "arrow.down")
    }

    @Test("Unchanged direction has correct icon name")
    func unchangedDirectionIconName() {
        #expect(Stock.PriceDirection.unchanged.iconName == "minus")
    }

    @Test("Stock initializes correctly from DTO")
    func stockInitFromDTO() {
        let dto = StockDTO(symbol: "NVDA", name: "NVIDIA", price: 450.0, previousPrice: 440.0)
        let stock = Stock(dto: dto)

        #expect(stock.symbol == "NVDA")
        #expect(stock.name == "NVIDIA")
        #expect(stock.price == 450.0)
        #expect(stock.previousPrice == 440.0)
        #expect(stock.priceDirection == .up)
    }
}
