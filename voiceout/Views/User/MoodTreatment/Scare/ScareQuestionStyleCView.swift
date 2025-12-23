//
//  ScareQuestionStyleCView.swift
//  voiceout
//
//  Created by Yujia Yang on 8/27/25.
//

import SwiftUI

private struct SeveritySlider: View {
    @Binding var value: Int
    var outerSize: CGFloat = 32
    var innerSize: CGFloat = 24
    var lineHeight: CGFloat
    @State private var fraction: CGFloat = 0.0
    private let epsilon: CGFloat = 0.03

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let leftX  = outerSize / 2
            let rightX = w - outerSize / 2
            let midX   = (leftX + rightX) / 2
            let baseWidth = rightX - leftX
            let currentX = leftX + fraction * baseWidth

            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            stops: [
                                .init(color:.surfaceBrandPrimary, location: 0.00),
                                .init(color: Color(red: 1, green: 0.81, blue: 0.44), location: 0.50),
                                .init(color: Color(red: 1, green: 0.3,  blue: 0.3),  location: 1.00),
                            ],
                            startPoint: .leading, endPoint: .trailing
                        )
                    )
                    .frame(height: lineHeight)

                HStack(spacing: 0) {
                    Spacer(minLength: 0)
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.surfacePrimaryGrey)
                        .frame(width: baseWidth * (1 - fraction), height: lineHeight)
                }
                .frame(width: baseWidth, height: lineHeight)
                .position(x: (leftX + rightX) / 2, y: h / 2)
                anchorCircle(
                    state: anchorState(for: 0.0),
                    activeColor: .surfaceBrandPrimary
                )
                .position(x: leftX, y: h/2)

                anchorCircle(
                    state: anchorState(for: 0.5),
                    activeColor: Color(red: 1, green: 0.76, blue: 0.43)
                )
                .position(x: midX, y: h/2)

                anchorCircle(
                    state: anchorState(for: 1.0),
                    activeColor: Color(red: 1, green: 0.31, blue: 0.31)
                )
                .position(x: rightX, y: h/2)

                Circle()
                    .fill(colorForValue(value))
                    .frame(width: innerSize, height: innerSize)
                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                    .position(x: currentX, y: h/2)
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { g in
                        let x = min(max(g.location.x, leftX), rightX)
                        fraction = (x - leftX) / baseWidth
                        if abs(fraction - 0.0) <= epsilon {
                            value = 0
                        } else if abs(fraction - 0.5) <= epsilon {
                            value = 1
                        } else if abs(fraction - 1.0) <= epsilon {
                            value = 2
                        }
                    }
                    .onEnded { _ in
                        if fraction < 0.25 {
                            value = 0
                        } else if fraction < 0.75 {
                            value = 1
                        } else {
                            value = 2
                        }
                    }
            )
            .onAppear {
                switch value {
                case 0: fraction = 0.0
                case 1: fraction = 0.5
                default: fraction = 1.0
                }
            }
        }
        .frame(height: max(outerSize, lineHeight))
    }

    private enum AnchorVisualState { case hidden, active, future }

    private func anchorState(for anchor: CGFloat) -> AnchorVisualState {
        if fraction > anchor + epsilon {
            return .hidden
        } else if abs(fraction - anchor) <= epsilon {
            return .active
        } else {
            return .future
        }
    }

    private func anchorCircle(state: AnchorVisualState, activeColor: Color) -> some View {
        Group {
            switch state {
            case .hidden:
                Color.clear.frame(width: outerSize, height: outerSize)
            case .active:
                ZStack {
                    Circle()
                        .fill(Color.surfacePrimaryGrey2)
                        .frame(width: outerSize, height: outerSize)
                    Circle()
                        .fill(activeColor)
                        .frame(width: innerSize, height: innerSize)
                }
            case .future:
                ZStack {
                    Circle()
                        .fill(Color.surfacePrimaryGrey2)
                        .frame(width: outerSize, height: outerSize)
                    Circle()
                        .fill(Color.surfacePrimaryGrey)
                        .frame(width: innerSize, height: innerSize)
                }
            }
        }
    }

    private func colorForValue(_ value: Int) -> Color {
        switch value {
        case 0: return .surfaceBrandPrimary
        case 1: return Color(red: 1, green: 0.76, blue: 0.43)
        case 2: return Color(red: 1, green: 0.31, blue: 0.31)
        default: return .white
        }
    }
}

