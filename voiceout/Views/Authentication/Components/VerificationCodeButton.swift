//
//  VerificationCodeButton.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 7/1/24.
//

import SwiftUI

struct VerificationCodeButton: View {
    @EnvironmentObject var verificationCodeVM: VerificationCodeVM
    @EnvironmentObject var textInputVM: TextInputVM

    var body: some View {
       ButtonView(
            text: verificationCodeVM.isVerificationCodeSent ? "\(verificationCodeVM.timerValue) S" : "get_verification_code",
            action: {
                if !verificationCodeVM.isVerificationCodeSent {
                    verificationCodeVM.sendVerificationCode()
                }
            },
            theme: textInputVM.email.isEmpty || verificationCodeVM.isVerificationCodeSent ? .base : .action,
            spacing: .xsmall,
            fontSize: .small
        )
    }
}

struct VerificationCodeButton_Previews: PreviewProvider {
    static var previews: some View {
        VerificationCodeButton()
            .environmentObject(VerificationCodeVM(role: .user, textInputVM: TextInputVM()))
            .environmentObject(TextInputVM())
    }
}
