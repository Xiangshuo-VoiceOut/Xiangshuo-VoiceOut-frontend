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
    var profilePicture: ObjectId
    var state: String
    var date: String
    var comments: [Comment]
    var id: String { _id }
}

struct Comment: Codable, Identifiable {
    var id = UUID()
    var comment: String
    var rating: Int
}

// user information
struct User: Codable, Identifiable {
    var _id: String
    var nickname: String
    var profilePicture: String
    var state: String
    var date: String
    var comments: [Comment]
    var id: String { _id }
}
