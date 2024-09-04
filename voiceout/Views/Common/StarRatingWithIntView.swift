//
//  StarRatingWithIntView.swift
//  voiceout
//
//  Created by 阳羽佳 on 7/18/24.
//

import Foundation
import SwiftUI
struct StarRatingViewInt: View {
    var rating: Int
    let maximumRating = 5
    let borderColor = Color(red: 0.98, green: 0.99, blue: 1)

    var body: some View {
        HStack {
            ForEach(1...maximumRating, id: \.self) { index in
                if index <= rating {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .overlay(
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(borderColor, lineWidth: 1)
                        )
                } else {
                    Image(systemName: "star")
                        .foregroundColor(.yellow)
                        .overlay(
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(borderColor, lineWidth: 1)
                        )
                }
            }
        }
    }
}

#Preview {
    StarRatingViewInt(rating: 4)
}
