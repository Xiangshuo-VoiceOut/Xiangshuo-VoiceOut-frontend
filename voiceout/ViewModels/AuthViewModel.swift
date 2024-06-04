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
    @Published var showingMainPage: Bool = false
    @Published var emailValidationMsg = ""
    @Published var isLoginEnabled: Bool = false
    
    private var loginService = LoginWebService()
    
    func login(){
        
        if !validateEmail() {
            return
        }
        
        loginService.login(email: email, password: password, completions: { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let token):
                    self?.showingMainPage = true
                case .failure(let error):
                    self?.handleValidationErrors(error)
                }
            
            }
            
        })
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
        case .na:
            break
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


