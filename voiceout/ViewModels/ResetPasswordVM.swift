//
//  ResetPasswordVM.swift
//  voiceout
//
//  Created by J. Wu on 5/28/24.
//

import Foundation

class ResetPasswordVM : ObservableObject {
    @Published var newPassword: String = ""
    @Published var confirmNewPW: String = ""
    @Published var isNewPWValid: Bool = true
    @Published var isRepeatPWValid: Bool = true
    @Published var isResetSuccessful: Bool = false
    @Published var resetPasswordValidationMsg: String = "password_requirement"
    @Published var repeatPasswordValidationMsg: String = ""
    @Published var isFinishButtonEnabled: Bool = false
    
    private var webservice = ResetPasswordWebService()
    
    func resetPassword(){
        webservice.resetPassword(newPassword: newPassword, completion: { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case.success(_):
                    self?.resetPasswordValidationMsg = ""
                    self?.isResetSuccessful = true
                case.failure(let error):
                    self?.resetPasswordValidationMsg = ""
                    self?.isResetSuccessful = false
                }
            }
            
        })
    }
    
    
    func validateInputs(){
        isFinishButtonEnabled = !newPassword.isEmpty && !confirmNewPW.isEmpty
    }
    
    func isValidReInput() -> Bool {
        return confirmNewPW == newPassword
    }
}
