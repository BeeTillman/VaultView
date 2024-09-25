import Foundation

struct Stock: Identifiable, Codable {
    let id = UUID()
    var symbol: String
    var shares: Double
    var averageCost: Double
    var currentPrice: Double?
    var ownerId: String // User ID of the stock owner
}
