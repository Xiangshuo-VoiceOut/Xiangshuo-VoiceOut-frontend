//
//  ResetPasswordView.swift
//  voiceout
//
//  Created by J. Wu on 5/27/24.
//

import SwiftUI

struct ResetPasswordView: View {
    @EnvironmentObject var router: RouterModel
    @StateObject private var resetPasswordVM: ResetPasswordVM
    @StateObject private var textInputVM: TextInputVM
    private let role: UserRole
    init(_ role: UserRole) {
        self.role = role
        let model = TextInputVM()
        _textInputVM = StateObject(wrappedValue: model)
        _resetPasswordVM = StateObject(wrappedValue: ResetPasswordVM(role: role, textInputVM: model))
    }

    var body: some View {
        ZStack {
            BackgroundView()

            VStack(spacing: ViewSpacing.xlarge) {
                HeaderView()

                VStack {
                    VStack(spacing: ViewSpacing.small) {
                        SecuredTextInputView(
                            text: $textInputVM.newPassword,
                            securedPlaceholder: "new_password",
                            securedValidation: textInputVM.isValidPassword ? .neutral : .error,
                            validationMsg: textInputVM.newPasswordValidationMsg,
                            prefixIcon: "lock"
                        )

                        SecuredTextInputView(
                            text: $textInputVM.confirmNewPassowrd,
                            securedPlaceholder: "new_password",
                            securedValidation: textInputVM.isValidPassword ? .neutral : .error,
                            validationMsg: textInputVM.confirmPasswordValidationMsg,
                            prefixIcon: "lock"
                        )

                        ButtonView(
                            text: "finished",
                            action: {
                                resetPasswordVM.resetPassword()
                                if resetPasswordVM.isResetSuccessful {
                                    router.navigateTo(
                                        .finish(
                                            finishText: "reset_successfully",
                                            navigateToText: "navigate_to_login",
                                            destination: .userLogin
                                        )
                                    )
                                }
                            },
                            theme: resetPasswordVM.isFinishButtonEnabled ? .action : .base,
                            maxWidth: .infinity
                        )
                        .disabled(!resetPasswordVM.isFinishButtonEnabled)
                        .padding(.top, ViewSpacing.small)
                    }
                    .background(Color.surfacePrimary)
                    .padding(ViewSpacing.large)
                }
                .background(Color.surfacePrimary)
                .cornerRadius(CornerRadius.medium.value)
                .shadow(color: Color(.grey200), radius: CornerRadius.xxsmall.value)
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
        .onChange(of: textInputVM.newPassword) { _ in
            resetPasswordVM.handleInputsFilled()
        }
        .onChange(of: textInputVM.confirmNewPassowrd) { _ in
            resetPasswordVM.handleInputsFilled()
        }
    }
}

#Preview {
    ResetPasswordView(.user)
}
