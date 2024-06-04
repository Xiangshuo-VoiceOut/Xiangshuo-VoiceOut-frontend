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
    var isSecuredField: Bool
    let placeholder: String
    var prefixIcon: String? = "email"
    var validationState: ValidationState? = ValidationState.neutral
    var validationMessage: String? = ""
    var suffixContetnt: AnyView?
    var borderRadius: CGFloat = CornerRadius.medium.value
    var body: some View {
        VStack(alignment: .leading, spacing: 1){
            HStack(spacing: ViewSpacing.small) {
                if let icon = prefixIcon {
                    Image(icon)
                        .foregroundColor(Color(.borderSecondary))
                }
                
                if isSecuredField {
                    SecureField(
                        LocalizedStringKey(placeholder),
                        text: $text,
                        prompt: Text(LocalizedStringKey(placeholder))
                            .foregroundColor(Color(.textSecondary))
                            .font(.typography(.bodyMediumEmphasis))
                    )
                    .foregroundColor(Color(.textPrimary))
                } else {
                    TextField(
                        LocalizedStringKey(placeholder),
                        text: $text,
                        prompt: Text(LocalizedStringKey(placeholder))
                            .font(.typography(.bodyMediumEmphasis))
                            .foregroundColor(Color(.textSecondary))
                    )
                    .foregroundColor(Color(.textPrimary))
                }
                
                suffixContetnt
            }
            .padding(.horizontal, ViewSpacing.medium)
            .padding(.vertical, ViewSpacing.base)
            .background(Color(.surfacePrimaryGrey2))
            .cornerRadius(CornerRadius.medium.value)
            .overlay(
                RoundedRectangle(cornerRadius:CornerRadius.medium.value)
                    .stroke(
                        .width100,
                        validationStateColor
                    )
            )
            .frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            
            
            
            if let validationMessage = validationMessage, !validationMessage.isEmpty {
                Text(LocalizedStringKey(validationMessage))
                    .foregroundColor(validationState == .error ? Color(.borderInvalid) : Color(.textSecondary))
                    .font(.typography(.bodyXXSmall))
                    .padding(.leading)
                    
            }
        }
    }
    
    private var validationStateColor: Color {
        switch validationState {
        case .error:
            return Color(.borderInvalid)
        case .success:
            return Color(.borderValid)
        default:
            return Color(.clear)
        }
    }
}

struct TextInputView_Previews: PreviewProvider {
    static var previews: some View {
        TextInputView(
            text: .constant(""),
            isSecuredField: true,
            placeholder: "email_placeholder",
            validationState : ValidationState.neutral,
            validationMessage: "错误"
        )
    }
}
