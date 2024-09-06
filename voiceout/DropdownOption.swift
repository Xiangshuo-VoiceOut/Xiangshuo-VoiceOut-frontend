//
//  DropdownOption.swift
//  voiceout
//
//  Created by J. Wu on 6/23/24.
//

import Foundation

struct DropdownOption: Identifiable, Hashable {
    let id = UUID().uuidString
    let option: String
}

extension DropdownOption {
    static let testSingleMonth: DropdownOption = DropdownOption(option: "August")
    static let testAllMonths: [DropdownOption] = [
        DropdownOption(option: "January"),
        DropdownOption(option: "February"),
        DropdownOption(option: "March"),
        DropdownOption(option: "April"),
        DropdownOption(option: "May"),
        DropdownOption(option: "June")
    ]
    static let genders: [DropdownOption] = [
        DropdownOption(option: String(localized: "male")),
        DropdownOption(option: String(localized: "female")),
        DropdownOption(option: String(localized: "other"))
    ]
}
