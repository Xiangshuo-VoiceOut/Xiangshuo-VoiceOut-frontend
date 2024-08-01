//
//  TherapistScheduleAvailability.swift
//  voiceout
//
//  Created by Yujia Yang on 7/28/24.
//

import Foundation

struct Day: Identifiable {
    let id = UUID()
    let date: Date
    let display: String
    let isPast: Bool
    let isAvailable: Bool
    let slots: [Slot]
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
