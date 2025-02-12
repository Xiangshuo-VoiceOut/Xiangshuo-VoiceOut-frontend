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
                    title: "feedback_review_title",
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
                                Text(LocalizedStringKey("feedback_help_text"))
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
                                    Text(LocalizedStringKey("feedback_overall_satisfaction"))
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
                                    Text(LocalizedStringKey("therapist_performance_prompt"))
                                        .font(Font.typography(.bodyMedium))
                                        .foregroundColor(.textPrimary)
                                    Text("*")
                                        .font(Font.typography(.bodyMedium))
                                        .foregroundColor(.textBrandPrimary)
                                }
                                
                                VStack(alignment: .leading, spacing: ViewSpacing.medium) {
                                    ForEach(criteria.indices, id: \.self) { index in
                                        HStack {
                                            Text(LocalizedStringKey(criteria[index]))
                                                .font(Font.typography(.bodySmall))
                                                .foregroundColor(.textPrimary)
                                                .frame(alignment: .leading)
                                            Spacer()
                                            StarRatingViewInt(rating: $categoryRatings[index])
                                        }
                                    }
                                }
                            }
                            .padding(ViewSpacing.medium)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .background(Color.surfacePrimary)
                            .cornerRadius(CornerRadius.medium.value)
                            .padding(.horizontal, ViewSpacing.medium)
                                
                            likelihoodSection()
                                .padding(.horizontal, ViewSpacing.medium)

                            FeedbackInputView(
                                title: localizedFeedbackDetailPrompt,
                                text: $feedbackText
                            )
                            .padding(.horizontal, ViewSpacing.medium)

                            FeedbackInputView(
                                title: localizedFeedbackPublicReviewPrompt,
                                text: $publicFeedbackText
                            )
                            .padding(.horizontal, ViewSpacing.medium)
                        }
                        .padding(.vertical, ViewSpacing.medium)
                        .frame(maxWidth: geometry.size.width)

                        ButtonView(
                            text: "submit_button_text",
                            action: {
                            },
                            theme: isSubmitEnabled ? .action : .base,
                            spacing: .small,
                            fontSize: .medium,
                            borderRadius: .full,
                            maxWidth: .infinity
                        )
                        .opacity(isSubmitEnabled ? 1.0 : 0.6)
                        .frame(maxWidth: .infinity, minHeight: 44, alignment: .center)
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
            Text(LocalizedStringKey("continue_appointment_prompt"))
                .font(Font.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
            FlowLayout {
                ForEach(0..<5, id: \.self) { index in
                    ButtonView(
                        text: getOptionText(for: index),
                        action: {
                            likelihoodToContinue = index
                        },
                        variant: .solid,
                        theme: likelihoodToContinue == index ? .action : .base,
                        fontSize: .medium,
                        borderRadius: .full,
                        maxWidth: 101
                    )
                    .padding(.trailing, ViewSpacing.xsmall)
                    .padding(.bottom, ViewSpacing.xsmall)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(ViewSpacing.medium)
        .background(Color.surfacePrimary)
        .cornerRadius(CornerRadius.medium.value)
    }

    private func getOptionText(for index: Int) -> String {
        switch index {
        case 0: return "option_very_likely"
        case 1: return "option_likely"
        case 2: return "option_uncertain"
        case 3: return "option_unlikely"
        case 4: return "option_impossible"
        default: return ""
        }
    }

    private var isSubmitEnabled: Bool {
        return overallSatisfaction > 0 &&
               !categoryRatings.contains(0)
    }

    private var criteria: [String] = [
        "criteria_listen_understand",
        "criteria_advice_given",
        "criteria_expertise",
        "criteria_friendliness"
    ]
    
    private var localizedFeedbackDetailPrompt: String {
        return NSLocalizedString("feedback_detail_prompt", comment: "")
    }
    
    private var localizedFeedbackPublicReviewPrompt: String {
        return NSLocalizedString("feedback_public_review_prompt", comment: "")
    }
}

struct FeedbackReviewView_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackReviewView()
    }
}
