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
    case secondary
    case inactiveRadio
    case activeRadio
}

enum ButtonPadding {
    case mini
    case small
    case base
    case medium
    case long
}

enum ButtonSize {
    case xsmall
    case small
    case base
    case large
}

enum ButtonSpacing {
    case mini
    case small
    case medium
    case long
}


struct ButtonView: View {
    var text: String
    var action: () -> Void
    var variant: ButtonVariant? = ButtonVariant.solid
    var theme: ButtonTheme? = ButtonTheme.action
    var spacing: ButtonSpacing? = ButtonSpacing.medium
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(fontForFrameSize)
        }
        .frame(width: frameSize)
        .padding(paddingSize)
        .foregroundColor(foregroundColorForTheme)
        .background(backgroundForVariant)
        .cornerRadius(.full)
        .overlay(
            RoundedRectangle(cornerRadius: .full)
                .stroke(.width200, strokeColorForTheme)
        )
    }
    private var fontForFrameSize: Font {
        switch spacing {
        case .mini:
            return .typography(.bodySmall)
        default:
            return .typography(.bodyMedium)
        }
    }
    
    private var foregroundColorForTheme: Color {
        switch theme {
        case .action:
            return Color(.textInverted)
        case .base:
            return Color(.inactiveBlack)
        case .secondary:
            return Color(.brandPrimary)
        default:
            return variant == .solid ? Color(.textInverted) : Color(.brandPrimary)
        }
    }
    
    private var backgroundForVariant: Color {
        switch theme {
        case .action:
            return Color(.brandPrimary)
        case .base:
            return Color(.inactiveGrey)
        case .secondary:
            return Color(.textInverted)
        default:
            return Color(.brandPrimary)
        }
    }
    
    private var strokeColorForTheme: Color {
        switch theme {
        case .action:
            return Color(.brandPrimary)
        case .base:
            return Color(.inactiveGrey)
        case .secondary:
            return Color(.brandPrimary)
        default:
            return Color(.brandPrimary)
        }
    }
    
    private var paddingSize: EdgeInsets {
        switch spacing {
        case .mini:
            return EdgeInsets(
                top: 8,
                leading: 16,
                bottom: 8,
                trailing: 16
            )
        
        default:
            return EdgeInsets(
                top: ViewSpacing.small,
                leading: ViewSpacing.medium,
                bottom: ViewSpacing.small,
                trailing: ViewSpacing.medium
            )
        }
    }
    
    private var frameSize: CGFloat? {
        switch spacing {
        case .mini:
            return nil
        case .small:
            return nil
        case .medium:
            return 204
        case .long:
            return 280
        default:
            return 204
        }
    }
    
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            ButtonView(
                text: "登录", action: {}
            )
            .previewLayout(.sizeThatFits)
        }
    }
}

