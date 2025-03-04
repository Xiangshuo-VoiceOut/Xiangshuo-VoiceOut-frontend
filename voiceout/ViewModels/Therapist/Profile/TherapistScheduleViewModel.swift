//
//  TherapistScheduleViewModel.swift
//  voiceout
//
//  Created by Yujia Yang on 7/28/24.
//

import SwiftUI
import Combine

struct TimeSlotResponse: Codable {
    struct Data: Codable {
        let slots: [Slot]
    }
    let success: Bool
    let data: Data
}

struct MonthAvailabilityResponse: Codable {
    let clinicianId: String
    let year: Int
    let month: Int
    let availabilityStatus: [String: String]
}


struct AvailabilityResponse: Codable {
    struct Data: Codable {
        let slots: [AvailableSlot]
    }
    let success: Bool
    let data: Data
}

struct AvailableSlot: Codable {
    let startTime: Date
    let isAvailable: Bool

    enum CodingKeys: String, CodingKey {
        case startTime = "timestamp"
        case isAvailable
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dateString = try container.decode(String.self, forKey: .startTime)

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        guard let parsedDate = formatter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(forKey: .startTime, in: container, debugDescription: "Invalid date format")
        }

        self.startTime = parsedDate
        self.isAvailable = (try container.decode(Int.self, forKey: .isAvailable)) == 1
    }
}
