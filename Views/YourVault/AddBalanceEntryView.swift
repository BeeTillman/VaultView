import SwiftUI

struct AddBalanceEntryView: View {
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
                    DatePicker("Date & Time", selection: $date)
                }

                Button(action: {
                    addBalanceEntry()
                }) {
                    Text("Add Entry")
                        .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("Add Balance Entry")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Add Entry"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    func addBalanceEntry() {
        guard let balanceAmount = Double(amount) else {
            alertMessage = "Please enter a valid amount."
            showAlert = true
            return
        }

        let newBalanceEntry = BalanceEntry(id: UUID(), date: date, amount: balanceAmount)
        var updatedAccount = account
        updatedAccount.balances.append(newBalanceEntry)
        accountVM.updateAccount(updatedAccount)
        presentationMode.wrappedValue.dismiss()
    }
}
