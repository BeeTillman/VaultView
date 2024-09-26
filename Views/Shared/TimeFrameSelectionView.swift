// TimeFrameSelectionView.swift

import SwiftUI

struct TimeFrameSelectionView: View {
    @Binding var selectedTimeFrame: NetWorthChartView.TimeFrame

    var body: some View {
        HStack {
            ForEach(NetWorthChartView.TimeFrame.allCases) { timeFrame in
                Button(action: {
                    selectedTimeFrame = timeFrame
                }) {
                    Text(timeFrame.rawValue)
                        .font(.subheadline)
                        .fontWeight(selectedTimeFrame == timeFrame ? .bold : .regular)
                        .foregroundColor(selectedTimeFrame == timeFrame ? Theme.accentColor : Theme.textColor)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(
                            selectedTimeFrame == timeFrame
                                ? Theme.accentColor.opacity(0.1)
                                : Color.clear
                        )
                        .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}
