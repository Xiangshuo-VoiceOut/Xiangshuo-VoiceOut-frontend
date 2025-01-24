//
//  StarRatingComponent.swift
//  voiceout
//
//  Created by Yujia Yang on 12/14/24.
//

import SwiftUI

struct StarRatingComponent: View {
    @Binding var ratings: [Int]
    let criteria: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: ViewSpacing.medium) {
            ForEach(criteria.indices, id: \.self) { index in
                HStack {
                    Text(criteria[index])
                        .font(Font.typography(.bodySmall))
                        .foregroundColor(.textPrimary)
                        .frame(alignment: .leading)
                    Spacer()
                    StarRatingView(rating: $ratings[index])
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

struct StarRatingView: View {
    @Binding var rating: Int
    let totalStars = 5

    var body: some View {
        HStack(spacing: ViewSpacing.small) {
            ForEach(1...totalStars, id: \.self) { star in
                Button(action: {
                    rating = star
                }) {
                    Image("star")
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(
                            star <= rating ? Color.surfaceBrandPrimary : Color.surfacePrimaryGrey
                        )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

struct StarRatingComponent_Previews: PreviewProvider {
    @State static var exampleRatings = [0, 0, 0, 0]
    static var previews: some View {
        StarRatingComponent(
            ratings: $exampleRatings,
            criteria: ["倾听和理解", "提供的建议", "专业知识和技能", "亲和力和态度"]
        )
    }
}
