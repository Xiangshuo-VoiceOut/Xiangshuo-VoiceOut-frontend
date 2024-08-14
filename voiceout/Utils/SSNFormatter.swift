//
//  SSNFormatter.swift
//  voiceout
//
//  Created by J. Wu on 8/13/24.
//

import Foundation

public func formatSSN(_ input: String) -> String {
    var digits = input.filter{$0.isNumber}
    if digits.count > 9{
        digits = String(digits.prefix(9))
    }
    
    switch digits.count {
    case 6...7:
        digits.insert("-", at: digits.index(digits.startIndex, offsetBy: 3))
        digits.insert("-", at: digits.index(digits.startIndex, offsetBy: 6))
    case 8...9:
        digits.insert("-", at: digits.index(digits.startIndex, offsetBy: 3))
        digits.insert("-", at: digits.index(digits.startIndex, offsetBy: 6))
    default:
        if digits.count > 2 {
            digits.insert("-", at: digits.index(digits.startIndex, offsetBy: 3))
        }
    }
    return digits
}
