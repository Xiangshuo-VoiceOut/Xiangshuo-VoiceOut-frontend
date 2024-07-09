//
//  UserSignUpVM.swift
//  voiceout
//
//  Created by J. Wu on 7/7/24.
//

import Foundation

class UserSignUpVM: ObservableObject {
    @Published var isNextStepEnabled: Bool = false
    @Published var isUserSignUpEnabled: Bool = false
    @Published var selectedState: DropdownOption? = nil
    @Published var selectedGender: DropdownOption? = nil
    
    var allStates : [DropdownOption] {
        return StateData.allStates.map{ DropdownOption(option: $0.code)}
    }
    
    private var textInputVM: TextInputVM
    
    init(textInputVM: TextInputVM) {
        self.textInputVM = textInputVM
    }
    
    func handleButtonClick() {
        if !textInputVM.validateEmail() {
            isNextStepEnabled = false
            return
        }
        
        if !textInputVM.validatePassword() || !textInputVM.isMatchedPasswords() {
            return
        }
        
        /***
            TODO:
                1.check if verificationCode Valid
                2.check if email alreay registered
                3. check if nickname already existed
         ***/
        
    }
    
    
    
    func updateNextStepButtonState() {
        let inputsAllFilled = !textInputVM.email.isEmpty && !textInputVM.verificationCode.isEmpty && !textInputVM.newPassword.isEmpty && !textInputVM.confirmNewPassowrd.isEmpty
        
        if !inputsAllFilled {
            isNextStepEnabled = false
        } else {
            isNextStepEnabled = true
        }
    }
    
    func updateUserSignUpButtonState() {
        let inputsAllFilled = !textInputVM.nickname.isEmpty && selectedState != nil && !textInputVM.newPassword.isEmpty && selectedGender != nil
        
        if !inputsAllFilled {
            isUserSignUpEnabled = false
        } else {
            isUserSignUpEnabled = true
        }
    }
    
}
