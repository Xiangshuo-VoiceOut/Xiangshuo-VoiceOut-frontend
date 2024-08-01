//
//  StarRatingWithDoubleView.swift
//  voiceout
//
//  Created by 阳羽佳 on 7/18/24.
//
import Foundation
import SwiftUI
struct StarRatingViewDouble: View{
    var avgRating: Double
    let maximumRating = 5
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<maximumRating, id: \.self) { index in
                ZStack(alignment: .leading) {
                    Image(systemName: "star")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.grey50)
                    
                    if avgRating > Double(index) {
                        Image(systemName: "star.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color(red: 0.98, green: 0.75, blue: 0.14))
                            .mask(
                                Rectangle()
                                    .size(width: min(CGFloat(avgRating - Double(index)) * 20, 20), height: 20)
                                    .alignmentGuide(.leading) { d in d[.leading] }
                            )
                    }
                }
            }
        }
    }
}

#Preview {
    StarRatingViewDouble(avgRating:4.8)
}
