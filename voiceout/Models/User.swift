//
//  User.swift
//  voiceout
//
//  Created by J. Wu on 5/25/24.
//

import Foundation

struct UserLogin: Codable {
    var email: String
    var password: String
}

struct LoginResponse: Codable {
    let token: String?
}

struct UserSignUp: Codable {
    var email: String
    var password: String
    var otp: String
    var nickname: String
    var state: String
    var birthdate: String
    var gender: String
}

struct SignUpResponse: Codable {
    let token: String?
}

// profile data
struct UserProfile: Codable, Identifiable {
    var _id: String
    var nickname: String
    var profilePicture: String
    var state: String
    var date: String
    var comments: [Comment]
    var id: String { _id }

}

struct Comment: Codable, Identifiable {
    let _id: String
    var id: String { _id }
    let userId: String
    let clinicianId: String
    let overallSatisfaction: Int
    let performance: Performance
    let likelyToContinue: Int
    let feedback: String
    let status: Int
    let profilePicture: String
    let createTimestamp: String
    let updateTimestamp: String
    let nickName: String

    enum CodingKeys: String, CodingKey {
        case _id
        case userId
        case clinicianId
        case nickName 
        case overallSatisfaction
        case performance
        case likelyToContinue
        case feedback
        case status
        case profilePicture = "ProfilePicture" 
        case createTimestamp
        case updateTimestamp
    }
}

struct Performance: Codable {
    let understanding: Int
    let adviceProvided: Int
    let professionalKnowledge: Int
    let attitude: Int
}

