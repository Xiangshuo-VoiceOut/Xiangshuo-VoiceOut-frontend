//
//  UserSignUpView.swift
//  voiceout
//
//  Created by J. Wu on 7/7/24.
//

import SwiftUI

enum SignUpStep {
    case step1, step2
}

struct UserSignUpView: View {
    @EnvironmentObject var router: RouterModel
    @StateObject private var userSignUpVM: UserSignUpVM
    @StateObject private var textInputVM: TextInputVM
    @StateObject private var verificationCodeVM: VerificationCodeVM
    @State private var currentStep: SignUpStep = .step1

    init() {
        let model = TextInputVM()
        _textInputVM = StateObject(wrappedValue: model)
        _userSignUpVM = StateObject(wrappedValue: UserSignUpVM(textInputVM: model))
        _verificationCodeVM = StateObject(wrappedValue: VerificationCodeVM(role: .user, textInputVM: model))
    }

    var body: some View {
        ZStack {
            BackgroundView()

            VStack(spacing: ViewSpacing.large) {
                HeaderView()

                VStack {
                    switch currentStep {
                    case .step1:
                        SignUpStep1(
                            textInputVM: textInputVM,
                            verificationCodeVM: verificationCodeVM,
                            userSignUpVM: userSignUpVM,
                            currentStep: $currentStep
                        )
                    case .step2:
                        SignUpStep2(
                            textInputVM: textInputVM,
                            userSignUpVM: userSignUpVM
                        )
                    }
                }
                .frameStyle()
            }
            .toolbar {
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
            textInputVM.resetNicknameValidationMsg()
            textInputVM.resetValidationState()
            userSignUpVM.updateUserSignUpButtonState()

        }
        .onChange(of: textInputVM.birthdate) {_ in
            textInputVM.resetValidationState()
            textInputVM.resetBirthdateValidationMsg()
            userSignUpVM.updateUserSignUpButtonState()
        }
    }
}

#Preview {
    UserSignUpView()
        .environmentObject(RouterModel())
}
