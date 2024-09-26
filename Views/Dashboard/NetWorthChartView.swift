// NetWorthChartView.swift

import SwiftUI
import Charts

struct NetWorthChartView: View {
    var accounts: [Account]

    // Time frame options
    enum TimeFrame: String, CaseIterable, Identifiable {
        case allTime = "All"
        case pastThreeYears = "3 Yrs"
        case yearToDate = "YTD"
        case month = "Month"
        case week = "Week"

        var id: String { self.rawValue }
    }

    @State private var selectedTimeFrame: TimeFrame = .allTime
    @State private var selectedDataPoint: BalanceEntry?
    @State private var showTooltip = false
    @State private var tooltipPosition: CGPoint = .zero

    var netWorthData: [BalanceEntry] {
        // Step 1: Determine the start and end dates based on the selected time frame
        let calendar = Calendar.current
        let today = Date()

        var startDate: Date
        var intervalComponent: Calendar.Component
        var intervalValue: Int

        switch selectedTimeFrame {
        case .allTime:
            // Start from the date the user created their account
            if let accountCreationDate = accounts.flatMap({ $0.balances }).map({ $0.date }).min() {
                startDate = calendar.startOfDay(for: accountCreationDate)
            } else {
                startDate = calendar.startOfDay(for: today)
            }
            intervalComponent = .day
            intervalValue = 1
        case .pastThreeYears:
            startDate = calendar.date(byAdding: .year, value: -3, to: today) ?? today
            startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: startDate)) ?? startDate
            intervalComponent = .month
            intervalValue = 1
        case .yearToDate:
            startDate = calendar.date(from: DateComponents(year: calendar.component(.year, from: today), month: 1, day: 1)) ?? today
            intervalComponent = .weekOfYear
            intervalValue = 1
        case .month:
            startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: today)) ?? today
            intervalComponent = .day
            intervalValue = 1
        case .week:
            let weekday = calendar.component(.weekday, from: today)
            let daysToSubtract = weekday - calendar.firstWeekday
            startDate = calendar.date(byAdding: .day, value: -daysToSubtract, to: today) ?? today
            intervalComponent = .day
            intervalValue = 1
        }

        let endDate = calendar.startOfDay(for: today)

        // Step 2: Generate dates at the specified intervals
        var dates: [Date] = []
        var currentDate = startDate

        while currentDate <= endDate {
            dates.append(currentDate)
            if let nextDate = calendar.date(byAdding: intervalComponent, value: intervalValue, to: currentDate) {
                currentDate = nextDate
            } else {
                break // Prevent infinite loop if date addition fails
            }
        }

        // Step 3: Build the net worth data for each date
        var netWorthData: [BalanceEntry] = []
        var lastKnownBalances: [UUID: Double] = [:]

        for date in dates {
            var totalNetWorth: Double = 0.0

            for account in accounts {
                // Get the latest balance for this account up to the current date
                if let latestBalance = account.balances
                    .filter({ $0.date <= date })
                    .sorted(by: { $0.date < $1.date })
                    .last {
                    lastKnownBalances[account.id] = latestBalance.amount
                }
                // Use the latest known balance or default to 0
                let accountBalance = lastKnownBalances[account.id] ?? 0.0
                totalNetWorth += accountBalance
            }

            netWorthData.append(BalanceEntry(id: UUID(), date: date, amount: totalNetWorth))
        }

        return netWorthData
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
                Chart {
                    ForEach(netWorthData) { dataPoint in
                        LineMark(
                            x: .value("Date", dataPoint.date),
                            y: .value("Net Worth", dataPoint.amount)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(Theme.accentColor)

                        // Dot marker using PointMark
                        if selectedDataPoint?.date == dataPoint.date {
                            PointMark(
                                x: .value("Date", dataPoint.date),
                                y: .value("Net Worth", dataPoint.amount)
                            )
                            .symbolSize(16)
                            .foregroundStyle(Theme.accentColor)
                            .annotation(position: .overlay) {
                                Circle()
                                    .strokeBorder(Theme.accentColor, lineWidth: 2)
                                    .background(Circle().fill(Theme.accentColor.opacity(0.2)))
                                    .frame(width: 16, height: 16)
                            }
                        }
                    }
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: xAxisStrideComponent, count: xAxisStrideCount)) { value in
                        AxisValueLabel {
                            if let dateValue = value.as(Date.self) {
                                Text(formattedAxisLabel(for: dateValue))
                            }
                        }
                    }
                }
                .chartOverlay { proxy in
                    GeometryReader { geometry in
                        Rectangle().fill(Color.clear).contentShape(Rectangle())
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { value in
                                        let location = value.location
                                        guard let date: Date = proxy.value(atX: location.x) else { return }

                                        if let closestEntry = netWorthData.min(by: { abs($0.date.timeIntervalSince1970 - date.timeIntervalSince1970) < abs($1.date.timeIntervalSince1970 - date.timeIntervalSince1970) }),
                                           let tooltipXPosition = proxy.position(forX: closestEntry.date),
                                           let tooltipYPosition = proxy.position(forY: closestEntry.amount) {

                                            // Only trigger haptic feedback and update if the data point has changed
                                            if closestEntry.id != selectedDataPoint?.id {
                                                DispatchQueue.main.async {
                                                    selectedDataPoint = closestEntry
                                                    tooltipPosition = CGPoint(x: tooltipXPosition, y: tooltipYPosition - 70)
                                                    showTooltip = true
                                                }
                                                // Haptic Feedback
                                                let impactLight = UIImpactFeedbackGenerator(style: .light)
                                                impactLight.impactOccurred()
                                            }
                                        }
                                    }
                                    .onEnded { _ in
                                        DispatchQueue.main.async {
                                            showTooltip = false
                                            selectedDataPoint = nil
                                        }
                                    }
                            )
                    }
                }
                .frame(height: 250)
                .padding()
                .overlay(
                    Group {
                        if showTooltip, let dataPoint = selectedDataPoint {
                            TooltipView(dataPoint: dataPoint)
                                .position(
                                    x: tooltipPosition.x,
                                    y: tooltipPosition.y
                                )
                        }
                    }
                )

                // Time Frame Selection Buttons
                TimeFrameSelectionView(selectedTimeFrame: $selectedTimeFrame)
                    .padding(.horizontal)
                    .padding(.bottom, 8)
            }
        }
        .background(Theme.cardColor)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 5)
        .padding()
    }

    // Helper variables to determine the x-axis stride interval
    private var xAxisStrideComponent: Calendar.Component {
        switch selectedTimeFrame {
        case .pastThreeYears:
            return .month
        case .yearToDate:
            return .month
        case .month:
            return .day
        case .week:
            return .day
        default:
            return .year
        }
    }

    private var xAxisStrideCount: Int {
        switch selectedTimeFrame {
        case .pastThreeYears:
            return 3
        case .yearToDate:
            return 1
        case .month:
            return 7
        case .week:
            return 1
        default:
            return 1
        }
    }

    // Helper function to format the axis labels based on the time frame
    private func formattedAxisLabel(for date: Date) -> String {
        switch selectedTimeFrame {
        case .pastThreeYears:
            return date.formatted(.dateTime.year().month())
        case .yearToDate, .month:
            return date.formatted(.dateTime.month(.abbreviated).day())
        case .week:
            return date.formatted(.dateTime.weekday(.abbreviated))
        default:
            return date.formatted(.dateTime.year())
        }
    }
}
