import SwiftUI

struct StocksView: View {
    @EnvironmentObject var stockVM: StockViewModel
    @State private var showAddStock = false

    var body: some View {
        NavigationView {
            List {
                ForEach(stockVM.stocks) { stock in
                    NavigationLink(destination: StockDetailView(stock: stock).environmentObject(stockVM)) {
                        HStack {
                            Text(stock.symbol)
                            Spacer()
                            if let currentPrice = stock.currentPrice {
                                Text("$\(currentPrice, specifier: "%.2f")")
                            } else {
                                Text("Fetching...")
                                    .onAppear {
                                        fetchCurrentPrice(for: stock)
                                    }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Stocks")
            .navigationBarItems(trailing: Button(action: {
                showAddStock = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showAddStock) {
                AddStockView().environmentObject(stockVM)
            }
        }
    }

    func fetchCurrentPrice(for stock: Stock) {
        StockAPI.shared.fetchCurrentPrice(for: stock.symbol) { price in
            if let price = price {
                DispatchQueue.main.async {
                    stockVM.updateStockPrice(symbol: stock.symbol, price: price)
                }
            }
        }
    }
}
