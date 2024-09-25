import SwiftUI

struct AddStockView: View {
    @EnvironmentObject var stockVM: StockViewModel
    @Environment(\.presentationMode) var presentationMode

    @State private var symbol: String = ""
    @State private var shares: String = ""
    @State private var averageCost: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Stock Information")) {
                    TextField("Stock Symbol", text: $symbol)
                        .autocapitalization(.allCharacters)
                    TextField("Number of Shares", text: $shares)
                        .keyboardType(.decimalPad)
                    TextField("Average Cost per Share", text: $averageCost)
                        .keyboardType(.decimalPad)
                }

                Button(action: {
                    addStock()
                }) {
                    Text("Add Stock")
                        .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("Add Stock")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Add Stock"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    func addStock() {
        guard !symbol.isEmpty, let shareCount = Double(shares), let avgCost = Double(averageCost) else {
            alertMessage = "Please fill in all fields with valid numbers."
            showAlert = true
            return
        }

        let newStock = Stock(
            symbol: symbol.uppercased(),
            shares: shareCount,
            averageCost: avgCost,
            currentPrice: nil,
            ownerId: stockVM.ownerId
        )
        stockVM.addStock(newStock)
        presentationMode.wrappedValue.dismiss()
    }
}
