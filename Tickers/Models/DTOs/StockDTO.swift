import Foundation

struct StockDTO: Codable, Equatable {
    let symbol: String
    let name: String
    var price: Double
    var previousPrice: Double

    init(symbol: String, name: String, price: Double, previousPrice: Double? = nil) {
        self.symbol = symbol
        self.name = name
        self.price = price
        self.previousPrice = previousPrice ?? price
    }
}
