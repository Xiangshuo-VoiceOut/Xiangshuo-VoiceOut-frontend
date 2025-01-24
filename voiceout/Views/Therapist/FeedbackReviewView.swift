//
//  FeedbackReviewView.swift
//  voiceout
//
//  Created by Yujia Yang on 12/14/24.
//

import SwiftUI

struct FeedbackReviewView: View {
    @State private var overallSatisfaction: Int = 0
    @State private var categoryRatings: [Int] = [0, 0, 0, 0]
    @State private var likelihoodToContinue: Int? = nil
    @State private var feedbackText: String = ""
    @State private var publicFeedbackText: String = ""

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                StickyHeaderView(
                    title: "咨询反馈和评价",
                    leadingComponent: AnyView(
                        Button(action: {}) {
                            Image("left-arrow")
                                .foregroundColor(.grey500)
                        }
                    ),
                    trailingComponent: nil
                )
                .frame(height: 44)
                .zIndex(1)

                ScrollView {
                    VStack(spacing: ViewSpacing.small) {
                        HStack(spacing: ViewSpacing.small) {
                            Rectangle()
                                .foregroundColor(.clear)
                                .background(
                                    Image("cloud1")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .clipped()
                                )
                            HStack(alignment: .center, spacing: ViewSpacing.betweenSmallAndBase) {
                                Text("您的反馈将帮助我们持续为您提供优质的服务")
                                    .font(Font.typography(.bodyMedium))
                                    .foregroundColor(.grey300)
                                    .padding(ViewSpacing.medium)
                            }
                            .background(Color.surfacePrimary)
                            .cornerRadius(CornerRadius.medium.value)
                        }
                        .padding(.horizontal, ViewSpacing.medium)
                        .padding(.top, ViewSpacing.medium)

                        VStack(alignment: .center, spacing: ViewSpacing.small) {
                            VStack(alignment: .leading, spacing: ViewSpacing.medium) {
                                HStack(spacing: 0) {
                                    Text("您对这次咨询的总体满意度如何？")
                                        .font(Font.typography(.bodyMedium))
                                        .foregroundColor(.grey500)
                                    Text("*")
                                        .font(Font.typography(.bodyMedium))
                                        .foregroundColor(.textBrandPrimary)
                                }
                                SatisfactionView(overallSatisfaction: $overallSatisfaction)
                            }
                            .padding(ViewSpacing.medium)
                            .background(Color.surfacePrimary)
                            .cornerRadius(CornerRadius.medium.value)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, ViewSpacing.medium)

                            VStack(alignment: .leading, spacing: ViewSpacing.medium) {
                                HStack(spacing: 0) {
                                    Text("您觉得咨询师在以下方面的表现如何？")
                                        .font(Font.typography(.bodyMedium))
                                        .foregroundColor(.textPrimary)
                                    Text("*")
                                        .font(Font.typography(.bodyMedium))
                                        .foregroundColor(.textBrandPrimary)
                                }
                                StarRatingComponent(
                                    ratings: $categoryRatings,
                                    criteria: ["倾听和理解", "提供的建议", "专业知识和技能", "亲和力和态度"]
                                )
                            }
                            .padding(ViewSpacing.medium)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .background(Color.surfacePrimary)
                            .cornerRadius(CornerRadius.medium.value)
                            .padding(.horizontal, ViewSpacing.medium)

                            likelihoodSection()
                                .padding(.horizontal, ViewSpacing.medium)

                            FeedbackInputView(
                                title: "请分享您对这次咨询的具体意见和建议:",
                                text: $feedbackText
                            )
                            .padding(.horizontal, ViewSpacing.medium)

                            FeedbackInputView(
                                title: "如果您愿意，您可以留下对咨询师的公开评价，这将显示在咨询师的评论页面:",
                                text: $publicFeedbackText
                            )
                            .padding(.horizontal, ViewSpacing.medium)
                        }
                        .padding(.vertical, ViewSpacing.medium)
                        .frame(maxWidth: geometry.size.width)

                        confirmButton()
                            .padding(.horizontal, ViewSpacing.medium)

                        Spacer()
                            .frame(height: geometry.safeAreaInsets.bottom + ViewSpacing.medium)
                    }
                    .frame(minHeight: geometry.size.height)
                }
                .background(Color.surfacePrimaryGrey2)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }

    private func likelihoodSection() -> some View {
        VStack(alignment: .leading, spacing: ViewSpacing.medium) {
            VStack(alignment: .leading, spacing: ViewSpacing.medium) {
                Text("您是否有可能继续预约咨询师的服务？")
                    .font(Font.typography(.bodyMedium))
                    .foregroundColor(.textPrimary)

                VStack(spacing: ViewSpacing.xsmall) {
                    HStack(spacing: ViewSpacing.xsmall) {
                        buttonOption(text: "非常有可能", index: 0)
                        buttonOption(text: "有可能", index: 1)
                        buttonOption(text: "不确定", index: 2)
                        Spacer()
                    }
                    HStack(spacing: ViewSpacing.xsmall) {
                        buttonOption(text: "不太可能", index: 3)
                        buttonOption(text: "完全不可能", index: 4)
                        Spacer()
                    }
                }
            }
            .padding(ViewSpacing.medium)
            .background(Color.surfacePrimary)
            .cornerRadius(CornerRadius.medium.value)
        }
    }

    private func buttonOption(text: String, index: Int) -> some View {
        Button(action: {
            likelihoodToContinue = index
        }) {
            Text(text)
                .font(Font.typography(.bodyMedium))
                .foregroundColor(likelihoodToContinue == index ? .textInvert : .textSecondary)
                .frame(width: 90, height: 40)
                .background(
                    likelihoodToContinue == index ? Color.surfaceBrandPrimary : Color.surfacePrimaryGrey2
                )
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium.value))
        }
        .buttonStyle(PlainButtonStyle())
    }

    private var isSubmitEnabled: Bool {
        return overallSatisfaction > 0 &&
               !categoryRatings.contains(0)
    }

    private func confirmButton() -> some View {
        VStack {
            HStack(alignment: .center, spacing: ViewSpacing.betweenSmallAndBase) {
                Button(action: {
                    print("提交按钮点击！")
                }) {
                    Text("提交")
                        .font(Font.typography(.bodyMedium))
                        .kerning(0.64)
                        .multilineTextAlignment(.center)
                        .foregroundColor(isSubmitEnabled ? .textInvert : .textPrimary)
                }
            }
            .padding(.horizontal, ViewSpacing.xxxxlarge)
            .padding(.vertical, ViewSpacing.small)
            .frame(maxWidth: .infinity, minHeight: 44, alignment: .center)
            .background(isSubmitEnabled ? Color.surfaceBrandPrimary : Color.surfacePrimaryGrey)
            .cornerRadius(CornerRadius.full.value)
            .disabled(!isSubmitEnabled)
        }
    }
}

struct FeedbackReviewView_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackReviewView()
    }
}
