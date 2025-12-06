import Foundation

struct StockInfoDTO: Codable, Equatable {
    let symbol: String
    let name: String
    let description: String
    let basePrice: Double
}
