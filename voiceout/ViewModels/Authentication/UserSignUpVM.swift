//
//  UserSignUpVM.swift
//  voiceout
//
//  Created by J. Wu on 7/7/24.
//

import Foundation

class UserSignUpVM: ObservableObject {
    @Published var isNextStepEnabled: Bool = false
    @Published var isUserSignUpEnabled: Bool = false
    @Published var nextPageAvailable: Bool = false
    @Published var isSignUpSuccessfully: Bool = false
    @Published var selectedState: DropdownOption?
    @Published var selectedGender: DropdownOption?
    private var userSignUpWebService = UserSignUpWebService()

    var allStates: [DropdownOption] {
        return StateData.allStates.map { DropdownOption(option: $0.code)}
    }

    private var textInputVM: TextInputVM

    init(textInputVM: TextInputVM) {
        self.textInputVM = textInputVM
    }

    func goToNextPage() {
        if !textInputVM.validateEmail() {
            return
        }

        if !textInputVM.validatePassword() || !textInputVM.isMatchedPasswords() {
            return
        }

        if textInputVM.verificationCode.isEmpty {
            textInputVM.isVerificationCodeValid = false
            textInputVM.setVerificationCodeValidationMsg(msg: .enterCode)
            return
        }

        nextPageAvailable = true

    }

    func userSignUp() {
        if !textInputVM.validateDate() {
            return
        }
        guard let stateOption = selectedState?.option,
                let genderOption = selectedGender?.option else {
            return
        }
        userSignUpWebService.userSignUp(
            email: textInputVM.email,
            password: textInputVM.newPassword,
            otp: textInputVM.verificationCode,
            nickname: textInputVM.nickname,
            state: stateOption,
            birthdate: textInputVM.birthdate,
            gender: genderOption,
            completions: handleUserLoginResult
        )
    }

    private func handleUserLoginResult(result: Result<String, SignUpError>) {
        DispatchQueue.main.async {
            switch result {
            case.success(let token):
                self.handleUserSignUpSuccess(token: token)
            case .failure(let error):
                self.handleUserSignUpFailure(error)
            }
        }
    }

    private func handleUserSignUpSuccess(token: String) {
        isSignUpSuccessfully = true
    }

    private func handleUserSignUpFailure(_ error: SignUpError) {
        switch error {
        case .userExists:
            textInputVM.setIsValidEmail(isValid: false)
            textInputVM.setEmailValidationMsg(msg: .alreadyExist, context: .signup)
        case .verificationCodeError:
            textInputVM.setIsVerificationCodeValid(isValid: false)
            textInputVM.setVerificationCodeValidationMsg(msg: .invalidVerification)
        case .nicknameExists:
            textInputVM.setIsValidEmail(isValid: false)
            textInputVM.setNicknameValidationMsg()
        case .na:
            isSignUpSuccessfully = false

        }
    }

    func updateNextStepButtonState() {
        let inputsAllFilled = !textInputVM.email.isEmpty && !textInputVM.verificationCode.isEmpty && !textInputVM.newPassword.isEmpty &&
        !textInputVM.confirmNewPassowrd.isEmpty

        if !inputsAllFilled {
            isNextStepEnabled = false
        } else {
            isNextStepEnabled = true
        }
    }

    func updateUserSignUpButtonState() {
        let allCompleted = !textInputVM.nickname.isEmpty && selectedState != nil && !textInputVM.birthdate.isEmpty && selectedGender != nil
        if !allCompleted {
            isUserSignUpEnabled = false
        } else {
            isUserSignUpEnabled = true
        }
    }

}
