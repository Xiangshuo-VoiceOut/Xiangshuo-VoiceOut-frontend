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

    static let genders : [DropdownOption] = [
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
        DropdownOption(option: String(localized: "Art Therapist")),
        DropdownOption(option: String(localized: "Clinical Social Work/Therapist")),
        DropdownOption(option: String(localized: "Counselor")),
        DropdownOption(option: String(localized: "Drug & Alcohol Counselor")),
        DropdownOption(option: String(localized: "Licensed Professional Counselor")),
        DropdownOption(option: String(localized: "Licensed Psychoanalyst")),
        DropdownOption(option: String(localized: "Limited Licensed Psychologist")),
        DropdownOption(option: String(localized: "LPC Intern")),
        DropdownOption(option: String(localized: "Marriage & Family Therapist")),
        DropdownOption(option: String(localized: "Marriage & Family Therapist Intern")),
        DropdownOption(option: String(localized: "Marriage & Family Therapist Associate")),
        DropdownOption(option: String(localized: "Pastoral Counselor")),
        DropdownOption(option: String(localized: "Pre-Licensed Professional")),
        DropdownOption(option: String(localized: "Psychiatric Nurse")),
        DropdownOption(option: String(localized: "Psychiatric Nurse Practitioner")),
        DropdownOption(option: String(localized: "Psychiatrist")),
        DropdownOption(option: String(localized: "Registered Psychotherapist")),
        DropdownOption(option: String(localized: "Treatment Center")),
        DropdownOption(option: String(localized: "second_grade_certificate")),
        DropdownOption(option: String(localized: "skill_certificate")),
        DropdownOption(option: String(localized: "Pre-license/On license")),
    ]

}
