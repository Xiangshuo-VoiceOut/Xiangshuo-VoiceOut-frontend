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
    case base
    case action
}

enum ButtonPadding {
    case small
    case base
}

enum ButtonSize {
    case xsmall
    case small
    case base
    case large
}

struct ButtonView: View {
    var text: String
    var action: () -> Void
    var variant: ButtonVariant? = ButtonVariant.solid
    var theme: ButtonTheme? = ButtonTheme.action
    var padding: ButtonPadding? = ButtonPadding.base
    var size: ButtonSize? = ButtonSize.xsmall
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.typography(.bodyMedium))
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
    
    private var foregroundColorForTheme: Color {
        switch theme {
        case .base:
            return Color(.grey300)
        default:
            return variant == .solid ? Color(.textInverted) : Color(.brandPrimary)
        }
    }
    
    private var backgroundForVariant: Color {
        switch variant {
        case .outline:
            return Color(.grey50)
        default:
            return Color(.brandPrimary)
        }
    }
    
    private var strokeColorForTheme: Color {
        switch theme {
        case .base:
            return Color(.grey300)
        default:
            return Color(.brandPrimary)
        }
    }
    
    private var paddingSize: EdgeInsets {
        switch padding {
        case .small:
            return EdgeInsets(
                top: ViewSpacing.small,
                leading: ViewSpacing.medium,
                bottom: ViewSpacing.small,
                trailing: ViewSpacing.medium
            )
        default:
            return EdgeInsets(
                top: ViewSpacing.small,
                leading: ViewSpacing.large,
                bottom: ViewSpacing.small,
                trailing: ViewSpacing.large
            )
        }
    }
    
    private var frameSize: CGFloat? {
        switch size {
        case .xsmall:
            return 72
        case .small:
            return 88
        case .large:
            return 280
        default:
            return 204
        }
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(
            text: "Button",
            action: {}
        )
    }
}

