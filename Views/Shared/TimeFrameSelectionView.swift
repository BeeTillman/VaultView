// TimeFrameSelectionView.swift

import SwiftUI

struct TimeFrameSelectionView: View {
    @Binding var selectedTimeFrame: NetWorthChartView.TimeFrame

    var body: some View {
        HStack(spacing: 8) {
            ForEach(NetWorthChartView.TimeFrame.allCases) { timeFrame in
                Button(action: {
                    selectedTimeFrame = timeFrame
                }) {
                    Text(timeFrame.rawValue)
                        .font(.caption)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 8)
                        .background(selectedTimeFrame == timeFrame ? Theme.accentColor : Theme.cardColor)
                        .foregroundColor(selectedTimeFrame == timeFrame ? .white : Theme.textColor)
                        .cornerRadius(8)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}
