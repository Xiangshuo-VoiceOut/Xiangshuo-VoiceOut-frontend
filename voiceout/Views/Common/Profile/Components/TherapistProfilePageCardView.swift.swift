//
//  TherapistProfilePageCardView.swift.swift
//  voiceout
//
//  Created by Yujia Yang on 11/18/24.
//

import Foundation
import SwiftUI

struct TherapistProfilePageCardView<Content: View>: View {
    var title: String? 
    var showEditButton: Bool
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: ViewSpacing.medium) {
            if let title = title {
                HStack(alignment: .top) {
                    Text(title)
                        .foregroundColor(.textBrandPrimary)
                        .font(Font.typography(.bodyLargeEmphasis))
                    Spacer()
                    if showEditButton {
                        EditButtonView(action: {
                        })
                    }
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            content
                .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .padding(ViewSpacing.medium)
        .background(Color.surfacePrimary)
        .cornerRadius(CornerRadius.medium.value)
    }
}

struct TherapistProfilePageCardView_Previews: PreviewProvider {
    static var previews: some View {
        TherapistProfilePageCardView(title: "从业经历", showEditButton: true) {
            Text("")
                .foregroundColor(.textSecondary)
                .font(Font.typography(.bodySmall))
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
