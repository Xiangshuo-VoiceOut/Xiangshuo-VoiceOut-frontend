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

public func dateValidator(_ dateString: String) -> Bool {
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
