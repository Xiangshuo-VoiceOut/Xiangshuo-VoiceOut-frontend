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

struct Time: Identifiable {
    let id = UUID()
    let index: Int
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

    static let timeLabel: [Time] = [
        Time(index: 8, label: "8 AM"),
        Time(index: 9, label: "9 AM"),
        Time(index: 10, label: "10 AM"),
        Time(index: 11, label: "11 AM"),
        Time(index: 12, label: "12 PM"),
        Time(index: 13, label: "1 PM"),
        Time(index: 14, label: "2 PM"),
        Time(index: 15, label: "3 PM"),
        Time(index: 16, label: "4 PM"),
        Time(index: 17, label: "5 PM"),
        Time(index: 18, label: "6 PM"),
        Time(index: 19, label: "7 PM"),
        Time(index: 20, label: "8 PM")
    ]
}
