//
//  FAQView.swift
//  voiceout
//
//  Created by Yujia Yang on 12/12/24.
//

import SwiftUI

struct FAQView: View {
    @StateObject private var viewModel = FAQViewModel()
    @EnvironmentObject var router: RouterModel

    var body: some View {
        ZStack(alignment: .top) {
            Color(Color.surfacePrimaryGrey2)
                .edgesIgnoringSafeArea(.all)

            ScrollView {
                VStack(spacing: ViewSpacing.medium) {
                    if viewModel.isLoading {
                        ProgressView("加载中...")
                    } else if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    } else {
                        ForEach(viewModel.faqCategories) { category in
                            FAQSectionView(
                                title: category.category,
                                questions: category.questions,
                                onItemTap: { question in
                                    router.navigateTo(
                                        .questionDetail(
                                            title: question.question,
                                            questionID: question.id ?? "unknown",
                                            answers: question.answers
                                        )
                                    )
                                }
                            )
                        }
                    }
                }
                .padding(.top, 2 * ViewSpacing.betweenSmallAndBase + ViewSpacing.large)
            }
            .padding(.top, ViewSpacing.medium)

            StickyHeaderView(
                title: NSLocalizedString("consultation_guide_faq_title", comment: ""),
                leadingComponent: AnyView(
                    BackButtonView()
                        .foregroundColor(.grey500)
                ),
                trailingComponent: nil
            )
        }
        .onAppear {
            viewModel.fetchFAQs()
        }
    }
}

struct FAQSectionView: View {
    let title: String
    let questions: [FAQQuestion]
    let onItemTap: (FAQQuestion) -> Void

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                RoundedRectangle(cornerRadius: CornerRadius.medium.value)
                    .fill(
                        LinearGradient(
                            stops: [
                                Gradient.Stop(color: Color.brandPrimary, location: 0.00),
                                Gradient.Stop(color: Color.brandPrimary.opacity(0.75), location: 1.00),
                            ],
                            startPoint: UnitPoint(x: 0.29, y: 0),
                            endPoint: UnitPoint(x: 0.75, y: 0.92)
                        )
                    )
                    .frame(height: 172)
                    .overlay(
                        HStack {
                            Text(title)
                                .font(Font.typography(.bodyMedium))
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Spacer()

                            Image("cloud3")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 131, height: 68)
                                .padding(.top, ViewSpacing.medium)
                        }
                        .frame(height: 54)
                        .padding(.horizontal, ViewSpacing.medium),
                        alignment: .top
                    )
            }
            .padding(.horizontal, ViewSpacing.medium)
            VStack(spacing: ViewSpacing.medium) {
                ForEach(questions) { question in
                    HStack {
                        Text(question.question)
                            .font(Font.typography(.bodySmall))
                            .foregroundColor(.textPrimary)
                            .frame(height: 24)

                        Spacer()

                        Button(action: {
                            onItemTap(question)
                        }) {
                            Image("right-arrow")
                                .foregroundColor(.grey300)
                        }
                    }
                }
            }
            .padding(ViewSpacing.medium)
            .background(Color.surfacePrimary)
            .cornerRadius(CornerRadius.medium.value)
            .offset(y: -3*ViewSpacing.betweenSmallAndBase-ViewSpacing.xxxlarge)
            .padding(.horizontal, ViewSpacing.medium)
            .padding(.bottom, -3*ViewSpacing.betweenSmallAndBase-ViewSpacing.xxxlarge)
        }
    }
}

struct FAQView_Previews: PreviewProvider {
    static var previews: some View {
        RouterView {
            FAQView()
        }
    }
}
