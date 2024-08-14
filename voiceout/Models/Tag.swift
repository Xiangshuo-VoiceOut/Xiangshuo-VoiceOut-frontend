//
//  Tag.swift
//  voiceout
//
//  Created by J. Wu on 7/29/24.
//

import Foundation

struct BadgeTag: Identifiable, Hashable {
    var id = UUID().uuidString
    var name: String
    var size: CGFloat = 0
}


extension BadgeTag{
    static let targetGroup:[BadgeTag] = [
        BadgeTag(name: "children"),
        BadgeTag(name: "teenager"),
        BadgeTag(name: "adult"),
        BadgeTag(name: "partner"),
        BadgeTag(name: "family"),
        BadgeTag(name: "aged"),
        BadgeTag(name: "LGBTQIA+")
    ]
    
    static let targetFields: [BadgeTag] = [
        BadgeTag(name: "negativy"),
        BadgeTag(name: "pressure_management"),
        BadgeTag(name: "interpersonal_relationships"),
        BadgeTag(name: "family_relationships"),
        BadgeTag(name: "parent_child_relationships"),
        BadgeTag(name: "intimate_relationships"),
        BadgeTag(name: "self_explore"),
        BadgeTag(name: "psychological_trauma"),
        BadgeTag(name: "behavior_problem"),
        BadgeTag(name: "addiction issues")
    ]
    
    static let targetStyles: [BadgeTag] = [
        BadgeTag(name: "gentle"),
        BadgeTag(name: "candid"),
        BadgeTag(name: "flexible"),
        BadgeTag(name: "composed"),
        BadgeTag(name: "easy"),
        BadgeTag(name: "formal"),
    ]
}
