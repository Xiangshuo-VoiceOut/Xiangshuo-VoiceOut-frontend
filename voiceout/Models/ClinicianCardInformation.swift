//
//  Therapist.swift
//  Therapist Card
//
//  Created by Yujia Yang on 7/5/24.
//
struct ObjectId: Codable {
    var id: String
}
struct Tag: Codable {
    var tag: String
}

struct Clinician: Codable, Identifiable {
    var _id: String
    var profilePicture: ObjectId
    var isAvailable: Bool
    var name: String
    var yearOfExperience: Int
    var certificationType: String
    var consultField: [Tag]
    var avgRating: Double
    var charge: Int

    var id: String { _id }

    enum CodingKeys: String, CodingKey {
           case _id
           case profilePicture
           case isAvailable
           case name
           case yearOfExperience
           case certificationType
           case consultField
           case avgRating
           case charge
    }
}

