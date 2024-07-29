//
//  Tag.swift
//  voiceout
//
//  Created by J. Wu on 7/29/24.
//

import Foundation

struct Tag: Identifiable, Hashable {
    var id = UUID().uuidString
    var name: String
    var size: CGFloat = 0
}


extension Tag{
    static let targetGroup:[Tag] = [
        Tag(name: "children"),
        Tag(name: "teenager"),
        Tag(name: "adult"),
        Tag(name: "partner"),
        Tag(name: "family"),
        Tag(name: "aged"),
        Tag(name: "LGBTQIA+")
    ]
    
    static let targetFields: [Tag] = [
        Tag(name: "negativy"),
        Tag(name: "pressure_management"),
        Tag(name: "interpersonal_relationships"),
        Tag(name: "family_relationships"),
        Tag(name: "parent_child_relationships"),
        Tag(name: "intimate_relationships"),
        Tag(name: "self_explore"),
        Tag(name: "psychological_trauma"),
        Tag(name: "behavior_problem"),
        Tag(name: "addiction issues")
    ]
    
    static let targetStyles: [Tag] = [
        Tag(name: "gentle"),
        Tag(name: "candid"),
        Tag(name: "flexible"),
        Tag(name: "composed"),
        Tag(name: "easy"),
        Tag(name: "formal"),
    ]
}
