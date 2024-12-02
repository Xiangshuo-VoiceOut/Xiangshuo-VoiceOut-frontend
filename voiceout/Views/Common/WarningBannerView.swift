//
//  WarningBannerView.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 11/22/24.
//

import SwiftUI

struct WarningBannerView: View {
    var warningMsg: String

    var body: some View {
        VStack {
            Text(warningMsg)
                .font(.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
                .padding(.horizontal, ViewSpacing.small)
                .padding(.vertical, ViewSpacing.xsmall)
                .frame(maxWidth: .infinity)
        }
        .background(Color.brandTertiary)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    WarningBannerView(warningMsg: "❗️您的资料正在被审核，审核通过前资料不会被公开。")
}
