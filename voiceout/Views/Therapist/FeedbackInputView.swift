//
//  FeedbackInputView.swift
//  voiceout
//
//  Created by Yujia Yang on 12/14/24.
//

import SwiftUI

struct FeedbackInputView: View {
    let title: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: ViewSpacing.medium) {
            Text(title)
                .font(Font.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .topLeading)

            TextInputView(
                text: $text,
                placeholder: NSLocalizedString("feedback_input_placeholder", comment: "Placeholder text for feedback input"),
                theme: .grey
            )
            .padding(.top, ViewSpacing.small)
            .frame(maxWidth: .infinity, minHeight: 136, alignment: .topLeading)
            .background(Color.surfacePrimaryGrey2)
            .cornerRadius(CornerRadius.medium.value)
        }
        .padding(ViewSpacing.medium)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(Color.surfacePrimary)
        .cornerRadius(CornerRadius.medium.value)
    }
}

struct FeedbackInputView_Previews: PreviewProvider {
    @State static var feedbackText: String = ""

    static var previews: some View {
        FeedbackInputView(
            title: "请输入您的意见：",
            text: $feedbackText
        )
        .previewLayout(.sizeThatFits)
    }
}
