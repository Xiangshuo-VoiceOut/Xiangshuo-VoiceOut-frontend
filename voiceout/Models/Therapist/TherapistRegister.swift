//
//  TherapistRegister.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 11/10/24.
//

import Foundation

struct TherapistRegister: Codable {
    var name: String
    var gender: String
    var state: String
    var phone: String
    var birthday: String
    var profileImage: String
    var education: [Education]
    var certification: [Certification]
    var consultation: Consultation
    var signature: String
}

struct Education: Codable {
    var college: String
    var degree: String
    var graduationDate: String
    var major: String
}

struct Certification: Codable {
    var type: String
    var id: String?
    var time: String?
    var state: String?
    var photo: String?
}

struct Consultation: Codable {
    var fee: Double
    var group: Set<String>
    var field: Set<String>
    var style: Set<String>
    var timeZone: String
    var time: Schedule
    var isAllSameTimeSchedule: Bool
}

struct Schedule: Codable {
    var mon: [String]?
    var tue: [String]?
    var wed: [String]?
    var thu: [String]?
    var fri: [String]?
    var sat: [String]?
    var sun: [String]?
    var week: [String]?
}

struct RegiserResponse: Codable {
    let token: String?
}
