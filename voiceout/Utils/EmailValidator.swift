//
//  EmailValidator.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 4/30/24.
//

import SwiftUI

public func isValidEmail(_ email: String) -> Bool {
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    return emailPredicate.evaluate(with: email)
}
