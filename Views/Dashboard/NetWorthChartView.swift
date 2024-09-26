// NetWorthChartView.swift

import SwiftUI
import Charts

struct NetWorthChartView: View {
    var accounts: [Account]

    var netWorthData: [BalanceEntry] {
        // Collect all unique dates from balance entries
        let allDates = Set(accounts.flatMap { $0.balances.map { Calendar.current.startOfDay(for: $0.date) } })
        let sortedDates = allDates.sorted()

        var netWorthData: [BalanceEntry] = []
        var accountLatestBalances: [UUID: Double] = [:] // Account ID to latest balance up to the current date

        for date in sortedDates {
            var totalNetWorth: Double = 0.0

            for account in accounts {
                // Get the latest balance for this account up to the current date
                if let latestBalance = account.balances
                    .filter({ $0.date <= date })
                    .sorted(by: { $0.date < $1.date })
                    .last {
                    accountLatestBalances[account.id] = latestBalance.amount
                }
                // Use the latest balance or default to 0
                let accountBalance = accountLatestBalances[account.id] ?? 0.0
                totalNetWorth += accountBalance
            }

            netWorthData.append(BalanceEntry(id: UUID(), date: date, amount: totalNetWorth))
        }

        return netWorthData.sorted(by: { $0.date < $1.date })
    }

    var body: some View {
        if netWorthData.isEmpty {
            Text("No data available.")
                .padding()
        } else {
            Chart(netWorthData) {
                LineMark(
                    x: .value("Date", $0.date),
                    y: .value("Net Worth", $0.amount)
                )
            }
            .chartXAxis {
                AxisMarks(values: .automatic(desiredCount: 5)) { _ in
                    AxisValueLabel(format: .dateTime.month().day())
                }
            }
            .frame(height: 200)
            .padding()
        }
    }
}
