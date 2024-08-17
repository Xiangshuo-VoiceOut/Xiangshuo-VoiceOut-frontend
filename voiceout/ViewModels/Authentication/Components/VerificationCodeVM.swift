//
//  ForgetPasswordVM.swift
//  voiceout
//
//  Created by J. Wu on 5/28/24.
//

import Foundation
import Combine

class VerificationCodeVM : ObservableObject {
    @Published var isVerificationCodeSent: Bool = false
    @Published var timerValue: Int = 300
    @Published var isNextButtonEnabled: Bool = false
    private var textInputVM: TextInputVM
    var role: UserRole
    
    init(role: UserRole, textInputVM: TextInputVM) {
        self.role = role
        self.textInputVM = textInputVM
    }
    
    private var resetRequestService = ResetPasswordWebService()
    private var timer: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    var verificationToken: String? = nil
    
    func sendVerificationCode() {
        if !textInputVM.validateEmail() {
            return
        }
            
        resetRequestService.requestPasswordReset(email: textInputVM.email, role: role) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let message):
                    self?.verificationToken = message
                    self?.isVerificationCodeSent = true
                    self?.startTimer()
                    self?.handleVerificationSuccess(token: message, expiryTime:36000)
                case .failure(let error):
                    self?.handleSendCodeErrors(error: error)
                }
            }
        }
    }
    
    func handleVerificationSuccess(token: String, expiryTime: TimeInterval) {
        UserDefaults.standard.set(token, forKey: "resetToken")
        UserDefaults.standard.set(Date().addingTimeInterval(expiryTime), forKey: "resetTokenExpiry")
    }
    
    private func handleSendCodeErrors(error: Error) {
        if let error = error as? GetVerificationCodeError, error == .userNotFound {
            textInputVM.setEmailValidationMsg(msg: .notExist, context: .login)
            textInputVM.setIsValidEmail(isValid: false)
        } else {
            return
        }
    }
    
    private func startTimer() {
        self.timerValue = 300
        self.timer?.cancel()
        
        self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect().sink {[weak self] _ in
            guard let self = self else {return}
            if self.timerValue > 0 {
                self.timerValue -= 1
            } else {
                self.timer?.cancel()
                self.isVerificationCodeSent = false
            }
            
        }
    }
    
    func isVerificationValid() {
        guard let token = verificationToken, !textInputVM.verificationCode.isEmpty else {
                textInputVM.setVerificationCodeValidationMsg(msg: .enterCode)
                textInputVM.setIsVerificationCodeValid(isValid: false)
                return
            }
            
        resetRequestService.validateResetToken(verificationCode: textInputVM.verificationCode, role: role) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let isValid):
                    if isValid {
                        self?.textInputVM.resetVerificationCodeValidationMsg()
                        self?.textInputVM.setIsVerificationCodeValid(isValid: true)
                    } else {
                        self?.textInputVM.setVerificationCodeValidationMsg(msg: .invalidVerification)
                        self?.textInputVM.setIsVerificationCodeValid(isValid: false)
                    }
                case .failure(_):
                    self?.textInputVM.setVerificationCodeValidationMsg(msg: .invalidVerification)
                    self?.textInputVM.setIsVerificationCodeValid(isValid: false)
                }
                self?.validateInputs()
            }
        }
    }
    
    
    func resetValidateState() {
        textInputVM.setIsValidEmail(isValid: true)
        textInputVM.resetEmailValidationMsg()
        textInputVM.setIsVerificationCodeValid(isValid: true)
        textInputVM.resetVerificationCodeValidationMsg()
    }
    
    func validateInputs(){
        isNextButtonEnabled = !textInputVM.email.isEmpty && !textInputVM.verificationCode.isEmpty
    }
    
    
}
