//
//  FollowDialogContentView.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 12/6/24.
//

import SwiftUI

struct FollowDialogContentView: View {
    @EnvironmentObject var dialogViewModel: DialogViewModel
    @Binding var isFollowing: Bool

    var body: some View {
        VStack(spacing: ViewSpacing.small) {
            Text("unfollow_prompt")
                .font(.typography(.bodyLargeEmphasis))
                .multilineTextAlignment(.center)
                .foregroundColor(.textPrimary)
                .padding(.bottom, ViewSpacing.large)

            VStack(spacing: ViewSpacing.medium) {
                ButtonView(
                    text: "continue_to_follow",
                    action: {
                        withAnimation(.spring()) {
                            dialogViewModel.dismiss()
                        }
                        isFollowing = true
                    },
                    maxWidth: .infinity
                )

                ButtonView(
                    text: "unfollow",
                    action: {
                        withAnimation(.spring()) {
                            dialogViewModel.dismiss()
                        }
                        isFollowing = false
                    },
                    variant: .outline,
                    maxWidth: .infinity
                )
            }
        }
        .padding(ViewSpacing.medium)
        .frame(width: 239)
    }
}

#Preview {
    FollowDialogContentView(isFollowing: .constant(true))
        .environmentObject(DialogViewModel())
}
