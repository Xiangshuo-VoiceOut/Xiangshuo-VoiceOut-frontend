//
//  ScareQuestionStyleBubble2View.swift
//  voiceout
//
//  Created by Yujia Yang on 9/19/25.
//

import SwiftUI

struct BottleOption2View: View {
    let text: String
    let isSelected: Bool

    var body: some View {
        ZStack {
            if isSelected {
                Image("bottle-option-selected")
                    .resizable()
                    .frame(width: 120, height: 46)
            } else {
                Image("bottle3")
                    .resizable()
                    .frame(width: 113, height: 99)
            }

            Text(text)
                .foregroundColor(.grey500)
                .multilineTextAlignment(.center)
                .frame(width: 53, alignment: .top)
        }
    }
}

struct ScareQuestionStyleBubble2View: View {
    let question: MoodTreatmentQuestion
    let onSelect: (MoodTreatmentAnswerOption) -> Void
    
    @State private var selectedIndices: Set<Int> = []
    @State private var isPlayingMusic: Bool = true
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.surfaceBrandTertiaryGreen.ignoresSafeArea()
            
            VStack(spacing: ViewSpacing.large) {
                ZStack(alignment: .top) {
                    HStack {
                        Spacer()
                        Image("cloud-chat")
                            .resizable()
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
                
                if let texts = question.texts, !texts.isEmpty {
                    Text(texts[0])
                        .font(.typography(.bodyMedium))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.grey500)
                        .frame(alignment: .top)
                        .padding(.bottom, 5 * ViewSpacing.base)
                        .padding(.horizontal, ViewSpacing.large)
                }
                
                let options = question.options
                
                ZStack {
                    ForEach(options.indices, id: \.self) { idx in
                        let opt = options[idx]
                        if opt.exclusive != true {
                            Button {
                                if selectedIndices.contains(idx) {
                                    selectedIndices.remove(idx)
                                } else {
                                    selectedIndices.insert(idx)
                                }
                            } label: {
                                BottleOption2View(
                                    text: opt.text,
                                    isSelected: selectedIndices.contains(idx)
                                )
                            }
                            .offset(offsetForIndex(idx))
                        }
                    }
                }
                .padding(.top,ViewSpacing.medium)
                
                Spacer()
                
                if let confirmOption = options.first(where: { $0.exclusive == true }) {
                    HStack {
                        Spacer()
                        Button {
                            let selected = options
                                .filter { $0.exclusive != true }
                                .enumerated()
                                .filter { selectedIndices.contains($0.offset) }
                                .map { $0.element }
                            
                            onSelect(confirmOption)
                            selected.forEach { onSelect($0) }
                        } label: {
                            Text(confirmOption.text)
                                .font(.typography(.bodyMedium))
                                .foregroundColor(.textBrandPrimary)
                                .padding(.horizontal, ViewSpacing.medium)
                                .padding(.vertical, ViewSpacing.small)
                                .frame(height: 44)
                                .background(Color.surfacePrimary)
                                .cornerRadius(CornerRadius.full.value)
                        }
                        .disabled(selectedIndices.isEmpty)
                        
                        Spacer()
                    }
                    .padding(.bottom, ViewSpacing.xlarge)
                }
            }
        }
    }
    
    private func offsetForIndex(_ idx: Int) -> CGSize {
        switch idx {
        case 0: return CGSize(width: -100, height: -70)
        case 1: return CGSize(width: 110, height: -60)
        case 2: return CGSize(width: 10, height: 10)
        case 3: return CGSize(width: -90, height: 90)
        case 4: return CGSize(width: 110, height: 60)
        case 5: return CGSize(width: -60, height: 210)
        case 6: return CGSize(width: 70, height: 190)
        default: return .zero
        }
    }
}

#Preview {
    let q = MoodTreatmentQuestion(
        id: 24,
        totalQuestions: 45,
        uiStyle: .styleBottle,
        texts: ["这些情绪对xxx的身体带来了什么影响呢？"],
        animation: nil,
        options: [
            .init(key: "A", text: "心跳加快", next: 35, exclusive: false),
            .init(key: "B", text: "食欲减退", next: 36, exclusive: false),
            .init(key: "C", text: "出汗", next: 37, exclusive: false),
            .init(key: "D", text: "肠胃不舒服", next: 38, exclusive: false),
            .init(key: "E", text: "记忆力减退", next: 39, exclusive: false),
            .init(key: "F", text: "心情低落", next: 40, exclusive: false),
            .init(key: "G", text: "减少社交", next: 41, exclusive: false),
            .init(key: "H", text: "我选好了", next: 42, exclusive: true)
        ],
        introTexts: nil,
        showSlider: false,
        endingStyle: nil,
        customViewName: nil,
        routine: "scare"
    )
    return ScareQuestionStyleBubble2View(question: q, onSelect: { opt in
    })
    .environmentObject(RouterModel())
}
