//
//  AngryQuestionStyleFView.swift
//  voiceout
//
//  Created by Yujia Yang on 6/4/25.
//

import SwiftUI

struct AngryQuestionStyleFView: View {
    let questionTemplates: [String]
    let onConfirm: ([String]) -> Void
    let question: MoodTreatmentQuestion
    let onSelect: (MoodTreatmentAnswerOption) -> Void
    
    @State private var isPlayingMusic = true
    @State private var displayedCount = 0
    @State private var bubbleHeight: CGFloat = 0
    @State private var showOptions = false
    @State private var editingIndex: EditableIndex? = nil
    @State private var selectedIndex: Int? = nil
    @State private var selectedText: String = ""
    @State private var stackOffset: CGFloat = 0
    
    private let bubbleSpacing: CGFloat = 24
    private let displayDuration: TimeInterval = 1.5
    private let animationDuration: TimeInterval = 0.5
    
    private let bubbleFrameHeight: CGFloat = 48 + 64 + 71
    
    var body: some View {
        GeometryReader { proxy in
            let safeTop = proxy.safeAreaInsets.top
            let texts = question.texts ?? []
            
            ZStack(alignment: .topLeading) {
                Color.surfaceBrandTertiaryGreen
                    .ignoresSafeArea(edges: .bottom)
                
                MusicButtonView()
                    .padding(.leading, ViewSpacing.medium)
                
                VStack {
                    Spacer()
                    Image("bucket")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                }
                
                VStack(spacing: 0) {
                    HStack(alignment: .bottom, spacing: 0) {
                        Image("cloud-chat")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 71)
                            .scaleEffect(x: -1, y: 1)
                            .offset(x: -ViewSpacing.medium)
                            .frame(width: 68)
                        
                        BubbleScrollView(
                            texts: texts,
                            displayedCount: $displayedCount,
                            bubbleHeight: $bubbleHeight,
                            bubbleSpacing: ViewSpacing.large,
                            totalHeight: bubbleFrameHeight
                        )
                        .frame(height: bubbleFrameHeight)
                        
                        Spacer()
                    }
                    
                    if showOptions {
                        HStack {
                            Spacer()
                            VStack(alignment: .trailing, spacing: ViewSpacing.small) {
                                ForEach(questionTemplates.indices, id: \.self) { idx in
                                    let isSel = selectedIndex == idx
                                    let display = isSel ? selectedText : questionTemplates[idx]
                                    Button {
                                        editingIndex = EditableIndex(id: idx)
                                    } label: {
                                        Text(display)
                                            .font(Font.typography(.bodyMedium))
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .foregroundColor(.grey500)
                                            .padding(.horizontal, ViewSpacing.medium)
                                            .padding(.vertical, ViewSpacing.base)
                                            .background(isSel
                                                        ? Color(red: 0.42, green: 0.81, blue: 0.95)
                                                        : Color.surfacePrimary)
                                            .cornerRadius(12)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .inset(by: 1)
                                                    .stroke(Color(red: 0.42, green: 0.81, blue: 0.95),
                                                            lineWidth: 4)
                                            )
                                    }
                                }
                            }
                            .frame(width: 264, alignment: .topTrailing)
                        }
                        .padding(.top, ViewSpacing.medium+ViewSpacing.large)
                        .padding(.trailing, ViewSpacing.medium)
                        .transition(.opacity)
                    }
                    
                    Spacer()
                }
            }
            .ignoresSafeArea(edges: .all)
            .fullScreenCover(item: $editingIndex) { editable in
                FillInBlankEditorView(
                    prompt: questionTemplates[editable.id],
                    initialText: selectedIndex == editable.id ? selectedText : "",
                    onDone: { value in
                        selectedIndex = editable.id
                        selectedText = questionTemplates[editable.id]
                            .replacingOccurrences(of: "___", with: value)
                        editingIndex = nil
                    },
                    onCancel: {
                        editingIndex = nil
                    }
                )
            }
            .onAppear { startBubbleSequence() }
        }
    }
    
    private func startBubbleSequence() {
        guard let texts = question.texts else { return }
        for idx in texts.indices {
            let delay = Double(idx) * (displayDuration + animationDuration)
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.easeInOut(duration: animationDuration)) {
                    displayedCount += 1
                }
                if idx == texts.count - 1 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        withAnimation(.easeIn) {
                            showOptions = true
                        }
                    }
                }
            }
        }
    }
    
    private struct EditableIndex: Identifiable {
        let id: Int
    }
    
    private func startBubbleSequence(maxVisible: Int) {
        let lines = question.texts ?? []
        let singleRow = bubbleHeight + bubbleSpacing
        
        for i in lines.indices {
            let showTime = Double(i) * (displayDuration + animationDuration)
            DispatchQueue.main.asyncAfter(deadline: .now() + showTime) {
                displayedCount += 1
                guard i < lines.count - 1 else { return }
                if displayedCount > maxVisible {
                    DispatchQueue.main.asyncAfter(deadline: .now() + displayDuration) {
                        withAnimation(.easeInOut(duration: animationDuration)) {
                            stackOffset -= singleRow
                        }
                    }
                }
            }
        }
    }
}

