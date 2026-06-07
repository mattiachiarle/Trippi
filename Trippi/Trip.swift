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
}
