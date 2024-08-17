//
//  ResetPasswordVM.swift
//  voiceout
//
//  Created by J. Wu on 5/28/24.
//

import Foundation

class ResetPasswordVM : ObservableObject {
    @Published var isNextStepActive: Bool = false
    @Published var isResetSuccessful: Bool = false
    @Published var isFinishButtonEnabled: Bool = false
    private var textInputVM: TextInputVM
    var role: UserRole
    private var webservice = ResetPasswordWebService()
    
    init(role: UserRole, textInputVM: TextInputVM) {
        self.role = role
        self.textInputVM = textInputVM
    }
    
    func resetPassword(){
        if !textInputVM.validatePassword() || !textInputVM.isMatchedPasswords() {
            return
        }
        webservice.resetPassword(newPassword: textInputVM.newPassword, role: role, completion: { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case.success(_):
                    self?.textInputVM.resetNewPasswordValidationMsg()
                    self?.isResetSuccessful = true
                case.failure(let error):
                    self?.textInputVM.resetNewPasswordValidationMsg()
                    self?.isResetSuccessful = false
                }
            }
            
        })
    }
    
    private func handleVerificationCodeErrors(_ error: GetVerificationCodeError) {
        switch error{
        case .userNotFound:
            textInputVM.setIsValidEmail(isValid: false)
            textInputVM.setEmailValidationMsg(msg: .notExist, context: .login)
        default:
            textInputVM.setIsVerificationCodeValid(isValid: false)
            textInputVM.setVerificationCodeValidationMsg(msg: .invalidVerification)
        }
        
    }
    
    func validateNext(){
        
        isNextStepActive = textInputVM.isValidEmail && textInputVM.isVerificationCodeValid
    }
    
    func handleInputsFilled() {
        isFinishButtonEnabled = !textInputVM.newPassword.isEmpty && !textInputVM.confirmNewPassowrd.isEmpty
    }
    
    func isValidReInput() -> Bool {
        return textInputVM.confirmNewPassowrd == textInputVM.newPassword
    }
}
