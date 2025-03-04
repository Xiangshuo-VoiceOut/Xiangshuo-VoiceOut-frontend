//
//  ReviewsView.swift
//  voiceout
//
//  Created by Yujia Yang on 11/22/24.
//

import SwiftUI

struct ReviewsView: View {
    var reviews: [CommentCardViewModel] = [
        CommentCardViewModel(),
        CommentCardViewModel(),
        CommentCardViewModel(),
        CommentCardViewModel(),
        CommentCardViewModel(),
        CommentCardViewModel(),
        CommentCardViewModel(),
        CommentCardViewModel()
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: ViewSpacing.small) {
                ForEach(reviews.indices, id: \.self) { index in
                    CommentCardView(viewModel: reviews[index])
                }
            }
            .padding(.horizontal, 0)
            .padding(.top, 0)
            .padding(.bottom, 2*ViewSpacing.large)
            .frame(alignment: .topLeading)
        }
        .background(Color.grey75)
    }
}

#Preview {
    ReviewsView()
}
