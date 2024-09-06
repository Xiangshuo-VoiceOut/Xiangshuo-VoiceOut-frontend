//
//  ForgetPasswordView.swift
//  voiceout
//
//  Created by J. Wu on 5/27/24.
//

import SwiftUI

struct ForgetPasswordView: View {
    @StateObject private var verificationCodeVM: VerificationCodeVM
    @StateObject private var textInputVM: TextInputVM
    @StateObject private var resetVM: ResetPasswordVM
    @EnvironmentObject var router: RouterModel
    private let role: UserRole

    init(_ role: UserRole) {
        self.role = role
        let model = TextInputVM()
        _textInputVM = StateObject(wrappedValue: model)
        _verificationCodeVM = StateObject(wrappedValue: VerificationCodeVM(role: role, textInputVM: model))
        _resetVM = StateObject(wrappedValue: ResetPasswordVM(role: role, textInputVM: model))
    }

    var body: some View {
        ZStack {
            BackgroundView()

            VStack(spacing: ViewSpacing.xlarge) {
                HeaderView()

                VStack {
                    VStack(spacing: ViewSpacing.small) {
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
                        .autocorrectionDisabled()

                        ButtonView(
                            text: "next_step",
                            action: {
                                verificationCodeVM.isVerificationValid()
                                if resetVM.isNextStepActive {
                                    router.navigateTo(.resetPassword(role))
                                }
                            },
                            theme: verificationCodeVM.isNextButtonEnabled ? .action : .base,
                            maxWidth: .infinity
                        )
                        .disabled(!verificationCodeVM.isNextButtonEnabled)
                        .padding(.top, ViewSpacing.small)

                    }
                    .background(Color.surfacePrimary)
                    .padding(ViewSpacing.large)
                }
                .background(Color.surfacePrimary)
                .cornerRadius(CornerRadius.medium.value)
                .shadow(color: Color.grey200, radius: CornerRadius.xxsmall.value)
                .padding(.horizontal, ViewSpacing.xlarge)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        if role == .therapist {
                            router.navigateTo(.therapistSignup)
                        } else if role == .user {
                            router.navigateTo(.userSignUp)
                        }
                    }) {
                        Text("signup")
                            .font(.typography(.bodyMedium))
                            .foregroundColor(.black.opacity(0.69))
                    }
                }
            }
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
        .onChange(of: textInputVM.email) { _ in
            verificationCodeVM.validateInputs()
            verificationCodeVM.resetValidateState()
        }
        .onChange(of: textInputVM.verificationCode) { _ in
            verificationCodeVM.validateInputs()
            verificationCodeVM.resetValidateState()
        }
    }
}

#Preview {
    ForgetPasswordView(.user)
}
