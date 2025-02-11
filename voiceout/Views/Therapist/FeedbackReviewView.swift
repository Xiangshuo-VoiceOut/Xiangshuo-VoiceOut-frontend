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
                    title: NSLocalizedString("feedback_review_title", comment: "Title for feedback and review view"),
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
                                Text(NSLocalizedString("feedback_help_text", comment: "Text to inform user how feedback helps improve service"))
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
                                    criteria: [
                                        NSLocalizedString("criteria_listen_understand", comment: "Criteria for therapist's ability to listen and understand"),
                                        NSLocalizedString("criteria_advice_given", comment: "Criteria for advice given by therapist"),
                                        NSLocalizedString("criteria_expertise", comment: "Criteria for therapist's professional knowledge and skills"),
                                        NSLocalizedString("criteria_friendliness", comment: "Criteria for therapist's friendliness and attitude")
                                    ]
                                )
                            }
                            .padding(ViewSpacing.medium)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .background(Color.surfacePrimary)
                            .cornerRadius(CornerRadius.medium.value)
                            .padding(.horizontal, ViewSpacing.medium)
                                
                            LikelihoodSection()

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

                        ConfirmButton()
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

    private func LikelihoodSection() -> some View {
        VStack(alignment: .leading, spacing: ViewSpacing.medium) {
            Text(NSLocalizedString("continue_appointment_prompt", comment: "Prompt asking user about continuing to book therapist service"))
                .font(Font.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
            FlowLayout {
                ForEach(0..<5, id: \.self) { index in
                    ButtonOption(
                        text: GetOptionText(for: index),
                        index: index
                    )
                    .padding(.trailing,ViewSpacing.xsmall)
                    .padding(.bottom,ViewSpacing.xsmall)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(ViewSpacing.medium)
        .background(Color.surfacePrimary)
        .cornerRadius(CornerRadius.medium.value)
    }

    private func ButtonOption(text: String, index: Int) -> some View {
        ButtonView(
            text: text,
            action: {
                likelihoodToContinue = index
            },
            variant: .solid,
            theme: likelihoodToContinue == index ? .action : .base,
            fontSize: .medium,
            borderRadius: .full,
            maxWidth: 101
        )
    }

    private func GetOptionText(for index: Int) -> String {
        switch index {
        case 0: return NSLocalizedString("option_very_likely", comment: "Very likely")
        case 1: return NSLocalizedString("option_likely", comment: "Likely")
        case 2: return NSLocalizedString("option_uncertain", comment: "Uncertain")
        case 3: return NSLocalizedString("option_unlikely", comment: "Unlikely")
        case 4: return NSLocalizedString("option_impossible", comment: "Impossible")
        default: return ""
        }
    }

    private var IsSubmitEnabled: Bool {
        return overallSatisfaction > 0 &&
               !categoryRatings.contains(0)
    }

    private func ConfirmButton() -> some View {
        VStack {
            ButtonView(
                text: NSLocalizedString("submit_button_text", comment: "Text for the submit button"),
                action: {
                },
                theme: IsSubmitEnabled ? .action : .base,
                spacing: .small,
                fontSize: .medium,
                borderRadius: .full,
                maxWidth: .infinity
            )
            .opacity(IsSubmitEnabled ? 1.0 : 0.6)
        }
        .frame(maxWidth: .infinity, minHeight: 44, alignment: .center)
    }
}

struct FeedbackReviewView_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackReviewView()
    }
}
