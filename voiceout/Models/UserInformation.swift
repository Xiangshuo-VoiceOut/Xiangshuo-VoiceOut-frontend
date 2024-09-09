//
//  User  Information.swift
//  Comment Card
//
//  Created by Yujia Yang on 7/5/24.
//

import Foundation

struct User: Codable, Identifiable {
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
