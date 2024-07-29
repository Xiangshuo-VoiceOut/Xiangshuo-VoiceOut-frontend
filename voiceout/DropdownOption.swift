//
//  DropdownOption.swift
//  voiceout
//
//  Created by J. Wu on 6/23/24.
//

import Foundation
import SwiftUI

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
    
    static let degrees: [DropdownOption] = [
        DropdownOption(option: String(localized: "bachelor")),
        DropdownOption(option: String(localized: "master")),
        DropdownOption(option: String(localized: "phd"))
    ]
    
    static let certificates: [DropdownOption] = [
        DropdownOption(option: String(localized: "first_grade_certificate")),
        DropdownOption(option: String(localized: "second_grade_certificate")),
        DropdownOption(option: String(localized: "third_grade_certificate"))
    ]
}
