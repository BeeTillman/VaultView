// TooltipView.swift

import SwiftUI

struct TooltipView: View {
    var dataPoint: BalanceEntry

    var body: some View {
        VStack(spacing: 4) {
            Text(dataPoint.amount.formatted(.currency(code: "USD")))
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Text(dataPoint.date, style: .date)
                .font(.caption2)
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(8)
        .background(Color.black.opacity(0.75))
        .cornerRadius(8)
    }
}
