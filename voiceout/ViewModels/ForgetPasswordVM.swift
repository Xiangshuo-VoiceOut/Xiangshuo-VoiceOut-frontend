//
//  ForgetPasswordVM.swift
//  voiceout
//
//  Created by J. Wu on 5/28/24.
//

import Foundation
import Combine

class ForgetPWViewModel : ObservableObject {
    @Published var email: String = ""
    @Published var isEmailValid: Bool = true
    @Published var verificationCode: String = ""
    @Published var isVerificationCodeValid: Bool = true
    @Published var isVerificationCodeSent: Bool = false
    @Published var timerValue: Int = 300
    @Published var isNextButtonEnabled: Bool = false
    @Published var emailValidationMessage: String = ""
    @Published var verificationCodeValidationMsg: String = ""
    var role: UserRole = .user
    
    private var resetRequestService = ResetPasswordWebService()
    private var timer: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    var verificationToken: String? = nil
    
    func sendVerificationCode() {
            if !validateEmail() {
                return
            }
            
        resetRequestService.requestPasswordReset(email: email, role: role) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let message):
                        self?.verificationToken = message
                        self?.isVerificationCodeSent = true
                        self?.startTimer()
                    case .failure(let error):
                        self?.handleSendCodeErrors(error: error)
                    }
                }
            }
        }
    
    private func handleSendCodeErrors(error: Error) {
            if let error = error as? GetVerificationCodeError, error == .userNotFound {
                emailValidationMessage = "email_not_exist"
                isEmailValid = false
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
            guard let token = verificationToken, !verificationCode.isEmpty else {
                verificationCodeValidationMsg = "请输入验证码"
                isVerificationCodeValid = false
                return
            }
            
        resetRequestService.validateResetToken(role: role) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let isValid):
                    if isValid {
                        self?.verificationCodeValidationMsg = ""
                        self?.isVerificationCodeValid = true
                    } else {
                        self?.verificationCodeValidationMsg = "verification_wrong"
                        self?.isVerificationCodeValid = false
                    }
                case .failure(_):
                    self?.verificationCodeValidationMsg = "verification_wrong"
                    self?.isVerificationCodeValid = false
                }
                self?.validateInputs()
            }
        }
    }
    
    
    func resetValidateState(){
        isEmailValid = true
        isVerificationCodeValid = true
        emailValidationMessage = ""
        verificationCodeValidationMsg = ""
    }
    
    func validateEmail() -> Bool {
        if !isValidEmail(email) {
            isEmailValid = false
            emailValidationMessage = "email_form_error"
            return false
        } else {
            isEmailValid = true
            emailValidationMessage = ""
            return true
        }
        
    }
    
    func validateInputs(){
        isNextButtonEnabled = !email.isEmpty && !verificationCode.isEmpty
    }
    
    
}
