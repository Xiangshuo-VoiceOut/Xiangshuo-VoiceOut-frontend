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
                        BackButtonView()
                            .foregroundColor(.grey500)),
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
                                    Text(NSLocalizedString("feedback_overall_satisfaction", comment: "Overall satisfaction prompt"))
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
                                    Text(NSLocalizedString("therapist_performance_prompt", comment: "Therapist performance prompt"))
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
                                title: NSLocalizedString("feedback_detail_prompt", comment: "Detailed feedback prompt"),
                                text: $feedbackText
                            )
                            .padding(.horizontal, ViewSpacing.medium)

                            FeedbackInputView(
                                title: NSLocalizedString("feedback_public_review_prompt", comment: "Public review prompt"),
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
                Text(NSLocalizedString("continue_appointment_prompt", comment: "Prompt asking user about continuing to book therapist service"))
                    .font(Font.typography(.bodyMedium))
                    .foregroundColor(.textPrimary)

                VStack(spacing: ViewSpacing.xsmall) {
                    HStack(spacing: ViewSpacing.xsmall) {
                        buttonOption(text: NSLocalizedString("option_very_likely", comment: "Very likely"), index: 0)
                        buttonOption(text: NSLocalizedString("option_likely", comment: "Likely"), index: 1)
                        buttonOption(text: NSLocalizedString("option_uncertain", comment: "Uncertain"), index: 2)
                        Spacer()
                    }
                    HStack(spacing: ViewSpacing.xsmall) {
                        buttonOption(text: NSLocalizedString("option_unlikely", comment: "Unlikely"), index: 3)
                        buttonOption(text: NSLocalizedString("option_impossible", comment: "Impossible"), index: 4)
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
            ButtonView(
                text: NSLocalizedString("submit_button_text", comment: "Text for the submit button"),
                action: {
                },
                theme: isSubmitEnabled ? .action : .base,
                spacing: .small,
                fontSize: .medium,
                borderRadius: .full,
                maxWidth: .infinity
            )
            .opacity(isSubmitEnabled ? 1.0 : 0.6)  
        }
        .frame(maxWidth: .infinity, minHeight: 44, alignment: .center)
    }
}

struct FeedbackReviewView_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackReviewView()
    }
}
