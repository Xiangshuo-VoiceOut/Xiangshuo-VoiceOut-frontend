//
//  SliderQuestionStyleView.swift
//  voiceout
//
//  Created by Yujia Yang on 11/5/25.
//

import SwiftUI

private struct SeveritySlider: View {
    @Binding var value: Double
    var outerSize: CGFloat = 32
    var innerSize: CGFloat = 24
    var lineHeight: CGFloat

    @State private var fraction: CGFloat

    private let c0 = Color.surfaceBrandPrimary
    private let c1 = Color(red: 1, green: 0.81, blue: 0.44)
    private let c2 = Color(red: 1, green: 0.30, blue: 0.30)

    init(value: Binding<Double>, outerSize: CGFloat = 32, innerSize: CGFloat = 24, lineHeight: CGFloat) {
        self._value = value
        self.outerSize = outerSize
        self.innerSize = innerSize
        self.lineHeight = lineHeight
        self._fraction = State(initialValue: CGFloat(min(max(value.wrappedValue, 0.0), 1.0)))
    }

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let leftX  = outerSize / 2
            let rightX = w - outerSize / 2
            let midX   = (leftX + rightX) / 2
            let baseWidth = rightX - leftX
            let selectedWidth = max(0, min(baseWidth, fraction * baseWidth))
            let currentX = leftX + selectedWidth

            ZStack {
                ZStack {
                    RoundedRectangle(cornerRadius: lineHeight/2)
                        .fill(Color.surfacePrimaryGrey)
                        .frame(width: baseWidth, height: lineHeight)

                    let gradient = LinearGradient(
                        stops: [
                            .init(color: c0, location: 0.00),
                            .init(color: c1, location: 0.50),
                            .init(color: c2, location: 1.00),
                        ],
                        startPoint: .leading, endPoint: .trailing
                    )

                    RoundedRectangle(cornerRadius: lineHeight/2)
                        .fill(gradient)
                        .frame(width: baseWidth, height: lineHeight)
                        .mask(alignment: .leading) {
                            Rectangle().frame(width: selectedWidth, height: lineHeight)
                        }
                }
                .frame(width: baseWidth, height: lineHeight)
                .position(x: midX, y: h/2)
                
                ZStack {
                    Circle()
                        .fill(Color.surfacePrimaryGrey2)
                        .frame(width: outerSize, height: outerSize)

                    Circle()
                        .fill(sampledColor(at: fraction))
                        .frame(width: innerSize, height: innerSize)
                }
                .shadow(color: Color.black.opacity(0.08), radius: 2, x: 0, y: 1)
                .position(x: currentX, y: h/2)
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { g in
                        let x = min(max(g.location.x, leftX), rightX)
                        let f = (x - leftX) / baseWidth
                        fraction = f
                        value = Double(f)
                    }
            )
        }
        .frame(height: max(outerSize, lineHeight))
    }

    private func sampledColor(at fIn: CGFloat) -> Color {
        let f = max(0, min(1, fIn))

        func rgba(_ c: Color) -> (CGFloat, CGFloat, CGFloat, CGFloat) {
            #if canImport(UIKit)
            var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
            UIColor(c).getRed(&r, green: &g, blue: &b, alpha: &a)
            return (r, g, b, a)
            #else
            return (0, 0, 0, 1)
            #endif
        }

        func mix(_ p: (CGFloat, CGFloat, CGFloat, CGFloat),
                 _ q: (CGFloat, CGFloat, CGFloat, CGFloat),
                 t: CGFloat) -> Color {
            let r = p.0 + (q.0 - p.0) * t
            let g = p.1 + (q.1 - p.1) * t
            let b = p.2 + (q.2 - p.2) * t
            let a = p.3 + (q.3 - p.3) * t
            return Color(red: r, green: g, blue: b, opacity: a)
        }

        if f <= 0.5 {
            let t = f / 0.5
            return mix(rgba(c0), rgba(c1), t: t)
        } else {
            let t = (f - 0.5) / 0.5
            return mix(rgba(c1), rgba(c2), t: t)
        }
    }
}

struct SliderQuestionStyleView: View {
    let question: MoodTreatmentQuestion
    let onSelect: (MoodTreatmentAnswerOption) -> Void

    @State private var isPlayingMusic: Bool = true
    @State private var showUI: Bool = false
    @State private var score: Double = 0.5

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
                                .padding(.bottom, ViewSpacing.xxxsmall+ViewSpacing.base+ViewSpacing.medium)
                            Spacer()
                        }
                        HStack {
                            MusicButtonView()
                            Spacer()
                        }
                    }
                    .padding(.leading, ViewSpacing.medium)

                    ForEach(Array(question.texts?.enumerated() ?? [].enumerated()), id: \.offset) { idx, line in
                        Text(line)
                            .font(Font.typography(.bodyMedium))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.grey500)
                            .frame(maxWidth: .infinity, alignment: .top)
                            .padding(.bottom, 162)
                            .onAppear {
                                if idx == (question.texts?.count ?? 0) - 1 {
                                    withAnimation(.easeIn(duration: 0.25)) {
                                        showUI = true
                                    }
                                }
                            }
                    }

                    if showUI {
                        VStack(spacing: ViewSpacing.xsmall+ViewSpacing.medium) {
                            SeveritySlider(value: $score, outerSize: 32, innerSize: 24, lineHeight: 8)
                                .padding(.horizontal, ViewSpacing.small)

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
                                .background(Color.grey50)
                                .cornerRadius(CornerRadius.full.value)
                        }
                        .padding(.bottom, 55)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .transition(.opacity)
                    }
                }
            }
            .ignoresSafeArea(edges: .all)
        }
    }
}

struct SliderQuestionStyleView_Previews: PreviewProvider {
    static var previews: some View {
        SliderQuestionStyleView(
            question: MoodTreatmentQuestion(
                id: 4,
                totalQuestions: 45,
                uiStyle: .sliderStyle,
                texts: [
                    "内疚感是否基于真实的影响，而不是猜测或想象?"
                ],
                animation: nil,
                options: [
                    .init(key: "A", text: "继续", next: 5, exclusive: true)
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
