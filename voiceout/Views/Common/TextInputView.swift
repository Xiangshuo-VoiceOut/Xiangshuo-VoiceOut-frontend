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

enum TextInputTheme {
    case white
    case grey
}

struct TextInputView: View {
    @Binding var text: String
    var isSecuredField: Bool
    let placeholder: String
    var prefixIcon: String?
    var validationState: ValidationState? = ValidationState.neutral
    var validationMessage: String? = ""
    var suffixContent: AnyView?
    var borderRadius: CGFloat = CornerRadius.medium.value
    var theme: TextInputTheme? = .grey
    var body: some View {
        VStack (alignment: .leading, spacing: 1) {
            HStack(spacing: ViewSpacing.small) {
                if let icon = prefixIcon {
                    Image(icon)
                        .foregroundColor(.borderSecondary)
                }
                
                if isSecuredField {
                    SecureField(
                        LocalizedStringKey(placeholder),
                        text: $text,
                        prompt: Text(LocalizedStringKey(placeholder))
                            .foregroundColor(Color.textLight)
                            .font(.typography(.bodyMediumEmphasis))
                    )
                    .foregroundColor(.textPrimary)
                } else {
                    TextField(
                        LocalizedStringKey(placeholder),
                        text: $text,
                        prompt: Text(LocalizedStringKey(placeholder))
                            .font(.typography(.bodyMediumEmphasis))
                            .foregroundColor(.textLight)
                    )
                    .foregroundColor(.textPrimary)
                }
                suffixContent
            }
            .padding(.horizontal, ViewSpacing.medium)
            .padding(.vertical, ViewSpacing.small)
            .background(backgroundColor)
            .cornerRadius(CornerRadius.medium.value)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.medium.value)
                    .stroke(
                        .width100,
                        validationStateColor
                    )
            )
        .frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            if let validationMessage = validationMessage, !validationMessage.isEmpty {
                Text(LocalizedStringKey(validationMessage))
                    .foregroundColor(validationState == .error ? Color.borderInValid : Color.textSecondary)
                    .font(.typography(.bodyXXSmall))
                    .padding(.leading)
            } else {
                Text(" ")
                    .font(.typography(.bodyXXSmall))
                    .opacity(0)
            }
        }
    }
    
    private var validationStateColor: Color {
        switch validationState {
        case .error:
            return .borderInValid
        case .success:
            return .borderValid
        default:
            return Color(.clear)
        }
    }
    
    private var backgroundColor: Color {
        switch theme {
        case .white:
            return .white
        default:
            return .surfacePrimaryGrey2
        }
    }
}

struct TextInputView_Previews: PreviewProvider {
    static var previews: some View {
        TextInputView(
            text: .constant(""),
            isSecuredField: true,
            placeholder: "email_placeholder",
            validationMessage: "错误"
        )
    }
}
