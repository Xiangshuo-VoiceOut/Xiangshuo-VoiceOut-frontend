//
//  ButtonView.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 4/27/24.
//

import SwiftUI

enum ButtonVariant {
    case solid
    case outline
}

enum ButtonTheme {
    case action
    case base
    case badge
    case bagdeInactive
}

enum ButtonSpacing {
    case xsmall
    case small
    case medium
    case large
}

enum ButtonFontSize {
    case small
    case medium
}

enum ButtonBorderRadius {
    case full
    case small
}

struct ButtonView: View {
    var text: String
    var action: () -> Void
    var variant: ButtonVariant? = ButtonVariant.solid
    var theme: ButtonTheme? = ButtonTheme.action
    var spacing: ButtonSpacing? = ButtonSpacing.small
    var fontSize: ButtonFontSize? = ButtonFontSize.medium
    var borderRadius: ButtonBorderRadius? = ButtonBorderRadius.full
    var maxWidth: CGFloat?
    var suffixIcon: AnyView?

    var body: some View {
        Button(action: action) {
            HStack(spacing: ViewSpacing.small) {
                Text(LocalizedStringKey(text))
                    .fixedSize(horizontal: true, vertical: false)
                    .font(fontForFrameSize)
                suffixIcon
            }
            .padding(paddingSize)
            .frame(maxWidth: maxWidth)
        }
        .foregroundColor(foregroundColorForVariant)
        .background(backgroundForVariant)
        .cornerRadius(radius)
        .background(
            RoundedRectangle(cornerRadius: radius)
                .stroke(.width200, strokeColorForVariant)
        )
    }

    private var fontForFrameSize: Font {
        switch fontSize {
        case .small:
            return .typography(.bodySmall)
        default:
            return .typography(.bodyMedium)
        }
    }

    private var foregroundColorForVariant: Color {
        switch variant {
        case .outline:
            return .textBrandPrimary
        default:
            if theme == .bagdeInactive {
                return .textSecondary
            } else if theme == .badge {
                return .textBrandPrimary
            } else if theme == .base {
                return .textPrimary
            } else {
                return .textInvert
            }
        }
    }

    private var backgroundForVariant: Color {
        switch variant {
        case .outline:
            return .surfacePrimary
        default:
            if theme == .action {
                return .surfaceBrandPrimary
            } else if theme == .badge {
                return .brandPrimary.opacity(0.3)
            } else {
                return .surfacePrimaryGrey
            }
        }
    }

    private var strokeColorForVariant: Color {
        switch variant {
        case .outline:
            return .borderBrandPrimary
        default:
            return .clear
        }
    }

    private var paddingSize: EdgeInsets {
        switch spacing {
        case .xsmall:
            return EdgeInsets(
                top: ViewSpacing.xsmall,
                leading: ViewSpacing.medium,
                bottom: ViewSpacing.xsmall,
                trailing: ViewSpacing.medium
            )

        case .small:
            return EdgeInsets(
                top: ViewSpacing.small,
                leading: ViewSpacing.large,
                bottom: ViewSpacing.small,
                trailing: ViewSpacing.large
            )

        case .large:
            return EdgeInsets(
                top: ViewSpacing.small,
                leading: ViewSpacing.xxxxlarge,
                bottom: ViewSpacing.small,
                trailing: ViewSpacing.xxxxlarge
            )

        default:
            return EdgeInsets(
                top: ViewSpacing.small,
                leading: ViewSpacing.xxxlarge,
                bottom: ViewSpacing.small,
                trailing: ViewSpacing.xxxlarge
            )

        }
    }

    private var radius: CGFloat {
        switch borderRadius {
        case .full:
            return CornerRadius.full.value
        case.small:
            return CornerRadius.small.value
        default:
            return CornerRadius.full.value
        }
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ButtonView(
                text: "登录",
                action: {}
            )
            .previewLayout(.sizeThatFits)
        }
    }
}
