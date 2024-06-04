//
//  ResetPasswordVM.swift
//  voiceout
//
//  Created by J. Wu on 5/28/24.
//

import Foundation
import Combine

class ResetPasswordVM : ObservableObject {
    @Published var newPassword: String = ""
    @Published var confirmNewPW: String = ""
    @Published var isNewPWValid: Bool = true
    @Published var isRepeatPWValid: Bool = true
    @Published var isResetSuccessful: Bool = false
    @Published var resetPasswordValidationMsg: String = "password_requirement"
    @Published var repeatPasswordValidationMsg: String = ""
    @Published var isFinishButtonEnabled: Bool = false
    
    
    func validateInputs(){
        isFinishButtonEnabled = !newPassword.isEmpty && !confirmNewPW.isEmpty
    }
}
