//
//  SignUpStep2.swift
//  voiceout
//
//  Created by J. Wu on 8/12/24.
//

import SwiftUI

struct SignUpStep2: View {
    @EnvironmentObject var router: RouterModel
    @ObservedObject var textInputVM: TextInputVM
    @ObservedObject var userSignUpVM: UserSignUpVM

    var body: some View {
        VStack(spacing: ViewSpacing.small) {
            TextInputView(
                text: $textInputVM.nickname,
                isSecuredField: false,
                placeholder: "nickname_placeholder",
                prefixIcon: "user",
                validationState: textInputVM.isNicknameValid ? ValidationState.neutral : ValidationState.error,
                validationMessage: textInputVM.nicknameValidationMsg
            )
            .autocapitalization(.none)

            Dropdown(
                selectionOption: $userSignUpVM.selectedState,
                prefixIcon: "local",
                placeholder: String(localized: "state_placeholder"),
                options: userSignUpVM.allStates
            )
            .padding(.bottom)

            TextInputView(
                text: $textInputVM.birthdate,
                isSecuredField: false,
                placeholder: "input_birthday_placeholder",
                prefixIcon: "birthday-cake",
                validationState: textInputVM.isVerificationCodeValid ? ValidationState.neutral : ValidationState.error
            )
            .onChange(of: textInputVM.birthdate) {
                textInputVM.birthdate = textInputVM.birthdate.formattedDate
            }

            Dropdown(
                selectionOption: $userSignUpVM.selectedGender,
                prefixIcon: "public-toilet",
                placeholder: String(localized: "gender_placeholder"),
                options: DropdownOption.genders
            )
            .padding(.bottom, ViewSpacing.large)

            ButtonView(
                text: "signup",
                action: {
                    userSignUpVM.userSignUp()
                    if userSignUpVM.isSignUpSuccessfully {
                        router.navigateTo(
                            .successRedirect(
                                title: "sign_up_successfully"
                            )
                        )
                    }
                },
                theme: userSignUpVM.isUserSignUpEnabled ? .action : .base, maxWidth: .infinity
            )
            .disabled(!userSignUpVM.isUserSignUpEnabled)
            .padding(.top, ViewSpacing.small)
        }
    }
}

struct SignUpStep2_Previews: PreviewProvider {
    static var previews: some View {
        let textInputVM = TextInputVM()
        let userSignUpVM = UserSignUpVM(textInputVM: textInputVM)

        SignUpStep2(
            textInputVM: textInputVM,
            userSignUpVM: userSignUpVM
        )
    }
}
