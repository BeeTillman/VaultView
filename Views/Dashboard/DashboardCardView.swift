// DashboardCardView.swift

import SwiftUI

struct DashboardCardView: View {
    var title: String
    var value: String
    var iconName: String? = nil
    var backgroundColor: Color = Theme.cardColor

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let iconName = iconName {
                Image(systemName: iconName)
                    .font(.title)
                    .foregroundColor(Theme.accentColor)
            }
            Text(title)
                .font(.headline)
                .foregroundColor(Theme.textColor)
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Theme.textColor)
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}
