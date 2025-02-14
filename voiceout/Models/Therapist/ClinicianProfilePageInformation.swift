//
//  ClinicianProfilePageInformation.swift
//  voiceout
//
//  Created by Yujia Yang on 1/13/25.
//

import Foundation

struct ClinicianProfilePageInformation: Codable {
    let id: String
    let name: String
    let email: String
    let state: String
    let language: String
    let phone: String
    let charge: Int
    let title: String
    let profilePicture: String
    let message: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name = "Name"
        case email = "Email"
        case state = "State"
        case language = "Language"
        case phone = "Phone"
        case charge = "Charge"
        case title = "Title"
        case profilePicture = "ProfilePicture"
        case message = "Message"
    }
}

struct Order: Identifiable, Codable {
    var id: String
    var consultantName: String
    var consultationTime: String
    var price: String
    var status: String
    var message: String
}

