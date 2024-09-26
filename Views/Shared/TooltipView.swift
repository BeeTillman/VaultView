// TooltipView.swift

import SwiftUI

struct TooltipView: View {
    var dataPoint: BalanceEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(dataPoint.date.formatted(date: .abbreviated, time: .omitted))")
                .font(.caption)
                .foregroundColor(.white)
            Text("Net Worth: $\(dataPoint.amount, specifier: "%.2f")")
                .font(.caption)
                .foregroundColor(.white)
        }
        .padding(8)
        .background(Color.black.opacity(0.75))
        .cornerRadius(8)
    }
}
