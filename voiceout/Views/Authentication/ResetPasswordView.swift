//
//  ResetPasswordView.swift
//  voiceout
//
//  Created by J. Wu on 5/27/24.
//

import SwiftUI

struct ResetPasswordView: View {
    
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
                    
                    SecuredTextInputView(text: $resetPasswordVM.newPassword, securedPlaceholder: "new_password")
                    
                    SecuredTextInputView(text: $resetPasswordVM.confirmNewPassword, securedPlaceholder: "new_password")
                    
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
                
                ButtonView(text: "finished", action: {resetPasswordVM.isVerificationCodeSent}, theme: .base)
                
                
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
    ResetPasswordView()
}
