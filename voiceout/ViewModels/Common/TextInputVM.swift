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

enum EmailValidationContext {
    case login
    case signup
}

class TextInputVM: ObservableObject {
    // email
    @Published var email: String = ""
    @Published var newEmail: String = ""
    @Published var isValidEmail: Bool = true
    @Published var emailValidationMsg: String = ""
    @Published var isValidNewEmail: Bool = true
    @Published var newEmailValidationMsg: String = ""

    // password
    @Published var password: String = ""
    @Published var newPassword: String = ""
    @Published var confirmNewPassowrd: String = ""
    @Published var isValidPassword: Bool = true
    @Published var newPasswordValidationMsg: String = "password_requirement"
    @Published var confirmPasswordValidationMsg: String = ""

    // verification code
    @Published var verificationCode: String = ""
    @Published var isVerificationCodeValid: Bool = true
    @Published var verificationCodeValidationMsg: String = ""

    // nickname
    @Published var nickname: String = ""
    @Published var isNicknameValid: Bool = true
    @Published var nicknameValidationMsg: String = ""

    // date
    @Published var date: String = ""
    @Published var isDateValid: Bool = true
    @Published var dateValidationMsg: String = ""

    // phone number
    @Published var phoneNumber: String = ""
    @Published var isValidPhoneNumber: Bool = true
    @Published var phoneNumberValidationMsg: String = ""

    func setEmailValidationMsg(msg: EmailValidationMessage, context: EmailValidationContext) {
        switch context {
        case .login:
            switch msg {
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
            switch msg {
            case .formError:
                emailValidationMsg = "email_form_error"
            case .alreadyExist:
                emailValidationMsg = "email_already_exist"
            default:
                emailValidationMsg = "network_error"

            }
        }
    }

    func setConfirmPasswordValidationMsg() {
        if !passwordValidator(confirmNewPassowrd) {
            confirmPasswordValidationMsg = "password_form_error"
        } else if newPassword != confirmNewPassowrd {
            confirmPasswordValidationMsg = "password_not_match"
        }
    }

    func setVerificationCodeValidationMsg(msg: VerificationCodeValidationMessage) {
        switch msg {
        case .enterCode:
            verificationCodeValidationMsg = "input_verification_code"
        case .invalidVerification:
            verificationCodeValidationMsg = "verification_wrong"
        }
    }

    func setNicknameValidationMsg() {
        nicknameValidationMsg = "nickname_occupied"
    }

    func resetBirthdateValidationMsg() {
        dateValidationMsg = ""
    }

    func resetValidationState() {
        isValidEmail = true
        emailValidationMsg = ""
        isValidPassword = true
        confirmPasswordValidationMsg = ""
        isVerificationCodeValid = true
        verificationCodeValidationMsg = ""
        isDateValid = true
        dateValidationMsg = ""
        isNicknameValid = true
        nicknameValidationMsg = ""
    }

    func validateEmail() {
        if emailValidator(email) {
            isValidEmail = true
            emailValidationMsg = ""
        } else {
            isValidEmail = false
            setEmailValidationMsg(msg: .formError, context: .login)
        }
    }

    func validatePassword() {
        if passwordValidator(newPassword) {
            isValidPassword = true
            confirmPasswordValidationMsg = ""
        } else {
            isValidPassword = false
            setConfirmPasswordValidationMsg()
        }
    }

    func isMatchedPasswords() -> Bool {
        if newPassword == confirmNewPassowrd {
            isValidPassword = true
            confirmPasswordValidationMsg = ""
            return true
        }
        isValidPassword = false
        setConfirmPasswordValidationMsg()
        return false
    }

    func validateDate() {
        if dateMonthYearValidator(date) {
            isDateValid = true
            dateValidationMsg = ""
        } else {
            isDateValid = false
            dateValidationMsg = "invalid_date"
        }
    }

    func validatePhoneNumber() {
        if phoneNumberValidator(phoneNumber) {
            isValidPhoneNumber = true
            phoneNumberValidationMsg = ""
        } else {
            isValidPhoneNumber = false
            phoneNumberValidationMsg = "invalid_phone_number"
        }
    }
}
