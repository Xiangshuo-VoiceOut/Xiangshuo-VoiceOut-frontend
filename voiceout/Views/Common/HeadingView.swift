//
//  HeadingView.swift
//  voiceout
//
//  Created by Yujia Yang on 9/4/24.
//

import SwiftUI

struct HeadingView: View {
    let title: String
    let backButtonAction: () -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 122) {
            Button(action: {
                backButtonAction()
            }) {
                Image("left-arrow")
                    .frame(width: 24, height: 24)
            }
            Text(title)
                .font(Font.typography(.bodyLargeEmphasis))
                .foregroundColor(.textPrimary)
                .frame(width: 71, height: 24, alignment: .bottomLeading)
        }
        .padding(.horizontal, ViewSpacing.medium)
        .padding(.vertical, 0)
        .frame(width: 390, height: 44, alignment: .leading)
        .background(Color.surfacePrimary)
    }
}

#Preview {
    HeadingView(
        title: "心理咨询",
        backButtonAction: {
        }
    )
}
