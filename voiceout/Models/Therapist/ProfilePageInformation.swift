//
//  ProfileViewModel.swift
//  voiceout
//
//  Created by Yujia Yang on 2/3/25.
//

import Foundation
import Combine

struct ClinicianProfileResponse: Codable {
    let id: String
    let name: String
    let charge: Int
    let title: String
    let profilePicture: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name = "Name"
        case charge = "Charge"
        case title = "Title"
        case profilePicture = "ProfilePicture"
    }
}
