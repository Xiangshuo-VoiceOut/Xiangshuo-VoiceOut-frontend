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

enum InputType {
    case normal
    case login
}

struct TextInputView: View {
    @Binding var text: String
    @Binding var isSecuredField: Bool
    let placeholder: String
    var prefixIcon: String? = "email"
    var validationState: ValidationState? = ValidationState.neutral
    var validationMessage: String? = ""
    var suffixContetnt: AnyView?
    var inputType: InputType? = InputType.normal
    var body: some View {
        HStack(spacing: ViewSpacing.small) {
            if let icon = prefixIcon {
                Image(icon)
                    .foregroundColor(Color(.borderSecondary))
            }
            
            if isSecuredField {
                SecureField(
                    LocalizedStringKey(placeholder),
                    text: $text,
                    prompt: Text(placeholder)
                        .foregroundColor(Color(.textSecondary))
                        .font(.typography(.bodyMediumEmphasis))
                )
                .foregroundColor(Color(.textPrimary))
            } else {
                TextField(
                    LocalizedStringKey(placeholder),
                    text: $text,
                    prompt: Text(placeholder)
                        .font(.typography(.bodyMediumEmphasis))
                        .foregroundColor(Color(.textSecondary))
                )
                .foregroundColor(Color(.textPrimary))
            }
            
            suffixContetnt
        }
        .padding(.horizontal, ViewSpacing.medium)
        .padding(.vertical, ViewSpacing.small)
        .background(Color(.surfacePrimaryGrey2))
        .cornerRadius(radiusValue)
        .overlay(
            RoundedRectangle(cornerRadius: radiusValue)
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
            return Color(.borderInvalid)
        case .success:
            return Color(.borderValid)
        default:
            return Color(.clear)
        }
    }
    
    private var radiusValue: CGFloat {
        switch inputType {
        case .login:
            return 18
        default:
            return CornerRadius.medium.value
        }
    }
}

struct TextInputView_Previews: PreviewProvider {
    static var previews: some View {
        TextInputView(
            text: .constant(""),
            isSecuredField: .constant(true),
            
            placeholder: "placeholder"
        )
    }
}
