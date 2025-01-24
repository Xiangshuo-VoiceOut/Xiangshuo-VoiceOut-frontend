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
            
            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text("请输入你想说的......")
                        .font(Font.typography(.bodySmall))
                        .foregroundColor(.grey200)
                        .padding(.top, ViewSpacing.base)
                        .padding(.leading, ViewSpacing.medium)
                }
                
                TextEditor(text: $text)
                    .font(Font.typography(.bodySmall))
                    .foregroundColor(.textPrimary)
                    .padding(.top, ViewSpacing.small)
                    .padding(.leading, ViewSpacing.small)
                    .frame(maxWidth: .infinity, minHeight: 136, maxHeight: 136, alignment: .topLeading)
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)
            }
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


