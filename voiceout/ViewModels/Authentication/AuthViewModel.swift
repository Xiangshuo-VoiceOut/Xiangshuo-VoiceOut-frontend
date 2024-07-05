//
//  AuthViewModel.swift
//  voiceout
//
//  Created by J. Wu on 5/25/24.
//

import Foundation

class AuthViewModel: ObservableObject {
    @Published var showingUserMainPage: Bool = false
    @Published var showingTherapistMainPage: Bool = false
    @Published var isLoginEnabled: Bool = false
    var role: UserRole
    private var textInputVM: TextInputVM
    private var loginService = LoginWebService()
    
    init(role: UserRole, textInputVM: TextInputVM) {
        self.role = role
        self.textInputVM = textInputVM
    }
    
    func login() {
        if !textInputVM.validateEmail()  {
            return
        }
        
        switch role {
        case .user:
            loginService.login(email: textInputVM.email, password: textInputVM.password, role: .user, completions: handleLoginResult)
        case .therapist:
            loginService.login(email: textInputVM.email, password: textInputVM.password, role: .therapist, completions: handleLoginResult)
        }
    }
    
    private func handleLoginResult(result: Result<String, AuthenticationError>) {
        DispatchQueue.main.async {
            switch result {
            case .success (let token):
                switch self.role {
                case .user:
                    self.showingUserMainPage = true
                case .therapist:
                    self.showingTherapistMainPage = true
                }
            case.failure(let error):
                self.handleValidationErrors(error)
            }
        }
    }
    
    
    private func handleValidationErrors(_ error: AuthenticationError) {
        switch error {
        case .userNotFound:
            textInputVM.setIsValidEmail(isValid: false)
            textInputVM.setEmailValidationMsg(msg: .notExist)
        case .incorrectPasswordOrEmail:
            textInputVM.setIsValidEmail(isValid: false)
            textInputVM.setIsValidPassword(isValid: false)
            textInputVM.setEmailValidationMsg(msg: .loginError)
        default:
            textInputVM.setIsValidEmail(isValid: false)
            textInputVM.setEmailValidationMsg(msg: .serverError) //TODO: double check with design team & backend
        }
    }
    
    func resetValidateState() {
        textInputVM.setIsValidEmail(isValid: true)
        textInputVM.setIsValidPassword(isValid: true)
        textInputVM.resetEmailValidationMsg()
    }
    
    func validateInput() {
        isLoginEnabled = !textInputVM.email.isEmpty && !textInputVM.password.isEmpty
    }
}


