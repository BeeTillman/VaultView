import SwiftUI

struct StockDetailView: View {
    @EnvironmentObject var stockVM: StockViewModel
    var stock: Stock

    var body: some View {
        VStack(spacing: 20) {
            Text(stock.symbol)
                .font(.largeTitle)
                .fontWeight(.bold)

            if let currentPrice = stock.currentPrice {
                Text("Current Price: $\(currentPrice, specifier: "%.2f")")
                    .font(.title2)
            } else {
                Text("Fetching current price...")
                    .font(.title2)
                    .onAppear {
                        fetchCurrentPrice()
                    }
            }

            Text("Shares: \(stock.shares, specifier: "%.2f")")
            Text("Average Cost: $\(stock.averageCost, specifier: "%.2f")")
            Text("Total Value: $\(totalValue(), specifier: "%.2f")")

            Spacer()
        }
        .padding()
        .navigationTitle(stock.symbol)
    }

    func totalValue() -> Double {
        return (stock.currentPrice ?? stock.averageCost) * stock.shares
    }

    func fetchCurrentPrice() {
        StockAPI.shared.fetchCurrentPrice(for: stock.symbol) { price in
            if let price = price {
                DispatchQueue.main.async {
                    stockVM.updateStockPrice(symbol: stock.symbol, price: price)
                }
            }
        }
    }
}
