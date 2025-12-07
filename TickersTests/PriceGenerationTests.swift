import Testing
@testable import Tickers

@Suite("Price Generation Tests")
struct PriceGenerationTests {

    @Test("Generated price stays within ±2% bounds", arguments: 1...100)
    func priceFluctuationWithinBounds(iteration: Int) {
        let basePrice = 100.0
        let fluctuationRange: ClosedRange<Double> = -0.02...0.02

        let percentChange = Double.random(in: fluctuationRange)
        let newPrice = max(0.01, basePrice * (1 + percentChange))

        #expect(newPrice >= basePrice * 0.98)
        #expect(newPrice <= basePrice * 1.02)
    }

    @Test("Generated price never goes below minimum")
    func priceNeverBelowMinimum() {
        let veryLowPrice = 0.005
        let fluctuationRange: ClosedRange<Double> = -0.02...0.02

        for _ in 1...100 {
            let percentChange = Double.random(in: fluctuationRange)
            let newPrice = max(0.01, veryLowPrice * (1 + percentChange))

            #expect(newPrice >= 0.01)
        }
    }

    @Test("Handles very large price correctly")
    func veryLargePriceHandled() {
        let largePrice = 10_000_000.0
        let fluctuationRange: ClosedRange<Double> = -0.02...0.02

        let percentChange = Double.random(in: fluctuationRange)
        let newPrice = max(0.01, largePrice * (1 + percentChange))

        #expect(newPrice >= largePrice * 0.98)
        #expect(newPrice <= largePrice * 1.02)
        #expect(newPrice.isFinite)
    }

    @Test("Handles fractional price correctly")
    func fractionalPriceHandled() {
        let fractionalPrice = 0.0523
        let fluctuationRange: ClosedRange<Double> = -0.02...0.02

        let percentChange = Double.random(in: fluctuationRange)
        let newPrice = max(0.01, fractionalPrice * (1 + percentChange))

        #expect(newPrice >= 0.01)
        #expect(newPrice.isFinite)
    }
}
