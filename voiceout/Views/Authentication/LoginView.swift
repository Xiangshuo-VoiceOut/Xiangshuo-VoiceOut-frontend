//
//  LoginView.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 3/19/24.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isEmailValid: Bool = true
    
    var body: some View {
        NavigationStack {
            VStack {
                TextInputView(
                    text: $email,
                    isSecuredField: .constant(false),
                    placeholder: "email_placeholder",
                    prefixIcon: "email",
                    validationState: isEmailValid ? ValidationState.neutral : ValidationState.error
                )
                .autocapitalization(.none)
                
                SecuredTextInputView(text: $password, securedPlaceholder: "email_placeholder")
            }
            .background(Color(.grey50))
            .padding(EdgeInsets(top: 36, leading: 34, bottom: 26, trailing: 34))
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
