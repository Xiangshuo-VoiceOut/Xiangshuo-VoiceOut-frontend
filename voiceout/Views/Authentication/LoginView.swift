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

                VStack {
                    HeaderView()

                    VStack {
                        VStack {
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
                                NavigationLink(destination: ForgetPasswordView(loginVM.role)) {
                                    Text("forget_password")
                                        .font(.typography(.bodyXXSmall))
                                        .underline()
                                        .foregroundColor(Color.textSecondary)
                                }
                            }
                            .padding(.top, -ViewSpacing.medium)
                            .padding(.bottom, ViewSpacing.small)

                            ButtonView(
                                text: "login",
                                action: {
                                    loginVM.login()
                                },
                                theme: loginVM.isLoginEnabled ? .action : .base,
                                maxWidth: .infinity
                            )
                        }
                        .background(Color.surfacePrimary)
                        .padding(.horizontal, ViewSpacing.xlarge)
                    }
                    .padding(.vertical, ViewSpacing.xlarge)
                    .background(Color.surfacePrimary)
                    .cornerRadius(CornerRadius.medium.value)
                    .shadow(color: Color(.grey200), radius: CornerRadius.xxsmall.value)
                    .padding(ViewSpacing.medium)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
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
                    }
                }
                .navigationDestination(
                    isPresented: $loginVM.showingUserMainPage) {}
            }
            .ignoresSafeArea()
            .navigationBarBackButtonHidden()

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
