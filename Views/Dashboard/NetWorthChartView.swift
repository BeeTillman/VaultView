// NetWorthChartView.swift

import SwiftUI
import Charts

struct NetWorthChartView: View {
    var accounts: [Account]

    // Time frame options
    enum TimeFrame: String, CaseIterable, Identifiable {
        case allTime = "All Time"
        case pastThreeYears = "Past 3 Years"
        case yearToDate = "Year-To-Date"
        case month = "Past Month"
        case week = "Past Week"

        var id: String { self.rawValue }
    }

    @State private var selectedTimeFrame: TimeFrame = .allTime
    @State private var selectedDataPoint: BalanceEntry?

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
                    .filter({ Calendar.current.startOfDay(for: $0.date) <= date })
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

        // Filter data based on the selected time frame
        let filteredData = netWorthData.filter { entry in
            switch selectedTimeFrame {
            case .allTime:
                return true
            case .pastThreeYears:
                return entry.date >= Calendar.current.date(byAdding: .year, value: -3, to: Date())!
            case .yearToDate:
                return Calendar.current.isDate(entry.date, equalTo: Date(), toGranularity: .year)
            case .month:
                return entry.date >= Calendar.current.date(byAdding: .month, value: -1, to: Date())!
            case .week:
                return entry.date >= Calendar.current.date(byAdding: .day, value: -7, to: Date())!
            }
        }

        return filteredData.sorted(by: { $0.date < $1.date })
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Net Worth")
                .font(.headline)
                .padding(.horizontal)

            if netWorthData.isEmpty {
                Text("No data available.")
                    .padding()
            } else {
                Chart(netWorthData) { dataPoint in
                    LineMark(
                        x: .value("Date", dataPoint.date),
                        y: .value("Net Worth", dataPoint.amount)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(Theme.accentColor)
                    .accessibilityLabel("\(dataPoint.date.formatted(date: .abbreviated, time: .omitted))")
                    .accessibilityValue("$\(dataPoint.amount, specifier: "%.2f")")
                }
                .chartOverlay { proxy in
                    GeometryReader { geometry in
                        Rectangle().fill(Color.clear).contentShape(Rectangle())
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        let location = value.location
                                        if let date: Date = proxy.value(atX: location.x),
                                           let closestEntry = netWorthData.min(by: { abs($0.date.timeIntervalSince1970 - date.timeIntervalSince1970) < abs($1.date.timeIntervalSince1970 - date.timeIntervalSince1970) }) {
                                            selectedDataPoint = closestEntry
                                        }
                                    }
                                    .onEnded { _ in
                                        selectedDataPoint = nil
                                    }
                            )
                    }
                }
                .frame(height: 250)
                .padding()
                .contextMenu {
                    ForEach(TimeFrame.allCases) { timeFrame in
                        Button(action: {
                            selectedTimeFrame = timeFrame
                        }) {
                            Text(timeFrame.rawValue)
                            if selectedTimeFrame == timeFrame {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }

                // Display details for the selected data point
                if let dataPoint = selectedDataPoint {
                    VStack(alignment: .leading) {
                        Text("Date: \(dataPoint.date.formatted(date: .abbreviated, time: .omitted))")
                        Text("Net Worth: $\(dataPoint.amount, specifier: "%.2f")")
                        if let previousMonthDate = Calendar.current.date(byAdding: .month, value: -1, to: dataPoint.date),
                           let previousDataPoint = netWorthData.first(where: { Calendar.current.isDate($0.date, equalTo: previousMonthDate, toGranularity: .month) }) {
                            let change = dataPoint.amount - previousDataPoint.amount
                            Text("Change from Previous Month: $\(change, specifier: "%.2f")")
                                .foregroundColor(change >= 0 ? .green : .red)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .background(Theme.cardColor)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 5)
        .padding()
    }
}
