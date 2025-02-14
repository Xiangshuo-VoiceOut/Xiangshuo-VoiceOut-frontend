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
    let date: Date
    let isPast: Bool
    var isAvailable: Bool
    var slots: [Slot]
}

struct Time: Identifiable {
    let id = UUID()
    let index: Int
    let label: String
}

extension Day {
    static let weekLabel: [Day] = [
        Day(
            label: String(localized: "Sunday"),
            date: Date(),
            isPast: false,
            isAvailable: false,
            slots: []
        ),
        Day(
            label: String(localized: "Monday"),
            date: Date(),
            isPast: false,
            isAvailable: false,
            slots: []
        ),
        Day(
            label: String(localized: "Tuesday"),
            date: Date(),
            isPast: false,
            isAvailable: false,
            slots: []
        ),
        Day(
            label: String(localized: "Wednesday"),
            date: Date(),
            isPast: false,
            isAvailable: false,
            slots: []
        ),
        Day(
            label: String(localized: "Thursday"),
            date: Date(),
            isPast: false,
            isAvailable: false,
            slots: []
        ),
        Day(
            label: String(localized: "Friday"),
            date: Date(),
            isPast: false,
            isAvailable: false,
            slots: []
        ),
        Day(
            label: String(localized: "Saturday"),
            date: Date(),
            isPast: false,
            isAvailable: false,
            slots: []
        )
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

struct Slot: Codable, Identifiable {
    let id: UUID
    var startTime: Date
    var endTime: Date {
        Calendar.current.date(byAdding: .hour, value: 1, to: startTime) ?? startTime
    }
    let isAvailable: Bool

    init(id: UUID = UUID(), startTime: Date, isAvailable: Bool) {
        self.id = id
        self.startTime = startTime
        self.isAvailable = isAvailable
    }

    enum CodingKeys: String, CodingKey {
        case startTime = "timestamp"
        case isAvailable
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dateString = try container.decode(String.self, forKey: .startTime)

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        formatter.timeZone = TimeZone(secondsFromGMT: 0)  // 解析为 UTC 时间

        guard let utcDate = formatter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(forKey: .startTime, in: container, debugDescription: "Invalid date format")
        }

        self.id = UUID()
        self.startTime = utcDate
        self.isAvailable = (try container.decode(Int.self, forKey: .isAvailable)) == 1
    }
}

extension Slot: Equatable, Hashable {
    static func == (lhs: Slot, rhs: Slot) -> Bool {
        lhs.id == rhs.id && lhs.startTime == rhs.startTime && lhs.isAvailable == rhs.isAvailable
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(startTime)
        hasher.combine(isAvailable)
    }
}

struct Availability: Identifiable, Codable {
    var id: String
    var clinicianID: String
    var date: Date
    var isValid: Bool
    var period: [Period]
    var slots: [Slot]
}

struct Period: Codable {
    var morning: Bool
    var afternoon: Bool
    var evening: Bool
}

extension Date {
    var hour: Int {
        return Calendar.current.component(.hour, from: self)
    }
    
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
}
