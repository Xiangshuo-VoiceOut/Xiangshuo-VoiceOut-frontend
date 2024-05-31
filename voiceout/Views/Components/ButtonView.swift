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
}

enum ButtonSpacing {
    case small
    case medium
}

enum ButtonFrontSize {
    case small
    case medium
}


struct ButtonView: View {
    var text: String
    var action: () -> Void
    var variant: ButtonVariant? = ButtonVariant.solid
    var theme: ButtonTheme? = ButtonTheme.action
    var spacing: ButtonSpacing? = ButtonSpacing.medium
    var fontSize: ButtonFrontSize? = ButtonFrontSize.medium
    
    var body: some View {
        Button(action: action) {
            Text(LocalizedStringKey(text))
                .font(fontForFrameSize)
        }
        .padding(paddingSize)
        .foregroundColor(foregroundColorForVariant)
        .background(backgroundForVariant)
        .cornerRadius(CornerRadius.full.value)
        .background(
            RoundedRectangle(cornerRadius: .full)
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
            return theme == .action ? .textInvert : .textPrimary
        }
    }
    
    private var backgroundForVariant: Color {
        switch variant {
        case .outline:
            return .surfacePrimary
        default:
            return theme == .action ? .surfaceBrandPrimary : .surfacePrimaryGrey
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

