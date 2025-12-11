//
//  AngryIntensificationQuestionStyleView.swift
//  voiceout
//
//  Created by Yujia Yang on 10/31/25.
//

import SwiftUI

struct AngryIntensificationQuestionStyleView: View {
    @EnvironmentObject var router: RouterModel
    let question: MoodTreatmentQuestion
    let onSelect: (MoodTreatmentAnswerOption) -> Void
    @State private var showButton = false

    var body: some View {
        ZStack {
            Color.surfaceBrandTertiaryGreen.ignoresSafeArea()

            VStack(spacing: 0) {
                ZStack(alignment: .top) {
                    HStack {
                        Spacer()
                        Image("cloud-chat")
                            .frame(width: 168, height: 120)
                            .padding(.bottom, ViewSpacing.large)
                        Spacer()
                    }
                    HStack {
                        MusicButtonView()
                        Spacer()
                    }
                }
                .padding(.leading, ViewSpacing.medium)

                let lines = question.texts ?? []
                ForEach(Array(lines.enumerated()), id: \.offset) { idx, line in
                    TypewriterText(
                        fullText: line
                    ) {
                        if idx == lines.count - 1 {
                            withAnimation(.easeIn(duration: 0.25)) {
                                showButton = true
                            }
                        }
                    }
                    .font(Font.typography(.bodyMedium))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.grey500)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 2 * ViewSpacing.xlarge)
                    .padding(.bottom, ViewSpacing.medium)
                }

                Spacer(minLength: 0)
            }
        }
        .overlay(alignment: .bottom) {
            if showButton,
               let confirmOption = question.options.first(where: { $0.exclusive == true }) {
                Button {
                    onSelect(confirmOption)
                    router.navigateTo(.playRelaxVideo(name: "relax", ext: "mov"))
                } label: {
                    Text(confirmOption.text)
                        .font(Font.typography(.bodyMedium))
                        .kerning(0.64)
                        .foregroundColor(Color(red: 0, green: 0.6, blue: 0.8))
                        .frame(width: 114, height: 44)
                        .background(Color.surfacePrimary)
                        .cornerRadius(CornerRadius.full.value)
                }
                .padding(.bottom, ViewSpacing.medium+ViewSpacing.large+2*ViewSpacing.xxxxlarge)
                .transition(.opacity)
            }
        }
    }
}

struct AngryIntensificationQuestionStyleView_Previews: PreviewProvider {
    static var previews: some View {
        AngryIntensificationQuestionStyleView(
            question: MoodTreatmentQuestion(
                id: 4,
                totalQuestions: 45,
                uiStyle: .styleB,
                texts: [
                    "没关系，\n先一起深呼吸，让这份难过有个可以放下的地方。"
                ],
                animation: nil,
                options: [
                    .init(key: "A", text: "好呀", next: 5, exclusive: true)
                ],
                introTexts: nil,
                showSlider: nil,
                endingStyle: nil,
                routine: "anger"
            ),
            onSelect: { _ in }
        )
        .environmentObject(RouterModel())
    }
}
