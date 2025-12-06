import Foundation
import SwiftUI

struct Stock: Identifiable, Hashable {

    enum PriceDirection {
        case up
        case down
        case unchanged

        var iconName: String {
            switch self {
            case .up: "arrow.up"
            case .down: "arrow.down"
            case .unchanged: "minus"
            }
        }

        var color: Color {
            switch self {
            case .up: .green
            case .down: .red
            case .unchanged: .secondary
            }
        }
    }

    let id: String
    let symbol: String
    let name: String
    var price: Double
    var previousPrice: Double

    var priceDirection: PriceDirection {
        if price > previousPrice {
            return .up
        } else if price < previousPrice {
            return .down
        } else {
            return .unchanged
        }
    }

    var priceChange: Double {
        price - previousPrice
    }

    var priceChangePercent: Double {
        guard previousPrice > 0 else { return 0 }
        return (priceChange / previousPrice)
    }

    init(symbol: String, name: String, price: Double, previousPrice: Double? = nil) {
        self.id = symbol
        self.symbol = symbol
        self.name = name
        self.price = price
        self.previousPrice = previousPrice ?? price
    }

    init(dto: StockDTO) {
        self.id = dto.symbol
        self.symbol = dto.symbol
        self.name = dto.name
        self.price = dto.price
        self.previousPrice = dto.previousPrice
    }
}
