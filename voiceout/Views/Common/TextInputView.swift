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
    var label: String?
    var isSecuredField: Bool?
    let placeholder: String
    var prefixIcon: String?
    var validationState: ValidationState? = ValidationState.neutral
    var validationMessage: String? = ""
    var suffixContent: AnyView?
    var theme: TextInputTheme? = .grey
    var isRequiredField: Bool? = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let label = label, !label.isEmpty {
                HStack(spacing: 0) {
                    Text(LocalizedStringKey(label))

                    if isRequiredField == true {
                        Text("*")
                    }
                }
                .font(.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
                .padding(.bottom, ViewSpacing.small)
            }

            HStack(spacing: ViewSpacing.small) {
                if let icon = prefixIcon {
                    Image(icon)
                        .foregroundColor(.borderSecondary)
                }

                if isSecuredField == true {
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
                    .truncationMode(.tail)
                    .lineLimit(1)
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

            if let validationMessage = validationMessage, !validationMessage.isEmpty {
                Text(LocalizedStringKey(validationMessage))
                    .foregroundColor(validationState == .error ? Color.borderInValid : Color.textSecondary)
                    .font(.typography(.bodyXXSmall))
                    .padding(.top, ViewSpacing.xsmall)
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
            label: "email",
            isSecuredField: true,
            placeholder: "email_placeholder",
            validationMessage: "错误"
        )
    }
}
