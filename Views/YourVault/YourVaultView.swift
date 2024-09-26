// YourVaultView.swift

import SwiftUI

struct YourVaultView: View {
    @EnvironmentObject var accountVM: AccountViewModel
    @State private var showAddAccount = false

    var body: some View {
        NavigationView {
            List {
                ForEach(accountVM.accounts) { account in
                    NavigationLink(destination: AccountDetailView(account: account).environmentObject(accountVM)) {
                        AccountRowView(account: account)
                    }
                }
            }
            .listStyle(PlainListStyle())
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
            .background(Theme.backgroundColor.edgesIgnoringSafeArea(.all))
        }
    }
}
