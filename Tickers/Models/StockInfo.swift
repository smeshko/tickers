import Foundation

struct StockInfo: Equatable {
    let symbol: String
    let name: String
    let description: String
    let basePrice: Double

    init(symbol: String, name: String, description: String, basePrice: Double) {
        self.symbol = symbol
        self.name = name
        self.description = description
        self.basePrice = basePrice
    }

    init(dto: StockInfoDTO) {
        self.symbol = dto.symbol
        self.name = dto.name
        self.description = dto.description
        self.basePrice = dto.basePrice
    }
}
