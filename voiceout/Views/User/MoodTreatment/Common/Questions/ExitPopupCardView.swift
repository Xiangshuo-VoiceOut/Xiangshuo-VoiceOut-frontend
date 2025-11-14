//
//  ExitPopupCardView.swift
//  voiceout
//
//  Created by Yujia Yang on 10/28/25.
//

import SwiftUI

struct ExitPopupCardView: View {
    let onExit: () -> Void
    let onContinue: () -> Void
    let onClose: () -> Void
    
    init(
        onExit: @escaping () -> Void = {},
        onContinue: @escaping () -> Void = {},
        onClose: @escaping () -> Void = {}
    ) {
        self.onExit = onExit
        self.onContinue = onContinue
        self.onClose = onClose
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .center, spacing: ViewSpacing.xsmall) {
                HStack{
                    Spacer()
                    Button(action: onClose) {
                        Image("close")
                            .frame(width: 24, height: 24)
                            .foregroundColor(.grey500)
                    }
                }
                
                VStack(alignment: .leading, spacing: ViewSpacing.medium) {
                    VStack(alignment: .leading, spacing: ViewSpacing.xsmall) {
                        Text("确定要退出疏导路线吗？")
                            .font(Font.typography(.bodyLargeEmphasis))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.textPrimary)
                            .frame(maxWidth: .infinity, alignment: .top)
                        
                        Text("退出后您的进度不会保存")
                            .font(Font.typography(.bodySmall))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.textSecondary)
                            .frame(maxWidth: .infinity, alignment: .top)
                    }
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    
                    HStack(alignment: .center, spacing: ViewSpacing.medium) {
                        Button(action: onExit) {
                            Text("退出疗愈")
                                .font(Font.typography(.bodyMedium))
                                .foregroundColor(.brandPrimary)
                                .frame(maxWidth: .infinity, minHeight: 44)
                                .background(Color.surfacePrimary)
                                .overlay(
                                    Capsule()
                                        .stroke(Color.surfaceBrandPrimary,
                                                lineWidth: StrokeWidth.width200.value)
                                )
                                .clipShape(Capsule())
                        }
                        
                        Button(action: onContinue) {
                            Text("继续疗愈")
                                .font(Font.typography(.bodyMedium))
                                .foregroundColor(.textInvert)
                                .frame(maxWidth: .infinity, minHeight: 44)
                                .background(Color.surfaceBrandPrimary)
                                .clipShape(Capsule())
                        }
                    }
                    .frame(maxWidth: .infinity, minHeight: 44, maxHeight: 44, alignment: .leading)
                }
            }
            .padding(ViewSpacing.large)
            .frame(width: 342, alignment: .top)
            .background(Color.surfacePrimary)
            .cornerRadius(CornerRadius.medium.value)
        }
    }
}

#Preview {
    ExitPopupCardView()
        .padding()
        .background(Color.gray.opacity(0.2))
}
