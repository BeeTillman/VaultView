import SwiftUI
import Charts

struct NetWorthChartView: View {
    var accounts: [Account]

    var netWorthData: [BalanceEntry] {
        // Aggregate balances across all accounts by date
        var dataDict: [Date: Double] = [:]
        for account in accounts {
            for balance in account.balances {
                let dateKey = Calendar.current.startOfDay(for: balance.date)
                dataDict[dateKey, default: 0.0] += balance.amount
            }
        }
        let sortedData = dataDict.map { BalanceEntry(date: $0.key, amount: $0.value) }
            .sorted { $0.date < $1.date }
        return sortedData
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
