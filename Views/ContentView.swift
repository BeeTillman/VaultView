// ContentView.swift

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
                    Label("Dashboard", systemImage: "house.fill")
                }

            YourVaultView()
                .environmentObject(accountVM)
                .tabItem {
                    Label("Accounts", systemImage: "wallet.pass.fill")
                }

            StocksView()
                .environmentObject(stockVM)
                .tabItem {
                    Label("Investments", systemImage: "chart.line.uptrend.xyaxis")
                }

            SettingsView()
                .environmentObject(authViewModel)
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .accentColor(Theme.accentColor)
    }
}
