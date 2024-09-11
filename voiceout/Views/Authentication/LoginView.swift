//
//  LoginView.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 3/19/24.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var router: RouterModel
    @StateObject private var loginVM: AuthViewModel
    @StateObject private var textInputVM: TextInputVM

    init(_ role: UserRole) {
        let model = TextInputVM()
        _textInputVM = StateObject(wrappedValue: model)
        _loginVM = StateObject(wrappedValue: AuthViewModel(role: role, textInputVM: model))
    }

    var body: some View {
            ZStack {
                BackgroundView()

                StickyHeaderView(
                    trailingComponent: AnyView(
                        Button(action: {
                            if loginVM.role == .therapist {
                                router.navigateTo(.therapistSignup)
                            } else if loginVM.role == .user {
                                router.navigateTo(.userSignUp)
                            }
                        }) {
                            Text("signup")
                                .font(.typography(.bodyMedium))
                                .foregroundColor(.black.opacity(0.69))
                        }
                    )
                )

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

                            SecuredTextInputView(
                                text: $textInputVM.password,
                                securedPlaceholder: "password_placeholder",
                                securedValidation: textInputVM.isValidPassword ? ValidationState.neutral : ValidationState.error,
                                prefixIcon: "lock"
                            )

                            HStack {
                                Spacer()
                                Button(
                                    action: {
                                        router.navigateTo(.forgetPassword(loginVM.role))
                                    },
                                    label: {
                                        Text("forget_password")
                                            .font(.typography(.bodyXXSmall))
                                            .underline()
                                            .foregroundColor(Color.textSecondary)
                                    }
                                )
                            }
                            .padding(.top, -ViewSpacing.base)

                            ButtonView(
                                text: "login",
                                action: {
                                    loginVM.login()
                                },
                                theme: loginVM.isLoginEnabled ? .action : .base,
                                maxWidth: .infinity
                            )
                            .padding(.top, ViewSpacing.small)
                        }
                    }
                    .frameStyle()
                }
                .navigationDestination(
                    isPresented: $loginVM.showingUserMainPage
                ) {}
            }

        .onChange(of: textInputVM.email) { _ in
            loginVM.validateInput()
            loginVM.resetValidateState()
        }
        .onChange(of: textInputVM.password) { _ in
            loginVM.validateInput()
            loginVM.resetValidateState()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(.user)
            .environmentObject(RouterModel())
    }
}
