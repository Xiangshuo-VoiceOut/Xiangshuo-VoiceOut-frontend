//
//  MoodManagerVM.swift
//  voiceout
//
//  Created by Yujia Yang on 3/28/25.
//

import Foundation

func intensityDescription(_ intensity: Double) -> String {
    if intensity <= 0.3 {
        return String(localized: "intensity_low")
    } else if intensity <= 0.6 {
        return String(localized: "intensity_medium")
    } else {
        return String(localized: "intensity_high")
    }
}
