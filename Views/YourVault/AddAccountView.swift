import SwiftUI

struct AddAccountView: View {
    @EnvironmentObject var accountVM: AccountViewModel
    @Environment(\.presentationMode) var presentationMode

    @State private var name: String = ""
    @State private var type: AccountType = .checking
    @State private var initialBalance: String = ""
    @State private var selectedIcon: String? = nil
    @State private var showIconPicker = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    // Sample icons (ensure these images are added to your Assets)
    let availableIcons = ["icon1", "icon2", "icon3", "icon4"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Account Information")) {
                    TextField("Account Name", text: $name)
                    Picker("Account Type", selection: $type) {
                        ForEach(AccountType.allCases) { accountType in
                            Text(accountType.rawValue.capitalized).tag(accountType)
                        }
                    }
                    HStack {
                        Text("Icon")
                        Spacer()
                        if let iconName = selectedIcon {
                            Image(iconName)
                                .resizable()
                                .frame(width: 30, height: 30)
                                .onTapGesture {
                                    showIconPicker = true
                                }
                        } else {
                            Text("Select Icon")
                                .foregroundColor(.gray)
                                .onTapGesture {
                                    showIconPicker = true
                                }
                        }
                    }
                }

                Section(header: Text("Initial Balance")) {
                    TextField("Balance Amount", text: $initialBalance)
                        .keyboardType(.decimalPad)
                }

                Button(action: {
                    addAccount()
                }) {
                    Text("Add Account")
                        .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("Add Account")
            .sheet(isPresented: $showIconPicker) {
                IconPickerView(selectedIcon: $selectedIcon, icons: availableIcons)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Add Account"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    func addAccount() {
        guard !name.isEmpty, let balance = Double(initialBalance) else {
            alertMessage = "Please fill in all fields with valid numbers."
            showAlert = true
            return
        }

        let newBalanceEntry = BalanceEntry(date: Date(), amount: balance)

        let newAccount = Account(
            name: name,
            type: type,
            iconName: selectedIcon,
            balances: [newBalanceEntry],
            ownerId: accountVM.ownerId
        )
        accountVM.addAccount(newAccount)
        presentationMode.wrappedValue.dismiss()
    }
}
