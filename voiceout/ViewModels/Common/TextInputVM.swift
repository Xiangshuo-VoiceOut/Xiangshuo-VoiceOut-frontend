//
//  TextInputVM.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 7/2/24.
//

import Foundation

enum EmailValidationMessage {
    case loginError
    case notExist
    case serverError
    case formError
}

enum VerificationCodeValidationMessage {
    case enterCode
    case invalidVerification
}

class TextInputVM : ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var verificationCode: String = ""
    @Published var newPassword: String = ""
    @Published var confirmNewPassowrd: String = ""
    @Published var isValidEmail: Bool = true
    @Published var emailValidationMsg: String = ""
    @Published var isValidPassword: Bool = true
    @Published var isVerificationCodeValid: Bool = true
    @Published var verificationCodeValidationMsg: String = ""
    @Published var newPasswordValidationMsg: String = "password_requirement"
    @Published var confirmPasswordValidationMsg: String = ""
    @Published var nickname: String = ""
    @Published var birthday: String = ""
    
    func setIsValidEmail(isValid: Bool) {
        isValidEmail = isValid
    }
    
    func setEmailValidationMsg(msg: EmailValidationMessage) {
        switch msg {
        case .loginError:
            emailValidationMsg = "login_error"
        case .notExist:
            emailValidationMsg = "email_not_exist"
        case .serverError:
            emailValidationMsg = "服务器错误"
        case .formError:
            emailValidationMsg = "email_form_error"
        }
    }
    
    func resetEmailValidationMsg() {
        emailValidationMsg = ""
    }
    
    func setIsValidPassword(isValid: Bool) {
        isValidPassword = isValid
    }
    
    func setIsVerificationCodeValid(isValid: Bool) {
        isVerificationCodeValid = isValid
    }
    
    func setVerificationCodeValidationMsg(msg: VerificationCodeValidationMessage) {
        switch msg {
        case .enterCode:
            verificationCodeValidationMsg = "input_verification_code"
        case .invalidVerification:
            verificationCodeValidationMsg = "verification_wrong"
        }
    }
    
    func resetVerificationCodeValidationMsg() {
        verificationCodeValidationMsg = ""
    }
    
    func resetNewPasswordValidationMsg() {
        newPasswordValidationMsg = ""
    }
    
    func setConfirmPasswordValidationMsg() {
        confirmPasswordValidationMsg = "password_not_match"
    }
    
    func resetConfirmPasswordValidationMsg() {
        confirmPasswordValidationMsg = ""
    }
    
    func isMatchedPasswords() -> Bool {
        if newPassword == confirmNewPassowrd {
            setIsValidPassword(isValid: true)
            resetConfirmPasswordValidationMsg()
            return true
        }
        setIsValidPassword(isValid: false)
        setConfirmPasswordValidationMsg()
        return false
    }
    
    func validateEmail() -> Bool {
        if emailValidator(email) {
            setIsValidEmail(isValid: true)
            resetEmailValidationMsg()
            return true
        }
        setIsValidEmail(isValid: false)
        setEmailValidationMsg(msg: .formError)
        return false
    }
    
    func validatePassword() -> Bool {
        if passwordValidator(newPassword) {
            setIsValidPassword(isValid: true)
            resetConfirmPasswordValidationMsg()
            return true
        }
        setIsValidPassword(isValid: false)
        setConfirmPasswordValidationMsg()
        return false
    }
}
