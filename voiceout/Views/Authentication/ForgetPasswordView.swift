//
//  ForgetPasswordView.swift
//  voiceout
//
//  Created by J. Wu on 5/27/24.
//

import SwiftUI

struct ForgetPasswordView: View {
    @State private var isEmailValid: Bool = true
    @State private var isVerificationValid: Bool = true
    @StateObject private var resetPasswordVM = ResetPWViewModel()
    
    var body: some View {
        NavigationStack {
            VStack{
                HStack(alignment: .center){
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: LogoSize.medium)
                        .clipShape(Circle())
                    
                    VStack {
                        Text("slogan")
                            .font(.typography(.bodyMedium))
                            .foregroundColor(Color(.textSecondary))
                            .alignmentGuide(.top, computeValue: { dimension in
                                dimension[.bottom]
                            })
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 32, trailing:74 ))
                
                VStack {
                    TextInputView(
                        text: $resetPasswordVM.email,
                        isSecuredField: .constant(false),
                        placeholder: "email_placeholder",
                        prefixIcon: "email",
                        validationState: isEmailValid ? ValidationState.neutral : ValidationState.error
                    )
                    .autocapitalization(.none)
                    .padding(.bottom)
                    
                    ZStack {
                        TextInputView(
                            text: $resetPasswordVM.verificationCode,
                            isSecuredField: .constant(false),
                            placeholder: "input_verification_code",
                            prefixIcon: "email",
                            validationState: isVerificationValid ? ValidationState.neutral : ValidationState.error
                        )
                        
                        HStack {
                            Spacer()
                            ButtonView(text: "get_verification_code", action: {resetPasswordVM.sendVerificationCode()}, spacing: .small)
                                .padding(.horizontal, 19)
                        }

                            
                    }
                }
                .background(Color(.surfacePrimary))
                .padding(EdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 32))
                
                HStack{
                    Spacer()
                    Button(action: {}, label: {
                        Text("forget_password")
                            .font(.typography(.bodyXSmall))
                            .underline()
                            .foregroundColor(Color(.textSecondary))
                    })
                    
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 32) )
                
                ButtonView(text: "next_step", action: {resetPasswordVM.isVerificationCodeSent}, theme: .base)
                
                
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
    }
}

#Preview {
    ForgetPasswordView()
}
