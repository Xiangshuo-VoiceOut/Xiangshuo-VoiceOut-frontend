//
//  UserSignUpView.swift
//  voiceout
//
//  Created by J. Wu on 7/7/24.
//

import SwiftUI

struct UserSignUpView: View {
    @StateObject var router: RouterModel = RouterModel()
    @StateObject private var userSignUpVM : UserSignUpVM
    @StateObject private var textInputVM: TextInputVM
    @StateObject private var verificationCodeVM: VerificationCodeVM
    @State private var currentStep: SignUpStep = .step2
    
    
    init() {
        let model = TextInputVM()
        _textInputVM = StateObject(wrappedValue: model)
        _userSignUpVM = StateObject(wrappedValue: UserSignUpVM(textInputVM: model))
        _verificationCodeVM = StateObject(wrappedValue: VerificationCodeVM(role: .user, textInputVM: model))
    }
    
    enum SignUpStep {
        case step1, step2
    }
    
    var body: some View {
        ZStack{
            BackgroundView()
            
            VStack{
                HeaderView()
                
                VStack {
                    switch currentStep {
                    case .step1:
                        step1View
                    case .step2:
                        step2View
                    }
                }
                .padding(ViewSpacing.medium)
                .background(Color.surfacePrimary)
                .cornerRadius(CornerRadius.medium.value)
                .shadow(color: Color(.grey200),radius: CornerRadius.xxsmall.value)
                .padding(.horizontal,ViewSpacing.xlarge)
                
            }
            .offset(y: -40)
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        router.navigateTo(.userLogin)
                    }) {
                        Text("sign_in")
                            .font(.typography(.bodyMedium))
                            .foregroundColor(.black.opacity(0.69))
                    }
                }
            }
            .navigationDestination(isPresented: $userSignUpVM.isNextStepEnabled) {}
        }
        .ignoresSafeArea()
        .onChange(of: textInputVM.email) {_ in
            userSignUpVM.validateInput()
            userSignUpVM.resetValidateState()
        }
        .onChange(of: textInputVM.newPassword) {_ in
            userSignUpVM.validateInput()
            userSignUpVM.resetValidateState()
        }
        .onChange(of: textInputVM.confirmNewPassowrd) {_ in
            userSignUpVM.validateInput()
            userSignUpVM.resetValidateState()
            
        }
    }
    
    private var step1View: some View {
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
            .padding(.bottom)
            
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
            .padding(.bottom)
            
            SecuredTextInputView(
                text: $textInputVM.newPassword,
                securedPlaceholder: "password_placeholder",
                securedValidation: textInputVM.isValidPassword ? .neutral : .error,
                validationMsg: textInputVM.newPasswordValidationMsg, prefixIcon: "lock"
            )
            .padding(.bottom)
            
            SecuredTextInputView(
                text: $textInputVM.confirmNewPassowrd,
                securedPlaceholder: "password_placeholder",
                securedValidation: textInputVM.isValidPassword ? .neutral : .error,
                prefixIcon: "lock"
            )
            .padding(.bottom, ViewSpacing.large)
            ButtonView(text: "next_step",
                       action: {},
                       theme: .base, spacing: .large
                       
            )
        }
    .background(Color.surfacePrimary)
    }
    
    private var step2View: some View {
        VStack{
            TextInputView(
                text: $textInputVM.nickname,
                isSecuredField: false,
                placeholder: "nickname_placeholder",
                prefixIcon: "email",
                validationState: textInputVM.isValidEmail ? ValidationState.neutral : ValidationState.error,
                validationMessage: textInputVM.emailValidationMsg
            )
            .autocapitalization(.none)
            .padding(.bottom)
            
            
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
            .padding(.bottom)
            
            SecuredTextInputView(
                text: $textInputVM.newPassword,
                securedPlaceholder: "password_placeholder",
                securedValidation: textInputVM.isValidPassword ? .neutral : .error,
                validationMsg: textInputVM.newPasswordValidationMsg, prefixIcon: "lock"
            )
            .padding(.bottom)
            
            SecuredTextInputView(
                text: $textInputVM.confirmNewPassowrd,
                securedPlaceholder: "password_placeholder",
                securedValidation: textInputVM.isValidPassword ? .neutral : .error,
                prefixIcon: "lock"
            )
            .padding(.bottom, ViewSpacing.large)
            ButtonView(text: "next_step",
                       action: {},
                       theme: .base, spacing: .large
                       
            )
        }
    .background(Color.surfacePrimary)
    }
}

#Preview {
    UserSignUpView()
        .environmentObject(RouterModel())
}
