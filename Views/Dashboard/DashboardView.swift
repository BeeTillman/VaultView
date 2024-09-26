// DashboardView.swift

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var accountVM: AccountViewModel

    var totalNetWorth: Double {
        accountVM.accounts.reduce(0) { total, account in
            if let latestBalance = account.balances.max(by: { $0.date < $1.date }) {
                return total + latestBalance.amount
            } else {
                return total
            }
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Total Net Worth Card
                    VStack(alignment: .leading) {
                        Text("Total Net Worth")
                            .font(.custom(Theme.fontName, size: 18))
                            .foregroundColor(Theme.secondaryTextColor)
                        Text("$\(totalNetWorth, specifier: "%.2f")")
                            .font(.custom(Theme.boldFontName, size: 36))
                            .foregroundColor(Theme.textColor)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Theme.cardColor)
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 5)
                    .padding(.horizontal)

                    // Net Worth Chart
                    NetWorthChartView(accounts: accountVM.accounts)
                        .environmentObject(accountVM)

                    // Two Smaller Charts/Cards
                    HStack {
                        AverageMonthlyChangeChartView(accounts: accountVM.accounts)
                            .frame(width: UIScreen.main.bounds.width / 2 - 20)
                        CurrentMonthChangeCardView(accounts: accountVM.accounts)
                            .frame(width: UIScreen.main.bounds.width / 2 - 20)
                    }
                    .padding(.horizontal)

                    // Recent Accounts
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Accounts")
                            .font(.custom(Theme.fontName, size: 22))
                            .foregroundColor(Theme.textColor)
                            .padding(.horizontal)

                        ForEach(accountVM.accounts) { account in
                            NavigationLink(destination: AccountDetailView(account: account).environmentObject(accountVM)) {
                                AccountRowView(account: account)
                            }
                        }
                    }

                    Spacer()
                }
                .padding(.top)
            }
            .background(Theme.backgroundColor.edgesIgnoringSafeArea(.all))
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
