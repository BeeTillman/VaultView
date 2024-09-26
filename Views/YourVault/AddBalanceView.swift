import SwiftUI

struct AddBalanceView: View {
    @EnvironmentObject var accountVM: AccountViewModel
    @Environment(\.presentationMode) var presentationMode
    var account: Account

    @State private var amount: String = ""
    @State private var date: Date = Date()
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Balance Entry")) {
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }

                Button(action: {
                    addBalance()
                }) {
                    Text("Add Balance")
                        .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("Add Balance")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Add Balance"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    func addBalance() {
        guard let balanceAmount = Double(amount) else {
            alertMessage = "Please enter a valid amount."
            showAlert = true
            return
        }

        let newBalance = BalanceEntry(id: UUID(), date: date, amount: balanceAmount)
        var updatedAccount = account
        updatedAccount.balances.append(newBalance)
        accountVM.updateAccount(updatedAccount)
        presentationMode.wrappedValue.dismiss()
    }
}
