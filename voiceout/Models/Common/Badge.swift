//
//  Badge.swift
//  voiceout
//
//  Created by J. Wu on 7/29/24.
//

import Foundation

struct Badge: Identifiable, Hashable {
    var id = UUID().uuidString
    var name: String
    var size: CGFloat = 0
}

extension Badge {
    static let targetGroup: [Badge] = [
        Badge(name: "children"),
        Badge(name: "teenager"),
        Badge(name: "adult"),
        Badge(name: "partner"),
        Badge(name: "family"),
        Badge(name: "aged"),
        Badge(name: "LGBTQIA+")
    ]

    static let areaOfExpertise: [Badge] = [
        Badge(name: "negativy"),
        Badge(name: "pressure_management"),
        Badge(name: "interpersonal_relationships"),
        Badge(name: "family_relationships"),
        Badge(name: "parent_child_relationships"),
        Badge(name: "intimate_relationships"),
        Badge(name: "self_explore"),
        Badge(name: "psychological_trauma"),
        Badge(name: "behavior_problem"),
        Badge(name: "addiction issues")
    ]

    static let specializedStyles: [Badge] = [
        Badge(name: "gentle"),
        Badge(name: "candid"),
        Badge(name: "flexible"),
        Badge(name: "composed"),
        Badge(name: "easy"),
        Badge(name: "formal")
    ]
}
