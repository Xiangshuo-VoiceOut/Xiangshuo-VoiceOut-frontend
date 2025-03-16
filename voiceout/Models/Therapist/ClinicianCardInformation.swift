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
    let tag: String
    enum CodingKeys: String, CodingKey {
        case tag = "Tag"
    }
}

struct Clinician: Codable, Identifiable {
    var _id: String
    var name: String
    var certification: [Certification]?
    var charge: Int
    var consultField: [Tag]
    var yearOfExperience: Int
    var profilePicture: String?
    var ratingCount: Int

    var id: String { _id }

    var certificationType: String? {
        return certification?.first?.certificationType
    }
    
    var certificationLocation: String? {
        return certification?.first?.certificationLocation
    }

    enum CodingKeys: String, CodingKey {
        case _id
        case name = "Name"
        case certification = "Certification"
        case charge = "Charge"
        case consultField = "ConsultField"
        case yearOfExperience = "YearOfExperience"
        case profilePicture = "ProfilePicture"
        case ratingCount = "RatingCount"
    }
}

struct ClinicianResponse: Codable {
    var success: Bool
    var data: [Clinician]
    var message: String
}

struct Certification: Codable {
    var certificationType: String
    var certificationLocation: String?
    var certificationID: String
    var certificationExpiration: String
    var certificationPhoto: String

    enum CodingKeys: String, CodingKey {
        case certificationType = "CertificationType"
        case certificationLocation = "CertificationLocation"
        case certificationID = "CertificationID"
        case certificationExpiration = "CertificationExpiration"
        case certificationPhoto = "CertificationPhoto"
    }
}
