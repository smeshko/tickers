import Foundation

struct PriceUpdate: Equatable {
    let symbol: String
    let price: Double

    init(symbol: String, price: Double) {
        self.symbol = symbol
        self.price = price
    }

    init(dto: PriceUpdateDTO) {
        self.symbol = dto.symbol
        self.price = dto.price
    }
}