struct FillInBlankEditorView: View {
    let prompt: String
    let initialText: String
    var onDone: (String) -> Void
    var onCancel: () -> Void

    @State private var inputText: String = ""
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            StickyHeaderView(
                title: "心情便签",
                leadingComponent: AnyView(
                    Button(action: {
                        onCancel()
                        dismiss()
                    }) {
                        Image("left-arrow")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.grey500)
                    }
                ),
                trailingComponent: AnyView(
                    ButtonView(
                        text: "完成",
                        action: {
                            onDone(inputText.trimmingCharacters(in: .whitespacesAndNewlines))
                            dismiss()
                        },
                        variant: .solid,
                        theme: .action,
                        spacing: .xsmall,
                        fontSize: .small,
                        borderRadius: .full
                    )
                    .padding(.trailing, ViewSpacing.medium)
                ),
                backgroundColor: Color.clear
            )
            .frame(height: 44)

            VStack(alignment: .leading, spacing: ViewSpacing.small) {
                let parts = prompt.components(separatedBy: "___")
                if parts.count == 2 {
                    HStack(spacing: 0) {
                        Text(parts[0])
                            .font(.typography(.bodyMedium))
                            .foregroundColor(.textTitle)
                            .lineLimit(1)
                            .layoutPriority(1)

                        TextField("", text: $inputText)
                            .font(.typography(.bodyMedium))
                            .foregroundColor(.textPrimary)
                            .lineLimit(1)
                            .overlay(
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(.textLight),
                                alignment: .bottomLeading
                            )
                            .padding(.horizontal, ViewSpacing.xsmall)
                    }
                    Text(parts[1])
                        .font(.typography(.bodyMedium))
                        .foregroundColor(.grey200)
                } else {
                    Text(prompt)
                        .font(.typography(.bodyMedium))
                        .foregroundColor(.textPrimary)
                }
            }
            .padding(.horizontal, ViewSpacing.large)
            .padding(.top, ViewSpacing.medium+ViewSpacing.large)

            Spacer()
        }
        .onAppear {
            inputText = initialText
        }
        .background(Color.surfaceBrandTertiaryGreen.ignoresSafeArea())
    }
}

#Preview {
    AngryQuestionStyleFView(
        questionTemplates: [
            "我活在当下。我的身边有___（填入物品、植物等前面的东西）",
            "我看到眼前让我喜悦的事物是___（如美食/美景）",
            "我生命中让我喜爱的人/事物是___（家人/朋友/爱人，或爱好等）"
        ],
        onConfirm: { answers in
            print("用户填写的答案是：", answers)
        },
        question: MoodTreatmentQuestion(
            id: 999,
            totalQuestions: 45,
            type: .fillInBlank,
            uiStyle: .styleF,
            texts: ["首先，请记住每一次你回想起令你感到愤怒的情景，情绪涌上来，都是又回到了那一刻，这是在重复伤害自己~","我希望能帮你能用其他方法疏解生气的感觉。","请和我一起回到当下，此时此刻："],
            animation: nil,
            options: [
                .init(key: "A",text: "下一步", next: 998, exclusive: false)
            ],
            introTexts: ["我希望能帮你用其他方法疏解生气的感觉。","我希望能帮你用其他方法疏解生气的感觉。"],
            showSlider: nil,
            endingStyle: nil,
            routine: "anger"
        ),
        onSelect: { selected in
        }
    )
}
