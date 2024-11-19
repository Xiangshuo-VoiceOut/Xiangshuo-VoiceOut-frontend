//
//  APIConfigs.swift
//  voiceout
//
//  Created by J. Wu on 5/24/24.
//

import Foundation

class APIConfigs {
    static let therapistLogInURL = "http://localhost:3000/api/auth"
    static let therapistForgetPWURL = "http://localhost:3000/api/auth/forgot-password"
    static let therapistValidateTokenURL = "http://localhost:3000/api/validate-reset-token"
    static let therapistResetPWURL = "http://localhost:3000/api/auth/reset-password"
    static let therapistRegister = "http://localhost:3000/api/register/verify"
    static let userLogInURL = "http://localhost:5000/api/auth"
    static let userForgetPWURL = "http://localhost:5000/api/auth/forgot-password"
    static let userValidateTokenURL = "http://localhost:5000/api/validate-reset-token"
    static let userResetPWURL = "http://localhost:5000/api/auth/reset-password"
    static let userSignUpCodeSendingURL = "http://localhost:5000/api/register/send"
    static let userSignUpURL = "http://localhost:5000/api/register"
}
