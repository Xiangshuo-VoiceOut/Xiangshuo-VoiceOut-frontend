//
//  ExitPopupView.swift
//  voiceout
//
//  Created by Yujia Yang on 1/20/25.
//

import SwiftUI

struct ExitPopupView: View {
    var didClose: () -> Void
    var continueMatching: () -> Void
    @EnvironmentObject var progressViewModel: ProgressViewModel

    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Image("cloud3")
                    .frame(width: 165.90065, height: 86.01395)
                    .padding(.top, ViewSpacing.xlarge + ViewSpacing.betweenSmallAndBase)

                HStack(alignment: .center, spacing: ViewSpacing.betweenSmallAndBase) {
                    Text("确定要离开吗？\n离开后数据将不会被保存了！")
                        .font(.typography(.bodyMediumEmphasis))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.grey500)
                }
                .padding(.top, ViewSpacing.medium)
                .padding(ViewSpacing.medium)

                VStack(alignment: .center, spacing: ViewSpacing.large) {
                    ButtonView(
                        text: "点错了，继续匹配",
                        action: {
                            continueMatching()
                        },
                        variant: .solid,
                        theme: .action,
                        fontSize: .medium,
                        borderRadius: .full,
                        maxWidth: .infinity
                    )

                    ButtonView(
                        text: "狠心离开",
                        action: {
                            progressViewModel.resetProgress()
                            didClose()
                        },
                        variant: .outline,
                        theme: .base,
                        fontSize: .medium,
                        borderRadius: .full,
                        maxWidth: .infinity
                    )
                }
                .padding(ViewSpacing.xlarge)
            }
            .frame(height: 421)
            .background(
                Color.surfacePrimary
                    .cornerRadius(CornerRadius.medium.value)
                    .padding(.horizontal, ViewSpacing.medium)
            )
        }
    }
}

#Preview {
    ExitPopupView(
        didClose: {},
        continueMatching: {}
    )
    .environmentObject(ProgressViewModel())
}
