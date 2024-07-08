//
//  UserSignUpVM.swift
//  voiceout
//
//  Created by J. Wu on 7/7/24.
//

import Foundation

class UserSignUpVM: ObservableObject {
    @Published var isNextStepEnabled: Bool = false
    
    private var textInputVM: TextInputVM
    
    init(textInputVM: TextInputVM) {
        self.textInputVM = textInputVM
    }
    
    func validateInput(){
        
    }
    
    func resetValidateState(){
        
    }
    
    
    
    func updateButtonState() {
        let inputsAllFilled = !textInputVM.email.isEmpty && !textInputVM.verificationCode.isEmpty && !textInputVM.newPassword.isEmpty && !textInputVM.confirmNewPassowrd.isEmpty
        
        if !inputsAllFilled {
            isNextStepEnabled = false
        } else {
            isNextStepEnabled = true
        }
    }
    
}
