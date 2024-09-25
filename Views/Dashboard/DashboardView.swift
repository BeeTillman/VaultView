import SwiftUI
import Charts

struct DashboardView: View {
    @EnvironmentObject var accountVM: AccountViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                // Net Worth Chart
                NetWorthChartView(accounts: accountVM.accounts)
                    .padding()
                    .background(Theme.cardColor)
                    .cornerRadius(10)
                    .padding(.horizontal)

                // Summary of Accounts
                VStack(alignment: .leading, spacing: 10) {
                    Text("Account Summary")
                        .font(.headline)
                        .foregroundColor(Theme.textColor)
                        .padding(.horizontal)

                    ForEach(accountVM.accounts) { account in
                        HStack {
                            if let iconName = account.iconName {
                                Image(iconName)
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                            }
                            VStack(alignment: .leading) {
                                Text(account.name)
                                    .font(.system(size: 18, weight: .medium, design: .default))
                                    .foregroundColor(Theme.textColor)
                                Text(account.type.rawValue.capitalized)
                                    .font(.system(size: 14, weight: .regular, design: .default))
                                    .foregroundColor(Theme.secondaryTextColor)
                            }
                            Spacer()
                            if let latestBalance = account.balances.max(by: { $0.date < $1.date }) {
                                Text("$\(latestBalance.amount, specifier: "%.2f")")
                                    .font(.system(size: 18, weight: .bold, design: .default))
                                    .foregroundColor(Theme.textColor)
                            } else {
                                Text("$0.00")
                                    .font(.system(size: 18, weight: .bold, design: .default))
                                    .foregroundColor(Theme.textColor)
                            }
                        }
                        .padding()
                        .background(Theme.cardColor)
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                }

                Spacer()
            }
            .background(Theme.backgroundColor)
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
