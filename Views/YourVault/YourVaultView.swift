import SwiftUI

struct YourVaultView: View {
    @EnvironmentObject var accountVM: AccountViewModel
    @State private var showAddAccount = false

    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(accountVM.accounts) { account in
                    NavigationLink(destination: AccountDetailView(account: account).environmentObject(accountVM)) {
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
            }
            .background(Theme.backgroundColor)
            .navigationTitle("Your Vault")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(action: {
                showAddAccount = true
            }) {
                Image(systemName: "plus")
                    .foregroundColor(Theme.accentColor)
            })
            .sheet(isPresented: $showAddAccount) {
                AddAccountView().environmentObject(accountVM)
            }
        }
    }
}
