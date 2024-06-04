//
//  ResetPasswordView.swift
//  voiceout
//
//  Created by J. Wu on 5/27/24.
//

import SwiftUI

struct ResetPasswordView: View {
    
    @StateObject private var resetPasswordVM = ResetPasswordVM()
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                VStack{
                    HeaderView()
                    
                    VStack {
                        VStack {
                            SecuredTextInputView(text: $resetPasswordVM.newPassword, securedPlaceholder: "new_password",
                                securedValidation: resetPasswordVM.isNewPWValid ? .neutral : .error ,
                                validationMsg: resetPasswordVM.resetPasswordValidationMsg)
                            .padding(.bottom)
                            
                            SecuredTextInputView(text: $resetPasswordVM.confirmNewPW, securedPlaceholder: "new_password",
                                securedValidation: resetPasswordVM.isRepeatPWValid ? .neutral : .error ,
                                validationMsg: resetPasswordVM.repeatPasswordValidationMsg
                            )
                            .padding(.bottom, ViewSpacing.large)
                            
                            ButtonView(text: "finished", action: {}, theme: resetPasswordVM.isFinishButtonEnabled ? .action : .base).disabled(!resetPasswordVM.isFinishButtonEnabled)
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
        
        .onChange(of: resetPasswordVM.newPassword){ _ in
            resetPasswordVM.validateInputs()
        }
        .onChange(of: resetPasswordVM.confirmNewPW) { _ in
            resetPasswordVM.validateInputs()
        
        }
        
    }
}

#Preview {
    ResetPasswordView()
}
