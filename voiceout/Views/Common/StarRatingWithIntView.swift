//
//  StarRatingWithIntView.swift
//  voiceout
//
//  Created by 阳羽佳 on 7/18/24.
//

import Foundation
import SwiftUI
struct StarRatingViewInt: View {
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

#Preview {
    StarRatingViewInt(rating: .constant(4))
}
