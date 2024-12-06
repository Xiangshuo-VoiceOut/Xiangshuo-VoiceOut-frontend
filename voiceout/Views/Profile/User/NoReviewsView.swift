//
//  NoReviewsView.swift
//  voiceout
//
//  Created by Yujia Yang on 11/22/24.
//

import SwiftUI

struct NoReviewsView: View {
    var body: some View {
        VStack(alignment: .center, spacing: ViewSpacing.medium) {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 170, height: 108)
                .background(Color.black)

            Text("咨询师暂未收到任何客户的评价，请稍后再来。")
                .font(Font.typography(.bodyLargeEmphasis))
                .multilineTextAlignment(.center)
                .foregroundColor(.textSecondary)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.horizontal, ViewSpacing.xxxlarge)
        .padding(.vertical, ViewSpacing.xsmall)
        .frame(alignment: .top)
    }
}

#Preview {
    NoReviewsView()
}
