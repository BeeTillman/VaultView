import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @StateObject var accountVM: AccountViewModel
    @StateObject var stockVM: StockViewModel

    init() {
        let userId = Auth.auth().currentUser?.uid ?? ""
        _accountVM = StateObject(wrappedValue: AccountViewModel(ownerId: userId))
        _stockVM = StateObject(wrappedValue: StockViewModel(ownerId: userId))
    }
    
    var body: some View {
        TabView {
            DashboardView()
                .environmentObject(accountVM)
                .environmentObject(stockVM)
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar.fill")
                }

            YourVaultView()
                .environmentObject(accountVM)
                .tabItem {
                    Label("Your Vault", systemImage: "lock.shield")
                }

            StocksView()
                .environmentObject(stockVM)
                .tabItem {
                    Label("Stocks", systemImage: "chart.line.uptrend.xyaxis")
                }

            SettingsView()
                .environmentObject(authViewModel)
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
    }
}
