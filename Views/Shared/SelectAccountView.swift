// SelectAccountView.swift

import SwiftUI

struct SelectAccountView: View {
    @EnvironmentObject var accountVM: AccountViewModel
    @Environment(\.presentationMode) var presentationMode
    var onSelect: (Account) -> Void

    var body: some View {
        NavigationView {
            List {
                ForEach(accountVM.accounts) { account in
                    Button(action: {
                        onSelect(account)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        AccountRowView(account: account)
                    }
                }
            }
            .navigationTitle("Select Account")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
