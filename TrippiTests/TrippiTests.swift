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
