import Foundation
import Combine
import FirebaseFirestore

class AccountViewModel: ObservableObject {
    @Published var accounts: [Account] = []
    var ownerId: String
    private var db = Firestore.firestore()

    init(ownerId: String) {
        self.ownerId = ownerId
        loadAccounts()
    }

    func addAccount(_ account: Account) {
        var newAccount = account
        newAccount.ownerId = ownerId
        do {
            _ = try db.collection("accounts").document(newAccount.id.uuidString).setData(from: newAccount)
            accounts.append(newAccount)
        } catch let error {
            print("Error writing account to Firestore: \(error)")
        }
    }

    func updateAccount(_ account: Account) {
        if let index = accounts.firstIndex(where: { $0.id == account.id }) {
            accounts[index] = account
            do {
                try db.collection("accounts").document(account.id.uuidString).setData(from: account)
            } catch let error {
                print("Error updating account in Firestore: \(error)")
            }
        }
    }

    func loadAccounts() {
        db.collection("accounts").whereField("ownerId", isEqualTo: ownerId).addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error fetching accounts: \(error)")
                return
            }
            self.accounts = snapshot?.documents.compactMap { document in
                try? document.data(as: Account.self)
            } ?? []
        }
    }
    
    func deleteAccount(_ account: Account) {
        db.collection("accounts").document(account.id.uuidString).delete { error in
            if let error = error {
                print("Error deleting account: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.accounts.removeAll { $0.id == account.id }
                }
            }
        }
    }
}
