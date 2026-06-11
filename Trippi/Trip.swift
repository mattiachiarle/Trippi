//
//  Trip.swift
//  Trippi
//
//  Created by Mattia Chiarle on 06/06/2026.
//

import Foundation
import SwiftData

@Model
final class Trip {
    var name: String = ""
    var startDate: Date = Date.now
    var endDate: Date = Date.now

    init(name: String, startDate: Date, endDate: Date) {
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
    }

    static func isValid(name: String, startDate: Date, endDate: Date) -> Bool {
        !name.isEmpty && startDate <= endDate
    }

    /// The Monday-start weeks the trip touches, as rows of exactly 7 days each.
    /// Weeks start on Monday regardless of the device's locale setting.
    func calendarWeeks(in calendar: Calendar = .current) -> [[Date]] {
        var calendar = calendar
        calendar.firstWeekday = 2 // 1 = Sunday, 2 = Monday

        guard let firstWeek = calendar.dateInterval(of: .weekOfYear, for: startDate) else { return [] }

        var weeks: [[Date]] = []
        var weekStart = firstWeek.start
        let lastDay = calendar.startOfDay(for: endDate)
        while weekStart <= lastDay {
            weeks.append((0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: weekStart) })
            guard let nextWeekStart = calendar.date(byAdding: .day, value: 7, to: weekStart) else { break }
            weekStart = nextWeekStart
        }
        return weeks
    }

    func contains(day: Date, in calendar: Calendar = .current) -> Bool {
        let dayToCheck = calendar.startOfDay(for: day)
        let tripStart = calendar.startOfDay(for: startDate)
        let tripEnd = calendar.startOfDay(for: endDate)

        return dayToCheck >= tripStart && dayToCheck <= tripEnd
    }

    func monthLabel(in calendar: Calendar = .current) -> String {
        let start = startDate.formatted(.dateTime.month(.wide).locale(calendar.locale ?? .current))
        let end = endDate.formatted(.dateTime.month(.wide).locale(calendar.locale ?? .current))
        return calendar.isDate(startDate, equalTo: endDate, toGranularity: .month)
        ? start : "\(start) - \(end)"
    }
}
