//
//  DateFormatter.swift
//  voiceout
//
//  Created by J. Wu on 7/8/24.
//

import SwiftUI

public func formatDateString(_ input: String) -> String {
    var digits = input.filter {$0.isNumber}
    if digits.count > 8 {
        digits = String(digits.prefix(8))
    }
    switch digits.count {
    case 5...6:
        digits.insert("/", at: digits.index(digits.startIndex, offsetBy: 2))
        digits.insert("/", at: digits.index(digits.startIndex, offsetBy: 5))
    case 7...8:
        digits.insert("/", at: digits.index(digits.startIndex, offsetBy: 2))
        digits.insert("/", at: digits.index(digits.startIndex, offsetBy: 5))
    default:
        if digits.count > 2 {
            digits.insert("/", at: digits.index(digits.startIndex, offsetBy: 2))
        }
    }
    return digits
}

extension String {
    func formatPhoneNumber() -> String {
        let cleanNumber = components(separatedBy: CharacterSet.decimalDigits.inverted).joined()

        let mask = "(XXX) XXX-XXXX"

        var result = ""
        var startIndex = cleanNumber.startIndex
        let endIndex = cleanNumber.endIndex

        for char in mask where startIndex < endIndex {
            if char == "X" {
                result.append(cleanNumber[startIndex])
                startIndex = cleanNumber.index(after: startIndex)
            } else {
                result.append(char)
            }
        }

        return result
    }
}
