import Foundation

struct BalanceEntry: Identifiable, Codable {
    let id: UUID
    var date: Date
    var amount: Double
}
