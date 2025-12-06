import Foundation

struct PriceUpdateDTO: Codable, Equatable {
    let symbol: String
    let price: Double
}
