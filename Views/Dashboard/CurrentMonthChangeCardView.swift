// CurrentMonthChangeCardView.swift

import SwiftUI

struct CurrentMonthChangeCardView: View {
    var accounts: [Account]

    var currentMonthChange: Double {
        // Get the current month's net worth
        let currentMonthNetWorth = netWorth(on: Date())

        // Get the previous month's net worth
        guard let previousMonthDate = Calendar.current.date(byAdding: .month, value: -1, to: Date()) else {
            return 0.0
        }
        let previousMonthNetWorth = netWorth(on: previousMonthDate)

        return currentMonthNetWorth - previousMonthNetWorth
    }

    func netWorth(on date: Date) -> Double {
        var totalNetWorth: Double = 0.0

        for account in accounts {
            if let latestBalance = account.balances
                .filter({ $0.date <= date })
                .sorted(by: { $0.date < $1.date })
                .last {
                totalNetWorth += latestBalance.amount
            }
        }
        return totalNetWorth
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Net Worth Change This Month")
                .font(.headline)
                .padding(.horizontal)

            Text("$\(currentMonthChange, specifier: "%.2f")")
                .font(.largeTitle)
                .foregroundColor(currentMonthChange >= 0 ? .green : .red)
                .padding(.horizontal)

            Spacer()
        }
        .frame(height: 150)
        .background(Theme.cardColor)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 5)
        .padding()
    }
}
