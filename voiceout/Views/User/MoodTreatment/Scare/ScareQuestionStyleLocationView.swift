//
//  ScareQuestionStyleLocationView.swift
//  voiceout
//
//  Created by Yujia Yang on 8/27/25.
//

import SwiftUI

private struct ConcentricRingsSelector: View {
    @Binding var selectedIndex: Int?
    var ringCount: Int = 4
    var allowedIndices: Set<Int> = [0, 1, 2, 3]
    var highlightColor: Color = Color.borderBrandSecondary
    
    private func fillColor(for ringIndex: Int) -> Color {
        switch ringIndex {
        case 0: return Color(red: 0.4, green: 0.61, blue: 0.72).opacity(0.4)
        case 1: return Color(red: 0.4, green: 0.66, blue: 0.72).opacity(0.4)
        case 2: return Color.surfaceBrandPrimary.opacity(0.4)
        default: return Color(red: 0.7, green: 0.72, blue: 0.4).opacity(0.4)
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            let side = min(geo.size.width, geo.size.height)
            let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
            let outerR = side / 2
            let ringW = outerR / CGFloat(ringCount)
            
            ZStack {
                ForEach((0..<ringCount).reversed(), id: \.self) { i in
                    let r = CGFloat(i + 1) * ringW
                    Circle()
                        .fill(fillColor(for: i))
                        .frame(width: r * 2, height: r * 2)
                }
                
                ForEach(1..<ringCount, id: \.self) { i in
                    let r = CGFloat(i) * ringW
                    Circle()
                        .stroke(.white, lineWidth: 2)
                        .frame(width: r * 2, height: r * 2)
                }
                
                if let sel = selectedIndex, allowedIndices.contains(sel) {
                    let r = CGFloat(sel + 1) * ringW
                    Circle()
                        .stroke(highlightColor, lineWidth: 2)
                        .frame(width: r * 2, height: r * 2)
                }
                
                Image("location-home")
                    .resizable()
                    .scaledToFit()
                    .frame(width: ringW * 1.2, height: ringW * 1.2)
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onEnded { g in
                        let dx = g.location.x - center.x
                        let dy = g.location.y - center.y
                        let d = sqrt(dx * dx + dy * dy)
                        guard d <= outerR else { return }
                        
                        let idx = Int(floor(d / ringW))
                        guard (0..<ringCount).contains(idx),
                              allowedIndices.contains(idx) else { return }
                        
                        selectedIndex = idx
                    }
            )
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

struct ScareQuestionStyleLocationView: View {
    let question: MoodTreatmentQuestion
    let onSelect: (MoodTreatmentAnswerOption) -> Void
    
    @State private var isPlayingMusic: Bool = true
    @State private var showUI: Bool = false
    @State private var selectedRing: Int? = nil
    
    private var locationOptions: [MoodTreatmentAnswerOption] {
        question.options.filter { ($0.exclusive ?? false) == false }
    }

    private var confirmOption: MoodTreatmentAnswerOption? {
        question.options.first(where: { $0.exclusive ?? false })
    }

    private func selectedLocationOption() -> MoodTreatmentAnswerOption? {
        guard let idx = selectedRing,
              locationOptions.indices.contains(idx) else { return nil }
        return locationOptions[idx]
    }

    private func descriptionForSelectedRing() -> String {
        selectedLocationOption()?.text ?? ""
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
                        TypewriterText(fullText: line) {
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
                        .padding(.horizontal, ViewSpacing.medium+ViewSpacing.xlarge)
                        .padding(.bottom, ViewSpacing.large)
                    }
                    
                    if showUI {
                        ConcentricRingsSelector(selectedIndex: $selectedRing, ringCount: 4)
                            .padding(.horizontal, ViewSpacing.xlarge)
                            .frame(maxWidth: .infinity)
                            .transition(.opacity)
                    }

                    if showUI {
                        Text(descriptionForSelectedRing())
                            .font(Font.typography(.bodySmall))
                            .foregroundColor(.grey500)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, ViewSpacing.medium+ViewSpacing.xlarge)
                            .padding(.top, ViewSpacing.medium)
                            .animation(.easeInOut(duration: 0.2), value: selectedRing)
                    }

                    Spacer()

                    if showUI,
                       selectedRing != nil,
                       let confirmOption = confirmOption {
                        Button {
                            if let selected = selectedLocationOption() {
                                onSelect(selected)
                            }
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

struct ScareQuestionStyleLocationView_Previews: PreviewProvider {
    static var previews: some View {
        ScareQuestionStyleLocationView(
            question: MoodTreatmentQuestion(
                id: 4,
                totalQuestions: 45,
                uiStyle: .scareStyleLocation,
                texts: [
                    "我们先来描述一下你目前所处的环境，可以讲讲你现在在哪里、周围的情况是什么样的、有哪些人或物在你身边？"
                ],
                animation: nil,
                options: [
                    .init( key: "A",text: "我在自己家里，家里没人，还算安静 ", next: 6, exclusive: false),
                    .init( key: "B",text: "我不在家，但我在另外一个熟悉的地方", next: 6, exclusive: false),
                    .init(key: "C",text: "我在外面，有熟悉的人在身边", next: 12, exclusive: false),
                    .init(key: "D",text: "我在一个陌生的地方，心里不太踏实", next: 12, exclusive: false),
                    .init(key: "E",text: "我选好了", next: 5, exclusive: true)
                ],
                introTexts: nil,
                showSlider: false,
                endingStyle: nil,
                routine: "scare"
            ),
            onSelect: { option in}
        )
    }
}
