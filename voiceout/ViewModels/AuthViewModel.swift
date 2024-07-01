//
//  AuthViewModel.swift
//  voiceout
//
//  Created by J. Wu on 5/25/24.
//

import Foundation

class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isEmailValid: Bool = true
    @Published var isPasswordValid: Bool = true
    @Published var showingUserMainPage: Bool = false
    @Published var showingTherapistMainPage: Bool = false
    @Published var emailValidationMsg = ""
    @Published var isLoginEnabled: Bool = false
    var role: UserRole
    
    init(role: UserRole) {
        self.role = role
    }
    
    private var loginService = LoginWebService()
    
    func login(){
        
        if !validateEmail() {
            return
        }
        
        switch role {
        case .user:
            loginService.login(email: email, password: password, role: .user, completions: handleLoginResult)
        case .therapist:
            loginService.login(email: email, password: password, role: .therapist, completions: handleLoginResult)
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
            isEmailValid = false
            emailValidationMsg = "email_not_exist"
        case .incorrectPasswordOrEmail:
            isEmailValid = false
            isPasswordValid = false
            emailValidationMsg = "login_error"
        default:
            isEmailValid = false
            emailValidationMsg = "服务器错误" //TODO: double check with design team & backend
        }
    }
    
    func validateEmail() -> Bool {
        if !isValidEmail(email) {
            isEmailValid = false
            emailValidationMsg = "email_form_error"
            return false
        } else {
            isEmailValid = true
            emailValidationMsg = ""
            return true
        }
    }
    
    func resetValidateState(){
        isEmailValid = true
        isPasswordValid = true
        emailValidationMsg = ""
    }
    
    func validateInput() {
        isLoginEnabled = !email.isEmpty && !password.isEmpty
    }
}


