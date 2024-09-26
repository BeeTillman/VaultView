// YourVaultView.swift

import SwiftUI

struct YourVaultView: View {
    @EnvironmentObject var accountVM: AccountViewModel
    @State private var showAddAccount = false
    @State private var showAddBalanceEntry = false
    @State private var isFabExpanded = false
    @State private var selectedAccount: Account?
    @State private var showActionSheet = false

    var body: some View {
        NavigationView {
            List {
                ForEach(accountVM.accounts) { account in
                    NavigationLink(destination: AccountDetailView(account: account).environmentObject(accountVM)) {
                        AccountRowView(account: account)
                    }
                    .contextMenu {
                        Button(action: {
                            // Add Balance Entry
                            selectedAccount = account
                            showAddBalanceEntry = true
                        }) {
                            Text("Add Balance Entry")
                            Image(systemName: "plus.circle")
                        }
                        Button(action: {
                            // Delete Account
                            accountVM.deleteAccount(account)
                        }) {
                            Text("Delete Account")
                            Image(systemName: "trash")
                        }
                    }
                }
                .listRowBackground(Theme.backgroundColor)
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Your Vault")
            .navigationBarTitleDisplayMode(.inline)
            .background(Theme.backgroundColor.edgesIgnoringSafeArea(.all))
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("AddAccount"))) { _ in
                showAddAccount = true
            }
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("AddBalanceEntry"))) { _ in
                showAddBalanceEntry = true
            }
            .sheet(isPresented: $showAddAccount) {
                AddAccountView().environmentObject(accountVM)
            }
            .sheet(isPresented: $showAddBalanceEntry) {
                if let account = selectedAccount {
                    AddBalanceEntryView(account: account)
                        .environmentObject(accountVM)
                } else {
                    // If no account is selected, ask the user to select one
                    SelectAccountView { account in
                        selectedAccount = account
                        AddBalanceEntryView(account: account)
                            .environmentObject(accountVM)
                    }
                }
            }

            // Floating Action Button
            .overlay(
                FloatingActionButton(isExpanded: $isFabExpanded)
            )
        }
    }
}
