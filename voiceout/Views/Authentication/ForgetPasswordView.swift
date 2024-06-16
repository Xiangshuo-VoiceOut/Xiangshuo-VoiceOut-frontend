//
//  ForgetPasswordView.swift
//  voiceout
//
//  Created by J. Wu on 5/27/24.
//

import SwiftUI

struct ForgetPasswordView: View {
    
    @StateObject private var forgetPasswordVM = ForgetPWViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                VStack{
                    HeaderView()
                    
                    VStack {
                        VStack {
                            TextInputView(
                                text: $forgetPasswordVM.email,
                                isSecuredField: false,
                                placeholder: "email_placeholder",
                                prefixIcon: "email",
                                validationState: forgetPasswordVM.isEmailValid ? ValidationState.neutral : ValidationState.error,
                                validationMessage: forgetPasswordVM.emailValidationMessage
                            )
                            .autocapitalization(.none)
                            .padding(.bottom)
                            
                            ZStack {
                                TextInputView(
                                    text: $forgetPasswordVM.verificationCode,
                                    isSecuredField: false,
                                    placeholder: "input_verification_code",
                                    prefixIcon: "protect",
                                    validationState: forgetPasswordVM.isVerificationCodeValid ? ValidationState.neutral : ValidationState.error
                                )
                            
                                
                                HStack {
                                    Spacer()
                                    if forgetPasswordVM.email.isEmpty {
                                        ButtonView(text: "get_verification_code", action: {forgetPasswordVM.sendVerificationCode()}, theme: .base, spacing: .small)
                                            .padding(.horizontal, ViewSpacing.small)
                                    }
                                    else if forgetPasswordVM.isVerificationCodeSent {
                                        ButtonView(text: "\(forgetPasswordVM.timerValue) S", action: {}, theme: .base, spacing: .small)
                                            .padding(.horizontal, ViewSpacing.small)
                                    } else {
                                        ButtonView(text: "get_verification_code", action: {forgetPasswordVM.sendVerificationCode()}, spacing: .small)
                                            .padding(.horizontal, ViewSpacing.small)
                                    }
                                }
                                
                                
                            }
                            .padding(.bottom, ViewSpacing.large)
                            
                            ButtonView(text: "next_step", action: {}, theme: forgetPasswordVM.isNextButtonEnabled ? .action : .base,
                                maxWidth: .infinity
                            ).disabled(!forgetPasswordVM.isNextButtonEnabled)
                                
                        }
                        .background(Color.surfacePrimary)
                        .padding(.horizontal,ViewSpacing.xlarge)
                    }
                    .padding(.vertical, ViewSpacing.xlarge)
                    .background(Color.surfacePrimary)
                    .cornerRadius(CornerRadius.medium.value)
                    .shadow(color: Color.grey200,radius: CornerRadius.small.value)
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
            }
            .ignoresSafeArea()
        }
        .onChange(of: forgetPasswordVM.email){ _ in
            forgetPasswordVM.validateInputs()
            forgetPasswordVM.resetValidateState()
        }
        .onChange(of: forgetPasswordVM.verificationCode) { _ in
            forgetPasswordVM.validateInputs()
            forgetPasswordVM.resetValidateState()
        }
    }
}

#Preview {
    ForgetPasswordView()
}
