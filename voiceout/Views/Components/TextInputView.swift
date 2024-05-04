//
//  InputView.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 3/20/24.
//

import SwiftUI

enum ValidationState {
    case neutral
    case error
    case success
}

struct TextInputView: View {
    @Binding var text: String
    @Binding var isSecuredField: Bool
    let placeholder: String
    var prefixIcon: String? = "email"
    var validationState: ValidationState? = ValidationState.neutral
    var validationMessage: String? = ""
    var suffixContetnt: AnyView?
    
    var body: some View {
        HStack(spacing: ViewSpacing.small) {
            if let icon = prefixIcon {
                Image(icon)
                    .foregroundColor(validationStateColor)
            }
            
            if isSecuredField {
                SecureField(
                    LocalizedStringKey(placeholder),
                    text: $text
                )
                .foregroundColor(Color(.grey300))
            } else {
                TextField(
                    LocalizedStringKey(placeholder),
                    text: $text
                )
                .foregroundColor(Color(.grey300))
            }
            
            suffixContetnt
        }
        .padding(.horizontal, ViewSpacing.medium)
        .padding(.vertical, ViewSpacing.small)
        .background(Color(.grey50))
        .cornerRadius(.medium)
        .overlay(
            RoundedRectangle(cornerRadius: .medium)
                .stroke(
                    .width100,
                    validationStateColor
                )
        )
        .frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    
    }
    
    private var validationStateColor: Color {
        switch validationState {
        case .error:
            return Color(.actionFail)
        case .success:
            return Color(.actionSuccess)
        default:
            return Color(.grey300)
        }
    }
}

struct TextInputView_Previews: PreviewProvider {
    static var previews: some View {
        TextInputView(
            text: .constant(""),
            isSecuredField: .constant(false),
            placeholder: "placeholder"
        )
    }
}
