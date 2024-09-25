import Foundation

struct BalanceEntry: Identifiable, Codable {
    let id: UUID = UUID()
    var date: Date
    var amount: Double
}
