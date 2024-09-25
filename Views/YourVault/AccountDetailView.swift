import SwiftUI

struct AccountDetailView: View {
    @EnvironmentObject var accountVM: AccountViewModel
    var account: Account
    @State private var showAddBalanceEntry = false

    var body: some View {
        List {
            ForEach(account.balances.sorted(by: { $0.date > $1.date })) { balance in
                HStack {
                    Text("\(balance.date, formatter: dateFormatter)")
                    Spacer()
                    Text("$\(balance.amount, specifier: "%.2f")")
                }
            }
        }
        .navigationTitle(account.name)
        .navigationBarItems(trailing: Button(action: {
            showAddBalanceEntry = true
        }) {
            Image(systemName: "plus")
        })
        .sheet(isPresented: $showAddBalanceEntry) {
            AddBalanceEntryView(account: account)
                .environmentObject(accountVM)
        }
    }

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short // Include time
        return formatter
    }()
}
