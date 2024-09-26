// AccountRowView.swift

import SwiftUI

struct AccountRowView: View {
    var account: Account

    var body: some View {
        HStack {
            // Icon
            if let iconName = account.iconName {
                Image(iconName)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            } else {
                Image(systemName: "creditcard.fill")
                    .resizable()
                    .frame(width: 40, height: 30)
                    .foregroundColor(Theme.accentColor)
            }

            // Account Name and Subtitle
            VStack(alignment: .leading, spacing: 2) {
                Text(account.name)
                    .font(.custom(Theme.fontName, size: 18))
                    .foregroundColor(Theme.textColor)
                    .baselineOffset(4) // Slightly raised

                Text(account.type.rawValue.capitalized)
                    .font(.custom(Theme.fontName, size: 14))
                    .foregroundColor(Theme.secondaryTextColor)
            }

            Spacer()

            // Account Balance
            if let latestBalance = account.balances.max(by: { $0.date < $1.date }) {
                Text("$\(latestBalance.amount, specifier: "%.2f")")
                    .font(.custom(Theme.boldFontName, size: 18))
                    .foregroundColor(Theme.textColor)
            } else {
                Text("$0.00")
                    .font(.custom(Theme.boldFontName, size: 18))
                    .foregroundColor(Theme.textColor)
            }
        }
        .padding()
        .background(Theme.cardColor)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 5)
        .padding(.horizontal)
    }
}
