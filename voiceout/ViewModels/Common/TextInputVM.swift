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
    case alreadyExist
}

enum VerificationCodeValidationMessage {
    case enterCode
    case invalidVerification
}

enum EmailValidationContext{
    case login
    case signup
}

class TextInputVM : ObservableObject {
    @Published var newEmail: String = ""
    @Published var isValidNewEmail: Bool = true
    @Published var newEmailValidationMsg: String = ""
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
    @Published var isNicknameValid: Bool = true
    @Published var nicknameValidationMsg: String = ""
    @Published var birthdate: String = ""
    @Published var isDateValid: Bool = true
    @Published var dateValidationMsg: String = ""
    
    func setIsValidEmail(isValid: Bool) {
        isValidEmail = isValid
    }
    
    func setEmailValidationMsg(msg: EmailValidationMessage, context: EmailValidationContext) {
        switch context {
        case .login:
            switch msg{
            case .loginError:
                emailValidationMsg = "login_error"
            case .notExist:
                emailValidationMsg = "email_not_exist"
            case .formError:
                emailValidationMsg = "email_form_error"
            default:
                emailValidationMsg = "network_error"
            }
            
        case .signup:
            switch msg{
            case .formError:
                emailValidationMsg = "email_form_error"
            case .alreadyExist:
                emailValidationMsg = "email_already_exist"
            default:
                emailValidationMsg = "network_error"
                
            }
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
    
    func setIsDateValid(isValid: Bool) {
        isDateValid = isValid
    }
    
    func setIsNicknameValid(isValid: Bool) {
        isNicknameValid = isValid
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
        if !passwordValidator(confirmNewPassowrd) {
            confirmPasswordValidationMsg = "password_form_error"
        } else if newPassword != confirmNewPassowrd {
            confirmPasswordValidationMsg = "password_not_match"
        }
        
            
    }
    
    func resetConfirmPasswordValidationMsg() {
        confirmPasswordValidationMsg = ""
    }
    
    func setDateValidationMsg(){
        dateValidationMsg = "date_invalid"
    }
    
    func resetDateValidationMsg(){
        dateValidationMsg = ""
    }
    
    func setNicknameValidationMsg(){
        nicknameValidationMsg = "nickname_occupied"
    }
    
    func resetNicknameValidationMsg(){
        nicknameValidationMsg = ""
    }
    
    func resetBirthdateValidationMsg(){
        dateValidationMsg = ""
    }
    
    func resetValidationState(){
        isValidEmail = true
        isValidPassword = true
        isVerificationCodeValid = true
        isDateValid = true 
        isNicknameValid = true
        isDateValid = true
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
            setEmailValidationMsg(msg: .formError, context: .login)
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
    
    func validateDate() -> Bool {
        if dateValidator(birthdate) {
            setIsDateValid(isValid: true)
            return true
        }
        setIsDateValid(isValid: false)
        setDateValidationMsg()
        
        return false
    }
}
