import Foundation

enum AccountType: String, CaseIterable, Identifiable, Codable {
    case checking
    case savings
    case brokerage
    case ira
    case _401k

    var id: String { self.rawValue }
}

struct Account: Identifiable, Codable {
    let id: UUID = UUID()
    var name: String
    var type: AccountType
    var iconName: String? // Optional icon image name
    var balances: [BalanceEntry]
    var ownerId: String
}
