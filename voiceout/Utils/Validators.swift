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
    dateFotmatter.dateFormat = "MM/DD/YYYY"
    dateFotmatter.locale = Locale(identifier: "en_US_POSIX")
    if let _ = dateFotmatter.date(from: dateString) {
        return true
    } else {
        return false
    }
}
