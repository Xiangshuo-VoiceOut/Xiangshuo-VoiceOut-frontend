//
//  SignUpStep1.swift
//  voiceout
//
//  Created by J. Wu on 8/11/24.
//

import SwiftUI

struct SignUpStep1: View {
    @ObservedObject var textInputVM: TextInputVM
    @ObservedObject var verificationCodeVM: VerificationCodeVM
    @ObservedObject var userSignUpVM: UserSignUpVM
    @Binding var currentStep: SignUpStep
    
    var body: some View {
        VStack{
            TextInputView(
                text: $textInputVM.email,
                isSecuredField: false,
                placeholder: "email_placeholder",
                prefixIcon: "email",
                validationState: textInputVM.isValidEmail ? ValidationState.neutral : ValidationState.error,
                validationMessage: textInputVM.emailValidationMsg
            )
            .autocapitalization(.none)
            
            TextInputView(
                text: $textInputVM.verificationCode,
                isSecuredField: false,
                placeholder: "input_verification_code",
                prefixIcon: "protect",
                validationState: textInputVM.isVerificationCodeValid ? ValidationState.neutral : ValidationState.error,
                suffixContent: AnyView(
                    VerificationCodeButton()
                        .environmentObject(verificationCodeVM)
                        .environmentObject(textInputVM)
            )
            )
            
            
            SecuredTextInputView(
                text: $textInputVM.newPassword,
                securedPlaceholder: "password_placeholder",
                securedValidation: textInputVM.isValidPassword ? .neutral : .error,
                validationMsg: textInputVM.newPasswordValidationMsg, prefixIcon: "lock"
            )
            
            SecuredTextInputView(
                text: $textInputVM.confirmNewPassowrd,
                securedPlaceholder: "password_placeholder",
                securedValidation: textInputVM.isValidPassword ? .neutral : .error,
                validationMsg: textInputVM.confirmPasswordValidationMsg,
                prefixIcon: "lock"
            )
            
            ButtonView(text: "next_step",
                       action: {
                userSignUpVM.goToNextPage()
                if userSignUpVM.nextPageAvailable {
                    currentStep = .step2
                }
            },
                       theme: userSignUpVM.isNextStepEnabled ? .action : .base, maxWidth: .infinity
                       
            )
            .disabled(!userSignUpVM.isNextStepEnabled)
        }
    .background(Color.surfacePrimary)
    }
}

//#Preview {
//    SignUpStep1(textInputVM: <#TextInputVM#>, verificationCodeVM: <#VerificationCodeVM#>, userSignUpVM: <#UserSignUpVM#>, currentStep: <#Binding<SignUpStep>#>)
//}
