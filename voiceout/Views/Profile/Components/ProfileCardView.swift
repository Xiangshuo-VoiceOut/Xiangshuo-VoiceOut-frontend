//
//  ProfileCardView.swift
//  voiceout
//
//  Created by Yujia Yang on 11/18/24.
//

import Foundation
import SwiftUI

struct ProfileCardView<Content: View>: View {
    var title: LocalizedStringKey?
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
        .cardStyle()
    }
}

struct ProfileCardView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileCardView(
            title: "从业经历",
            showEditButton: true
        ) {
            Text("")
                .foregroundColor(.textSecondary)
                .font(Font.typography(.bodySmall))
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
