//
//  LoginView.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 3/19/24.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject private var loginVM = AuthViewModel()
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                BackgroundView()
                
                VStack{
                    HeaderView()

                    
                    VStack {
                        VStack {
                            TextInputView(
                                text: $loginVM.email,
                                isSecuredField: false,
                                placeholder: "email_placeholder",
                                prefixIcon: "email",
                                validationState: loginVM.isEmailValid ? ValidationState.neutral : ValidationState.error,
                                validationMessage: loginVM.emailValidationMsg
                            )
                            .autocapitalization(.none)
                            .padding(.bottom)
                            
                            SecuredTextInputView(text: $loginVM.password, securedPlaceholder: "password_placeholder"
                            )
                            
                            HStack{
                                Spacer()
                                NavigationLink(destination: ForgetPasswordView()) {
                                    Text("forget_password")
                                        .font(.typography(.bodyXXSmall))
                                        .underline()
                                        .foregroundColor(Color(.textSecondary))
                                }
                            }
                            .padding(.bottom, ViewSpacing.small)
                            
                            ButtonView(text: "login", action: {loginVM.login()}, theme: loginVM.isLoginEnabled ? .action : .base)
                            
                        }
                        .background(Color(.surfacePrimary))
                        .padding(.horizontal,ViewSpacing.xlarge)
                    }
                    .padding(.vertical, ViewSpacing.xlarge)
                    .background(Color(.surfacePrimary))
                    .cornerRadius(CornerRadius.medium.value)
                    .shadow(color: Color(.grey200),radius: CornerRadius.small.value)
                    .padding(ViewSpacing.medium)
                    
                    
                }
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            //TODO
                            //sign up
                        }){
                            Text("signup")
                                .font(.typography(.bodyMedium))
                                .foregroundColor(.black.opacity(0.69))
                        }
                    }
                }
                .navigationDestination(isPresented: $loginVM.showingMainPage) {
                    MainPageView()
                }
            }
            .ignoresSafeArea()
        }
        
        .onChange(of: loginVM.email) { _ in
            loginVM.validateInput()
            loginVM.resetValidateState()
        }
        .onChange(of: loginVM.password) { _ in
            loginVM.validateInput()
            loginVM.resetValidateState()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
