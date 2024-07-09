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
    @State private var currentStep: SignUpStep = .step1
    
    
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
            .offset(y: -50)
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        router.navigateTo(.userLogin)
                    }) {
                        Text("login")
                            .font(.typography(.bodyMedium))
                            .foregroundColor(.black.opacity(0.69))
                    }
                }
            }
            .navigationDestination(isPresented: $userSignUpVM.isNextStepEnabled) {}
            
        }
        .navigationBarBackButtonHidden()
        .ignoresSafeArea()
        .onChange(of: textInputVM.email) {_ in
            textInputVM.resetEmailValidationMsg()
            textInputVM.resetValidationState()
            userSignUpVM.updateNextStepButtonState()
        }
        .onChange(of: textInputVM.verificationCode) {_ in
            textInputVM.resetVerificationCodeValidationMsg()
            textInputVM.resetValidationState()
            userSignUpVM.updateNextStepButtonState()
        }
        .onChange(of: textInputVM.newPassword) {_ in
            textInputVM.resetValidationState()
            textInputVM.resetConfirmPasswordValidationMsg()
            userSignUpVM.updateNextStepButtonState()
        }
        .onChange(of: textInputVM.confirmNewPassowrd) {_ in
            textInputVM.resetConfirmPasswordValidationMsg()
            textInputVM.resetValidationState()
            userSignUpVM.updateNextStepButtonState()
            
        }
        .onChange(of: textInputVM.nickname) {_ in
            userSignUpVM.updateNextStepButtonState()
        }
        .onChange(of: userSignUpVM.selectedState) {_ in
            userSignUpVM.updateNextStepButtonState()
        }
        .onChange(of: textInputVM.birthday) {_ in
            userSignUpVM.updateNextStepButtonState()
        }
        .onChange(of: userSignUpVM.selectedGender) {_ in
            userSignUpVM.updateNextStepButtonState()
            
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
                       action: {userSignUpVM.handleButtonClick()},
                       theme: userSignUpVM.isNextStepEnabled ? .action : .base, maxWidth: .infinity
                       
            )
            .disabled(!userSignUpVM.isNextStepEnabled)
        }
    .background(Color.surfacePrimary)
    }
    
    private var step2View: some View {
        VStack{
            TextInputView(
                text: $textInputVM.nickname,
                isSecuredField: false,
                placeholder: "nickname_placeholder",
                prefixIcon: "user",
                validationState: textInputVM.isValidEmail ? ValidationState.neutral : ValidationState.error,
                validationMessage: textInputVM.emailValidationMsg
            )
            .autocapitalization(.none)
            
            
            Dropdown(selectionOption: $userSignUpVM.selectedState, prefixIcon:"local", placeholder: String(localized: "state_placeholder"), options: userSignUpVM.allStates)
                .padding(.bottom)
                .zIndex(2)
            
            TextInputView(
                text: $textInputVM.birthday,
                isSecuredField: false,
                placeholder: "input_birthday",
                prefixIcon: "birthday-cake",
                validationState: textInputVM.isVerificationCodeValid ? ValidationState.neutral : ValidationState.error
            )
            .onChange(of: textInputVM.birthday) { newValue in
                textInputVM.birthday = formatDateString(newValue)
                
            }
            
            
            Dropdown(selectionOption: $userSignUpVM.selectedGender, prefixIcon:"public-toilet", placeholder: String(localized: "gender_placeholder"), options: DropdownOption.genders)
                .padding(.bottom, ViewSpacing.large)
                .zIndex(1)
            
            ButtonView(text: "signup",
                       action: {
                userSignUpVM.handleButtonClick()
            },
                       theme: userSignUpVM.isUserSignUpEnabled ? .action : .base, maxWidth: .infinity
                       
            )
            .disabled(!userSignUpVM.isUserSignUpEnabled)
        }
    .background(Color.surfacePrimary)
    }
}

#Preview {
    UserSignUpView()
        .environmentObject(RouterModel())
}

