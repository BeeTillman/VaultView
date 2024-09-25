import Foundation
import Combine
import FirebaseFirestore

class StockViewModel: ObservableObject {
    @Published var stocks: [Stock] = []
    var ownerId: String
    private var db = Firestore.firestore()

    init(ownerId: String) {
        self.ownerId = ownerId
        loadStocks()
    }

    func addStock(_ stock: Stock) {
        var newStock = stock
        newStock.ownerId = ownerId
        do {
            _ = try db.collection("stocks").document(newStock.id.uuidString).setData(from: newStock)
            stocks.append(newStock)
        } catch let error {
            print("Error writing stock to Firestore: \(error)")
        }
    }

    func updateStockPrice(symbol: String, price: Double) {
        if let index = stocks.firstIndex(where: { $0.symbol == symbol }) {
            stocks[index].currentPrice = price
            do {
                try db.collection("stocks").document(stocks[index].id.uuidString).setData(from: stocks[index])
            } catch let error {
                print("Error updating stock in Firestore: \(error)")
            }
        }
    }

    func loadStocks() {
        db.collection("stocks").whereField("ownerId", isEqualTo: ownerId).addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error fetching stocks: \(error)")
                return
            }
            self.stocks = snapshot?.documents.compactMap { document in
                try? document.data(as: Stock.self)
            } ?? []
        }
    }
}
