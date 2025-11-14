//
//  MoodManager.swift
//  voiceout
//
//  Created by Yujia Yang on 3/21/25.
//

import Foundation

struct DiaryEntry: Codable, Identifiable, Equatable, Hashable {
    var id: String?
    let userId: String?
    let timestamp: Date
    let moodType: String
    let keyword: [String]?
    let intensity: Double?
    let location: String?
    let persons: [String]?
    let reasons: [String]?
    let diaryText: String?
    let selectedImage: String?
    let attachments: Attachments?

    var dateTime: Date { timestamp }
    var mood: String { moodType }
    var relation: String? { persons?.first }
    var reason: String?   { reasons?.first }

    var story: String {
        diaryText ?? ""
    }

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userId = "user_id"
        case timestamp
        case moodType = "mood_type"
        case keyword
        case intensity
        case location
        case persons
        case reasons
        case diaryText = "diary_text"
        case selectedImage
        case attachments
    }
}

struct Attachments: Codable, Equatable, Hashable {
    let voiceUrl: String?
    let imageUrls: [String]?

    enum CodingKeys: String, CodingKey {
        case voiceUrl = "voice_url"
        case imageUrls = "image_urls"
    }
}

struct DiaryEntryResponse: Codable {
    let success: Bool
    let data: DiaryEntryData
}

struct DiaryEntryData: Codable {
    let _id: String
    let needsGuidance: Bool
}

struct DiaryEntriesResponse: Codable {
    let success: Bool
    let data: DiaryEntriesData
}

struct DiaryEntriesData: Codable {
    let page: Int
    let limit: Int
    let total: Int
    let entries: [DiaryEntry]
}

struct MoodStatsResponse: Codable {
    let period: String
    let total_entries: Int
    let mood_percentages: [String: Double]
}

struct MoodStatsResponseWrapper: Codable {
    let success: Bool
    let data: MoodStatsResponse
}
