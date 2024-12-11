//
//  TherapistSignupView.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 7/1/24.
//

import SwiftUI

struct TherapistSignupView: View {
    @EnvironmentObject var router: RouterModel
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
            BackgroundView(backgroundType: .surfacePrimaryGrey)

            StickyHeaderView(
                title: "signup",
                leadingComponent: AnyView(BackButtonView()),
                backgroundColor: Color.surfacePrimaryGrey2
            )

            VStack(alignment: .leading, spacing: ViewSpacing.small) {
                TextInputView(
                    text: $textInputVM.email,
                    label: "email",
                    isSecuredField: false,
                    placeholder: "email_placeholder",
                    validationState: textInputVM.isValidEmail ? ValidationState.neutral : ValidationState.error,
                    validationMessage: textInputVM.emailValidationMsg,
                    theme: .white
                )
                .autocapitalization(.none)

                TextInputView(
                    text: $textInputVM.verificationCode,
                    label: "email_verification_code",
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

                SecuredTextInputView(
                    text: $textInputVM.newPassword,
                    label: "password",
                    securedPlaceholder: "new_password",
                    securedValidation: textInputVM.isValidPassword ? .neutral : .error,
                    validationMsg: textInputVM.newPasswordValidationMsg,
                    theme: .white
                )

                SecuredTextInputView(
                    text: $textInputVM.confirmNewPassowrd,
                    label: "password_verification",
                    securedPlaceholder: "new_password",
                    securedValidation: textInputVM.isValidPassword ? .neutral : .error,
                    validationMsg: textInputVM.confirmPasswordValidationMsg,
                    theme: .white
                )

                Spacer()

                VStack(alignment: .center) {
                    ButtonView(
                        text: "signup",
                        action: {
                            therapistSignupVM.handleButtonClick()
                            if therapistSignupVM.isSignupSuccess {
                                router.navigateTo(
                                    .therapistSignupSuccess
                                )
                            }
                        },
                        theme: therapistSignupVM.isButtonEnabled ? .action : .base,
                        maxWidth: 281
                    )
                    .disabled(!therapistSignupVM.isButtonEnabled)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, ViewSpacing.xlarge)
            .padding(.top, ViewSpacing.xxxlarge)
            .padding(.bottom, ViewSpacing.base)
        }
        .onChange(of: textInputVM.email) {
            therapistSignupVM.updateButtonState()
        }
        .onChange(of: textInputVM.verificationCode) {
            therapistSignupVM.updateButtonState()
        }
        .onChange(of: textInputVM.newPassword) {
            therapistSignupVM.updateButtonState()
        }
        .onChange(of: textInputVM.confirmNewPassowrd) {
            therapistSignupVM.updateButtonState()
        }
    }
}

#Preview {
    TherapistSignupView()
        .environmentObject(RouterModel())
}
