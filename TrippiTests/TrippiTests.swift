//
//  TrippiTests.swift
//  TrippiTests
//
//  Created by Mattia Chiarle on 06/06/2026.
//

import Testing
@testable import Trippi
import Foundation

struct TrippiTests {

    @Test func validTrip() {
        #expect(Trip.isValid(name: "Rome", startDate: Date.now, endDate: Date.now.addingTimeInterval(86_400)))
    }

    @Test func emptyNameIsInvalid() {
        #expect(!Trip.isValid(name: "", startDate: Date.now, endDate: Date.now))
    }

    @Test func startAfterEndIsInvalid() {
        #expect(!Trip.isValid(name: "Rome", startDate: Date.now.addingTimeInterval(86_400), endDate: Date.now))
    }

    @Test func sameStartAsEndIsValid() {
        let date = Date.now
        #expect(Trip.isValid(name: "Rome", startDate: date, endDate: date))
    }

}

/// A fixed calendar so results don't depend on the machine's region settings.
private let calendar: Calendar = {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(identifier: "Europe/Rome") ?? .current
    calendar.locale =  Locale(identifier: "en_US")
    return calendar
}()

/// Builds an exact date; falls back to .distantPast so a bad input fails the test loudly.
private func date(_ year: Int, _ month: Int, _ day: Int, _ hour: Int = 0) -> Date {
    calendar.date(from: DateComponents(year: year, month: month, day: day, hour: hour)) ?? .distantPast
}

struct CalendarWeeksTests {
    @Test func mondayToSundayTripIsOneFullWeek() {
        // June 15, 2026 is a Monday; June 21 is the following Sunday.
        let trip = Trip(name: "Rome", startDate: date(2026, 6, 15), endDate: date(2026, 6, 21))

        let weeks = trip.calendarWeeks(in: calendar)

        #expect(weeks.count == 1)
        #expect(weeks[0].count == 7)
        #expect(weeks[0].first == date(2026, 6, 15))
        #expect(weeks[0].last == date(2026, 6, 21))
    }

    @Test func sundayTripStillFillsTheWholeWeek() {
        // June 21 is a Sunday.
        let trip = Trip(name: "Rome", startDate: date(2026, 6, 21), endDate: date(2026, 6, 21))

        let weeks = trip.calendarWeeks(in: calendar)

        #expect(weeks.count == 1)
        #expect(weeks[0].count == 7)
        #expect(weeks[0].first == date(2026, 6, 15))
        #expect(weeks[0].last == date(2026, 6, 21))
    }

    @Test func twoWeeksTrip() {
        // Jun 17 (Wed)–Jun 25 (Thu) spans two Monday-start weeks.
        let trip = Trip(name: "Rome", startDate: date(2026, 6, 17), endDate: date(2026, 6, 25))

        let weeks = trip.calendarWeeks(in: calendar)

        #expect(weeks.count == 2)
        #expect(weeks[0].count == 7)
        #expect(weeks[0].first == date(2026, 6, 15))
        #expect(weeks[0].last == date(2026, 6, 21))
        #expect(weeks[1].count == 7)
        #expect(weeks[1].first == date(2026, 6, 22))
        #expect(weeks[1].last == date(2026, 6, 28))
    }

}

struct ContainsTests {
    @Test func dayInside() {
        let trip = Trip(name: "Rome", startDate: date(2026, 6, 15), endDate: date(2026, 6, 21))
        #expect(trip.contains(day: date(2026, 6, 18), in: calendar))
    }

    @Test func startingDay() {
        let trip = Trip(name: "Rome", startDate: date(2026, 6, 15), endDate: date(2026, 6, 21))
        #expect(trip.contains(day: date(2026, 6, 15), in: calendar))
    }

    @Test func lastDayWithDifferentHour() {
        let trip = Trip(name: "Rome", startDate: date(2026, 6, 15), endDate: date(2026, 6, 21))
        #expect(trip.contains(day: date(2026, 6, 21, 23), in: calendar))
    }

    @Test func dayBefore() {
        let trip = Trip(name: "Rome", startDate: date(2026, 6, 15), endDate: date(2026, 6, 21))
        #expect(!trip.contains(day: date(2026, 6, 14), in: calendar))
    }

    @Test func dayAfter() {
        let trip = Trip(name: "Rome", startDate: date(2026, 6, 15), endDate: date(2026, 6, 21))
        #expect(!trip.contains(day: date(2026, 6, 22), in: calendar))
    }
}

struct MonthLabelTests {
    @Test func sameMonthAndYear() {
        let trip = Trip(name: "Rome", startDate: date(2026, 6, 15), endDate: date(2026, 6, 21))
        #expect(trip.monthLabel(in: calendar) == "June")
    }

    @Test func differentMonths() {
        let trip = Trip(name: "Rome", startDate: date(2026, 6, 15), endDate: date(2026, 7, 21))
        #expect(trip.monthLabel(in: calendar) == "June - July")
    }

    @Test func crossYear() {
        let trip = Trip(name: "Rome", startDate: date(2026, 6, 15), endDate: date(2027, 1, 21))
        #expect(trip.monthLabel(in: calendar) == "June - January")
    }

    @Test func sameMonthDifferentYear() {
        let trip = Trip(name: "Rome", startDate: date(2026, 6, 15), endDate: date(2027, 6, 21))
        #expect(trip.monthLabel(in: calendar) == "June - June")
    }
}
