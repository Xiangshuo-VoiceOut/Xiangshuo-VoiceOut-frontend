//
//  ProgressBarView.swift
//  voiceout
//
//  Created by Yujia Yang on 2/25/25.
//

import SwiftUI

struct ProgressBarView: View {
    @ObservedObject var progressViewModel: ProgressViewModel

    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(Color.surfacePrimaryGrey)
                .frame(height: 12)
                .cornerRadius(CornerRadius.medium.value)

            Rectangle()
                .fill(Color.surfaceBrandPrimary)
                .frame(width: progressViewModel.progressWidth, height: 12)
                .cornerRadius(CornerRadius.medium.value)
                .animation(.easeInOut(duration: 0.3), value: progressViewModel.progressWidth)
        }
        .frame(width: progressViewModel.fullWidth, height: 12)
        .padding(.horizontal, ViewSpacing.medium)
        .padding(.top, ViewSpacing.medium)
    }
}

#Preview {
    ProgressBarView(progressViewModel: ProgressViewModel())
}
