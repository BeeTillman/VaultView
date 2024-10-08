// AverageMonthlyChangeCardView.swift

import SwiftUI
import Charts

struct AverageMonthlyChangeCardView: View {
    var accounts: [Account]

    var monthlyChangeData: [MonthlyChange] {
        // Combine all balance entries
        let allBalances = accounts.flatMap { $0.balances }

        // Group balances by month and year
        let groupedBalances = Dictionary(grouping: allBalances) { (balance) -> String in
            let components = Calendar.current.dateComponents([.year, .month], from: balance.date)
            return "\(components.year!)-\(components.month!)"
        }

        // Calculate net worth for each month
        let monthlyNetWorth = groupedBalances.mapValues { balances -> Double in
            balances.reduce(0) { $0 + $1.amount }
        }

        // Sort months
        let sortedMonths = monthlyNetWorth.keys.sorted()

        // Calculate monthly changes
        var previousNetWorth: Double = 0.0
        var monthlyChanges: [MonthlyChange] = []

        for month in sortedMonths {
            let netWorth = monthlyNetWorth[month] ?? 0.0
            let change = netWorth - previousNetWorth
            let dateComponents = month.split(separator: "-").compactMap { Int($0) }
            if dateComponents.count == 2,
               let year = dateComponents.first,
               let month = dateComponents.last,
               let date = Calendar.current.date(from: DateComponents(year: year, month: month)) {
                monthlyChanges.append(MonthlyChange(id: UUID(), date: date, change: change))
            }
            previousNetWorth = netWorth
        }

        return monthlyChanges.sorted(by: { $0.date < $1.date })
    }

    var body: some View {
        VStack {
            Text("Avg. Monthly Change")
                .font(.headline)
                .foregroundColor(Theme.textColor)
                .padding(.top, 8)
                .multilineTextAlignment(.center)

            Spacer()

            if monthlyChangeData.isEmpty {
                Text("No data available.")
                    .font(.caption)
                    .foregroundColor(Theme.secondaryTextColor)
            } else {
                Chart(monthlyChangeData) { dataPoint in
                    BarMark(
                        x: .value("Month", dataPoint.date, unit: .month),
                        y: .value("Change", dataPoint.change)
                    )
                    .foregroundStyle(dataPoint.change >= 0 ? .green : .red)
                }
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
                .padding([.leading, .trailing, .bottom], 8)
            }

            Spacer()
        }
    }
}

struct MonthlyChange: Identifiable {
    let id: UUID
    let date: Date
    let change: Double
}