struct ScareQuestionStyleCView: View {
    let question: MoodTreatmentQuestion
    let onSelect: (MoodTreatmentAnswerOption) -> Void

    @State private var isPlayingMusic: Bool = true
    @State private var showUI: Bool = false
    @State private var score: Int = 0

    private func emojiName(for score: Int) -> String {
        switch score {
        case 0: return "scare-emoji-low"
        case 1: return "scare-emoji-mid"
        default: return "scare-emoji-high"
        }
    }

    var body: some View {
        GeometryReader { _ in
            ZStack(alignment: .topLeading) {
                Color.surfaceBrandTertiaryGreen.ignoresSafeArea()

                VStack(spacing: 0) {
                    ZStack(alignment: .top) {
                        HStack {
                            Spacer()
                            Image("cloud-chat")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 168, height: 120)
                                .padding(.bottom, ViewSpacing.large)
                            Spacer()
                        }
//                        HStack {
//                            MusicButtonView()
//                            Spacer()
//                        }
                    }
                    .padding(.leading, ViewSpacing.medium)

                    ForEach(Array(question.texts?.enumerated() ?? [].enumerated()), id: \.offset) { idx, line in
                        TypewriterText(
                            fullText: line
                        ) {
                            if idx == (question.texts?.count ?? 0) - 1 {
                                withAnimation(.easeIn(duration: 0.25)) {
                                    showUI = true
                                }
                            }
                        }
                        .font(Font.typography(.bodyMedium))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.grey500)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 2*ViewSpacing.xlarge)
                        .padding(.bottom, 2*ViewSpacing.xlarge)
                    }

                    if showUI {
                        Image(emojiName(for: score))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 128, height: 128)
                            .padding(.bottom, 6*ViewSpacing.betweenSmallAndBase)
                            .transition(.opacity)
                    }

                    if showUI {
                        VStack(spacing: ViewSpacing.medium) {
                            SeveritySlider(value: $score, outerSize: 32, innerSize: 24, lineHeight: 6)
                                .padding(.horizontal, ViewSpacing.medium)
                            
                            HStack {
                                Text("轻微")
                                    .font(Font.typography(.bodyXXSmall))
                                    .kerning(0.3)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.textLight)
                                Spacer()
                                Text("强烈")
                                    .font(Font.typography(.bodyXXSmall))
                                    .kerning(0.3)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.textLight)
                                Spacer()
                                Text("极度")
                                    .font(Font.typography(.bodyXXSmall))
                                    .kerning(0.3)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.textLight)
                            }
                            .padding(.horizontal, ViewSpacing.large)
                        }
                        .transition(.opacity)
                    }

                    Spacer()

                    if showUI,
                       let confirmOption = question.options.first(where: { $0.exclusive == true }) {
                        Button {
                            onSelect(confirmOption)
                        } label: {
                            Text(confirmOption.text)
                                .font(Font.typography(.bodyMedium))
                                .kerning(0.64)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.textBrandPrimary)
                                .frame(width: 114, height: 44)
                                .background(Color.surfacePrimary)
                                .cornerRadius(CornerRadius.full.value)
                        }
                        .transition(.opacity)
                    }
                    Spacer(minLength: 12)
                }
            }
            .ignoresSafeArea(edges: .all)
        }
    }
}

struct ScareQuestionStyleCView_Previews: PreviewProvider {
    static var previews: some View {
        ScareQuestionStyleCView(
            question: MoodTreatmentQuestion(
                id: 4,
                totalQuestions: 45,
                uiStyle: .scareStyleC,
                texts: [
                    "可以跟小云朵说下你的害怕程度吗？"
                ],
                animation: nil,
                options: [
                    .init(key: "A",text: "我选好了", next: 5, exclusive: true)
                ],
                introTexts: nil,
                showSlider: true,
                endingStyle: nil,
                routine: "scare"
            ),
            onSelect: { _ in }
        )
    }
}
