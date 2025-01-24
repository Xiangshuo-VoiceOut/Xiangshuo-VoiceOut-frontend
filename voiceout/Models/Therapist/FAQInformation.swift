//
//  FAQInformation.swift
//  voiceout
//
//  Created by Yujia Yang on 1/13/25.
//

import Foundation
struct FAQAnswer: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let paragraph: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case paragraph
    }
}

struct FAQQuestion: Identifiable, Codable, Hashable {
    let id: String?
    let question: String
    let answers: [FAQAnswer]

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case question
        case answers
    }
}

struct FAQCategory: Identifiable, Codable {
    let id: String
    let category: String
    let questions: [FAQQuestion]

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case category
        case questions
    }
}

struct FAQResponse: Codable {
    let message: String
    let data: [FAQCategory]
}

struct ConsultationStep: Identifiable {
    let id = UUID()
    let title: String
    let description: String
}
