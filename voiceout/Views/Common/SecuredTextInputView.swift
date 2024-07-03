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
    var securedPlaceholder: String
    var securedValidation: ValidationState? = ValidationState.neutral
    var validationMsg: String = ""
    var theme: TextInputTheme?
    var prefixIcon: String?
    
    var body: some View {
        TextInputView(
            text: $text,
            isSecuredField: isSecuredField,
            placeholder: securedPlaceholder,
            prefixIcon: prefixIcon,
            validationState: securedValidation,
            validationMessage: validationMsg,
            suffixContent:
                AnyView(
                    SecuredToggle(
                        isSecuredField: $isSecuredField)
                ),
            theme: theme
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
            .foregroundColor(Color.borderSecondary)
        }
    }
}

struct SecuredTextInputView_Previews: PreviewProvider {
    static var previews: some View {
        SecuredTextInputView(
            text: .constant(""),
            securedPlaceholder: "placeholder",
            securedValidation: .error,
            validationMsg: "错误"
        )
    }
}
