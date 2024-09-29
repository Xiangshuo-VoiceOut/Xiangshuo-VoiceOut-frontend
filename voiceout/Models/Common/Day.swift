//
//  Day.swift
//  voiceout
//
//  Created by Yujia Yang on 9/6/24.
//

import SwiftUI
struct Day: Identifiable {
    let id = UUID()
    let label: String
}

extension Day {
    static let weekLabel: [Day] = [
        Day(label: String(localized: "Sunday")),
        Day(label: String(localized: "Monday")),
        Day(label: String(localized: "Tuesday")),
        Day(label: String(localized: "Wednesday")),
        Day(label: String(localized: "Thursday")),
        Day(label: String(localized: "Friday")),
        Day(label: String(localized: "Saturday"))
    ]
}
