//
//  SecuredTextInputView.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 4/30/24.
//

import SwiftUI

struct SecuredTextInputView: View {
    @State private var isSecuredField: Bool = true
    @Binding var text: String
    
    var body: some View {
        
        TextInputView(
            text: $text,
            isSecuredField: $isSecuredField,
            placeholder: "password_placeholder",
            prefixIcon: "lock",
            suffixContetnt:
                AnyView(
                    SecuredToggle(
                        isSecuredField: $isSecuredField))
        )
        .autocapitalization(.none)
    }
}
    
struct SecuredToggle: View {
    @Binding var isSecuredField: Bool
        
    var body: some View {
        Button(action: {
            isSecuredField.toggle()
        }) {
            Image(
                isSecuredField ? "preview-close" : "preview-open"
            )
            .foregroundColor(Color(.grey300))
        }
    }
}

struct SecuredTextInputView_Previews: PreviewProvider {
    static var previews: some View {
        SecuredTextInputView(
            text: .constant("")
        )
    }
}
