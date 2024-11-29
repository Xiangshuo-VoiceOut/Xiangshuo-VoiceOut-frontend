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
    let date: Date // 日期
    let isPast: Bool // 是否是过去的日期
    let isAvailable: Bool // 是否可用
    let slots: [Slot] // 时间段信息
}

extension Day {
    static let weekLabel: [Day] = [
        Day(
            label: String(localized: "Sunday"),
            date: Date(), // 当前日期作为占位
            isPast: false, // 默认不是过去的日期
            isAvailable: false, // 默认不可用
            slots: [] // 空的时间段信息
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
}

struct Slot: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var startTime: Date
    var endTime: Date
    var isAvailable: Bool
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
    /// 获取 `Date` 对象的小时
    var hour: Int {
        return Calendar.current.component(.hour, from: self)
    }
}
