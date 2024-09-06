//
//  TherapistSignupView.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 7/1/24.
//

import SwiftUI

struct TherapistSignupView: View {
    @StateObject private var verificationCodeVM: VerificationCodeVM
    @StateObject private var therapistSignupVM: TherapistSignupVM
    @StateObject private var textInputVM: TextInputVM

    init() {
        let model = TextInputVM()
        _textInputVM = StateObject(wrappedValue: model)
        _therapistSignupVM = StateObject(wrappedValue: TherapistSignupVM(textInputVM: model))
        _verificationCodeVM = StateObject(wrappedValue: VerificationCodeVM(role: .therapist, textInputVM: model))
    }

    var body: some View {
        ZStack {
            BackgroundView(backgroundType: .linear)

            VStack(alignment: .leading, spacing: ViewSpacing.small) {
                Text("email")
                    .font(.typography(.bodyMedium))
                    .foregroundColor(.textPrimary)
                TextInputView(
                    text: $textInputVM.email,
                    isSecuredField: false,
                    placeholder: "email_placeholder",
                    validationState: textInputVM.isValidEmail ? ValidationState.neutral : ValidationState.error,
                    validationMessage: textInputVM.emailValidationMsg,
                    theme: .white
                )
                .autocapitalization(.none)

                Text("email_verification_code")
                    .font(.typography(.bodyMedium))
                    .foregroundColor(.textPrimary)
                TextInputView(
                    text: $textInputVM.verificationCode,
                    isSecuredField: false,
                    placeholder: "input_verification_code",
                    validationState: textInputVM.isVerificationCodeValid ? ValidationState.neutral : ValidationState.error,
                    suffixContent: AnyView(
                        VerificationCodeButton()
                            .environmentObject(verificationCodeVM)
                            .environmentObject(textInputVM)
                    ),
                    theme: .white
                )

                Text("password")
                    .font(.typography(.bodyMedium))
                    .foregroundColor(.textPrimary)
                SecuredTextInputView(
                    text: $textInputVM.newPassword,
                    securedPlaceholder: "new_password",
                    securedValidation: textInputVM.isValidPassword ? .neutral : .error,
                    validationMsg: textInputVM.newPasswordValidationMsg,
                    theme: .white
                )

                Text("password_verification")
                    .font(.typography(.bodyMedium))
                    .foregroundColor(.textPrimary)
                SecuredTextInputView(
                    text: $textInputVM.confirmNewPassowrd, securedPlaceholder: "new_password",
                    securedValidation: textInputVM.isValidPassword ? .neutral : .error,
                    validationMsg: textInputVM.confirmPasswordValidationMsg,
                    theme: .white
                )

                Spacer()
            }
            .padding(ViewSpacing.xlarge)
            .padding(.top, ViewSpacing.xxlarge)

            VStack(alignment: .center) {
                Spacer()

                ButtonView(
                    text: "signup",
                    action: {
                        therapistSignupVM.handleButtonClick()
                    },
                    theme: therapistSignupVM.isButtonEnabled ? .action : .base,
                    spacing: .medium,
                    maxWidth: .infinity
                )
                .frame(maxWidth: 281)
                .disabled(!therapistSignupVM.isButtonEnabled)
            }
        }
        .navigationTitle("signup")
        .navigationBarBackButtonHidden()
        .navigationBarItems(
            leading: BackButtonView(navigateBackTo: .therapistLogin)
        )
        .onChange(of: textInputVM.email) { _ in
            therapistSignupVM.updateButtonState()
        }
        .onChange(of: textInputVM.verificationCode) { _ in
            therapistSignupVM.updateButtonState()
        }
        .onChange(of: textInputVM.newPassword) { _ in
            therapistSignupVM.updateButtonState()
        }
        .onChange(of: textInputVM.confirmNewPassowrd) { _ in
            therapistSignupVM.updateButtonState()
        }
    }
}

#Preview {
    TherapistSignupView()
}
