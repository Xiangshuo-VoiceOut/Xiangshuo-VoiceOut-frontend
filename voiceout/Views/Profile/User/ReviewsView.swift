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
            VStack(spacing:ViewSpacing.small) {
                ForEach(reviews.indices, id: \.self) { index in
                    CommentCardView(viewModel: reviews[index])
                }
            }
        }
        .background(Color.surfacePrimaryGrey2)
    }
}

#Preview {
    ReviewsView()
}
