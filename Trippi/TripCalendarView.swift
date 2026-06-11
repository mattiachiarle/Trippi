//
//  TripCalendarView.swift
//  Trippi
//
//  Created by Mattia Chiarle on 11/06/2026.
//

import SwiftUI

struct TripCalendarView: View {
    let trip: Trip

    private let calendar = Calendar.current

    /// `shortWeekdaySymbols` always starts at Sunday, so rotate it to Monday-first
    /// to match the Monday-start rows from `calendarWeeks`.
    private var weekdaySymbols: [String] {
        let symbols = calendar.shortWeekdaySymbols
        return Array(symbols[1...]) + [symbols[0]]
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.vertical, 4)

            ForEach(trip.calendarWeeks(in: calendar), id: \.self) { week in
                HStack(spacing: 0) {
                    ForEach(week, id: \.self) { day in
                        dayCell(for: day)
                    }
                }
            }
        }
        .navigationTitle("\(trip.name), \(trip.monthLabel(in: calendar))")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: Date.self) { day in
            Text(day, format: .dateTime.weekday(.wide).day().month(.wide))
        }
    }

    @ViewBuilder
    private func dayCell(for day: Date) -> some View {
        let label = Text(day, format: .dateTime.day())
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .border(Color(.separator).opacity(0.5), width: 0.5)

        if trip.contains(day: day, in: calendar) {
            NavigationLink(value: day) { label }
        } else {
            label.foregroundStyle(.tertiary)
        }
    }
}

#Preview {
    NavigationStack {
        TripCalendarView(trip: Trip(
            name: "Sample Trip",
            startDate: .now,
            endDate: Calendar.current.date(byAdding: .day, value: 9, to: .now) ?? .now
        ))
    }
}
