//
//  Validators.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 4/30/24.
//

import SwiftUI

public func emailValidator(_ email: String) -> Bool {
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    return emailPredicate.evaluate(with: email)
}

public func passwordValidator(_ password: String) -> Bool {
    let passwordRegex = "^(?=.*[a-zA-Z])(?=.*\\d).{8,}$"
    let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
    return passwordPredicate.evaluate(with: password)
}

public func dateMonthYearValidator(_ dateString: String) -> Bool {
    let dateFotmatter = DateFormatter()
    dateFotmatter.dateFormat = "MM/DD/yyyy"
    dateFotmatter.locale = Locale(identifier: "en_US_POSIX")

    if dateString.count != 10 {
        return false
    }

    guard let date = dateFotmatter.date(from: dateString) else {
        return false
    }

    let currentDate = Date()
    var dateComponents = DateComponents()
    dateComponents.year = 1900
    let calendar = Calendar.current
    let pastDateLimit = calendar.date(from: dateComponents) ?? Date.distantPast
    if date > currentDate || date < pastDateLimit {
        return false
    }
    return true
}

public func monthYearValidator(_ dateString: String) -> Bool {
    let regex = "^(0[1-9]|1[0-2])/(\\d{4})$"

    let predicate = NSPredicate(format: "SELF MATCHES %@", regex)

    guard predicate.evaluate(with: dateString) else {
        return false
    }

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/yyyy"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")

    guard let date = dateFormatter.date(from: dateString) else {
        return false
    }

    let currentDate = Date()
    var dateComponents = DateComponents()
    dateComponents.year = 1900
    let calendar = Calendar.current
    let pastDateLimit = calendar.date(from: dateComponents) ?? Date.distantPast
    if date > currentDate || date < pastDateLimit {
        return false
    }
    return true
}

public func phoneNumberValidator(_ phoneNumber: String) -> Bool {
    let phoneRegex = "^\\(\\d{3}\\) \\d{3}-\\d{4}$"
    let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
    return predicate.evaluate(with: phoneNumber)
}

public func ssnValidator(_ ssn: String) -> Bool {
    let sanitizedSSN = ssn.replacingOccurrences(of: " ", with: "")
        .replacingOccurrences(of: "-", with: "")

    guard sanitizedSSN.count == 9, sanitizedSSN.allSatisfy({ $0.isNumber }) else {
        return false
    }

    // Check for invalid patterns
    let invalidPatterns = [
        "000000000",
        "00000",
        "000",
        "123456789"
    ]

    if invalidPatterns.contains(sanitizedSSN) {
        return false
    }

    return true
}

public func routingNumberValidator(_ routingNumber: String) -> Bool {
    guard routingNumber.count == 9,
          CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: routingNumber)) else {
        return false
    }

    let weights = [3, 7, 1]
    var sum = 0

    for (index, character) in routingNumber.enumerated() {
        if let digit = Int(String(character)) {
            sum += digit * weights[index % 3]
        }
    }

    return sum % 10 == 0
}

public func checkingNumberValidator(_ accountNumber: String) -> Bool {
    let length = accountNumber.count
    guard length >= 8 && length <= 12 else {
        return false
    }

    return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: accountNumber))
}
