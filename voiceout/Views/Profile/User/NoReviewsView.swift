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

            Text(LocalizedStringKey("no_reviews_yet"))
                .font(Font.typography(.bodyLargeEmphasis))
                .multilineTextAlignment(.center)
                .foregroundColor(.textSecondary)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.horizontal, ViewSpacing.large+ViewSpacing.xxlarge)
        .padding(.vertical, ViewSpacing.xsmall)
        .frame(width: 358, alignment: .top)
    }
}

#Preview {
    NoReviewsView()
}
