//
//  BeforeFirstConsultationView.swift
//  voiceout
//
//  Created by Yujia Yang on 1/9/25.
//

import SwiftUI

struct BeforeFirstConsultationView: View {
    @Environment(\.presentationMode) var presentationMode

    let title: String
    let questionID: String
    let answers: [FAQAnswer]

    var body: some View {
        VStack(spacing: 0) {
            StickyHeaderView(
                title: title,
                leadingComponent: AnyView(
                    BackButtonView()
                        .foregroundColor(.grey500)
                ),
                trailingComponent: nil,
                backgroundColor: Color.surfacePrimary
            )
            ScrollView {
                VStack(alignment: .leading, spacing: ViewSpacing.medium) {
                    HStack {
                        Image("cloud2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 166.21063, height: 96.20775)
                        Spacer()
                    }
                    .padding(.horizontal, ViewSpacing.medium)
                    VStack(alignment: .leading) {
                        Text(title)
                            .font(Font.typography(.bodyLarge))
                            .foregroundColor(.grey300)
                            .padding(.vertical, ViewSpacing.medium)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, ViewSpacing.medium)
                            .background(Color.surfacePrimary)
                            .cornerRadius(CornerRadius.medium.value)
                    }
                    .padding(.horizontal, ViewSpacing.medium)
                    
                    VStack(alignment: .leading, spacing: ViewSpacing.medium) {
                        ForEach(answers, id: \.id) { answer in
                            VStack(alignment: .leading, spacing: ViewSpacing.medium) {
                                if !answer.title.isEmpty {
                                    Text(answer.title)
                                        .font(Font.typography(.bodyLarge))
                                        .foregroundColor(.textPrimary)
                                        .padding(.horizontal, ViewSpacing.xlarge)
                                }

                                if !answer.paragraph.isEmpty {
                                    Text(answer.paragraph)
                                        .font(Font.typography(.bodyMedium))
                                        .foregroundColor(.grey300)
                                        .padding(ViewSpacing.medium)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color.surfacePrimary)
                                        .cornerRadius(CornerRadius.medium.value)
                                        .padding(.horizontal, ViewSpacing.medium)
                                }
                            }
                        }
                    }
                }
                .padding(.top, ViewSpacing.medium)
            }
            .background(Color.surfacePrimaryGrey2)
        }
    }
}

struct BeforeFirstConsultationView_Previews: PreviewProvider {
    static var previews: some View {
        BeforeFirstConsultationView(
            title: "在想说预约一次心理咨询的流程是怎样的？",
            questionID: "mockID",
            answers: [
                FAQAnswer(id: "1", title: "一，选择咨询师", paragraph: "明确需求，选择合适的咨询师。"),
                FAQAnswer(id: "2", title: "二，预约时间", paragraph: "根据您的时间安排预约咨询。"),
                FAQAnswer(id: "3", title: "三，支付咨询费用", paragraph: "使用平台提供的支付方式完成费用支付。")
            ]
        )
    }
}
