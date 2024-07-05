//
//  ResetPasswordView.swift
//  voiceout
//
//  Created by J. Wu on 5/27/24.
//

import SwiftUI

struct ResetPasswordView: View {
    @StateObject private var resetPasswordVM: ResetPasswordVM
    @StateObject private var textInputVM: TextInputVM
    
    init(_ role: UserRole) {
        let model = TextInputVM()
        _textInputVM = StateObject(wrappedValue: model)
        _resetPasswordVM = StateObject(wrappedValue: ResetPasswordVM(role: role, textInputVM: model))
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack{
                HeaderView()
                    
                VStack {
                    VStack {
                        SecuredTextInputView(
                            text: $textInputVM.newPassword,
                            securedPlaceholder: "new_password",
                            securedValidation: textInputVM.isValidPassword ? .neutral : .error ,
                            validationMsg: textInputVM.newPasswordValidationMsg,
                            prefixIcon: "lock"
                        )
                        .padding(.bottom)
                            
                        SecuredTextInputView(
                            text: $textInputVM.confirmNewPassowrd,
                            securedPlaceholder: "new_password",
                            securedValidation: textInputVM.isValidPassword ? .neutral : .error ,
                            validationMsg: textInputVM.confirmPasswordValidationMsg,
                            prefixIcon: "lock"
                        )
                        .padding(.bottom, ViewSpacing.large)
                            
                        ButtonView(
                            text: "finished",
                            action: {},
                            theme: resetPasswordVM.isFinishButtonEnabled ? .action : .base,
                            maxWidth: .infinity
                        )
                        .disabled(!resetPasswordVM.isFinishButtonEnabled)
                    }
                    .background(Color.surfacePrimary)
                    .padding(.horizontal,ViewSpacing.xlarge)
                }
                .padding(.vertical, ViewSpacing.xlarge)
                .background(Color.surfacePrimary)
                .cornerRadius(CornerRadius.medium.value)
                .shadow(color: Color(.grey200),radius: CornerRadius.xxsmall.value)
                .padding(ViewSpacing.medium)
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                            
                    }){
                        Text("signup")
                            .font(.typography(.bodyMedium))
                            .foregroundColor(.black.opacity(0.69))
                    }
                }
            }
        }
        .ignoresSafeArea()
        .onChange(of: textInputVM.newPassword){ _ in
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
