//
//  Formatters.swift
//  voiceout
//
//  Created by J. Wu on 7/8/24.
//

import SwiftUI

extension String {
    // MM/DD/yyyy
    var formattedDateMMDDYYYY: String {
        var digits = self.filter { $0.isNumber }

        if digits.count > 8 {
            digits = String(digits.prefix(8))
        }

        switch digits.count {
        case 5...6:
            digits.insert("/", at: digits.index(digits.startIndex, offsetBy: 2))
            if digits.count == 5 {
                digits.insert("/", at: digits.index(digits.startIndex, offsetBy: 3))
            } else {
                digits.insert("/", at: digits.index(digits.startIndex, offsetBy: 5))
            }
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

    // MM/YYYY
    var formattedDateMMYYYY: String {
        var digits = self.filter { $0.isNumber }

        if digits.count > 6 {
            digits = String(digits.prefix(6))
        }

        if digits.count > 2 {
            digits.insert("/", at: digits.index(digits.startIndex, offsetBy: 2))
        }

        return digits
    }

    var formattedPhoneNumber: String {
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

    var formattedSSN: String {
        let digits = self.filter { $0.isNumber }

        guard digits.count == 9 else {
            return self
        }

        let area = digits.prefix(3)
        let group = digits.dropFirst(3).prefix(2)
        let serial = digits.dropFirst(5)

        return "\(area)-\(group)-\(serial)"
    }
}

extension Date {
    var formatTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }

    var formatFullDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M月d日"
        formatter.locale = Locale(identifier: "zh_Hans_CN")
        return formatter.string(from: self)
    }
}
