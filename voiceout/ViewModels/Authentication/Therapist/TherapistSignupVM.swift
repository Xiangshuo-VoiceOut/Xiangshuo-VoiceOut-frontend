//
//  TherapistSignupVM.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 7/2/24.
//

import Foundation

class TherapistSignupVM: ObservableObject {
    @Published var isButtonEnabled: Bool = false
    @Published var isSignupSuccess: Bool = false

    private var textInputVM: TextInputVM

    init(textInputVM: TextInputVM) {
        self.textInputVM = textInputVM
    }

    func setIsSignupSuccess(isSuccess: Bool) {
        isSignupSuccess = isSuccess
    }

    func handleButtonClick() {
        if !textInputVM.validateEmail() {
            isButtonEnabled = false
            return
        }

        if !textInputVM.validatePassword() || !textInputVM.isMatchedPasswords() {
            return
        }

        // TODO:  connect to webservice to check if email already regiestered
        setIsSignupSuccess(isSuccess: true)
    }

    func updateButtonState() {
        let inputsAllFilled = !textInputVM.email.isEmpty && !textInputVM.verificationCode.isEmpty && !textInputVM.newPassword.isEmpty &&
        !textInputVM.confirmNewPassowrd.isEmpty

        if !inputsAllFilled {
            isButtonEnabled = false
        } else {
            isButtonEnabled = true
        }
    }
}
