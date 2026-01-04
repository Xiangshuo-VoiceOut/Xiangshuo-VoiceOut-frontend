//
//  AnxietyQuestionStyleMatchingView.swift
//  voiceout
//
//  Created by Ziyang Ye on 10/15/25.
//

import SwiftUI

struct AnxietyQuestionStyleMatchingView: View {
    let question: MoodTreatmentQuestion
    let onConfirm: (_ next: Int?) -> Void
    
    @State private var isPlayingMusic = false
    @State private var showCurrentText = true
    @State private var selectedOptions: Set<String> = []
    @State private var showOptions = false
    
    private let typingInterval: TimeInterval = 0.1
    
    private let testOptions = [
        "善良", "诚实", "责任感", "勇气", "感恩", "礼貌",
        "耐心", "坚持", "独立", "宽容", "同情心", "正义感"
    ]
    
    private var confirmOption: MoodTreatmentAnswerOption? {
        question.options.first(where: { $0.exclusive == true })
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .topLeading) {
                Color.surfaceBrandTertiaryGreen
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    ZStack(alignment: .topLeading) {
                        HStack {
                            Spacer()
                            Image("cloud-chat")
                                .resizable()
                                .frame(width: 168, height: 120)
                                .padding(.bottom, ViewSpacing.large)
                            Spacer()
                        }
                        
//                        Button {
//                            isPlayingMusic.toggle()
//                        } label: {
//                            Image(isPlayingMusic ? "music" : "stop-music")
//                                .resizable()
//                                .frame(width: 48, height: 48)
//                        }
//                        .padding(.leading, ViewSpacing.medium)
                    }

                    VStack(spacing: ViewSpacing.medium) {
                        if showCurrentText {
                            VStack(spacing: ViewSpacing.small) {
                                TypewriterText(
                                    fullText: question.texts?.first ?? "",
                                    characterDelay: typingInterval
                                ) {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        showOptions = true
                                    }
                                }
                                .id("firstText")
                            }
                            .font(.typography(.bodyMedium))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.grey500)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.bottom, ViewSpacing.small)
                        }
                        
                        if showOptions {
                            optionsArea
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, ViewSpacing.large)
                    
                    bottomButtonArea
                }
            }
        }
        .ignoresSafeArea(edges: .all)
    }
    
    private var optionsArea: some View {
        VStack(spacing: ViewSpacing.medium) {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: ViewSpacing.small), count: 3), spacing: ViewSpacing.medium) {
                ForEach(testOptions, id: \.self) { option in
                    AnxietyOptionCircleView(
                        option: option,
                        isSelected: selectedOptions.contains(option)
                    ) {
                        toggleSelection(option)
                    }
                }
            }
            .padding(.horizontal, ViewSpacing.medium)
        }
    }
    
    private var bottomButtonArea: some View {
        VStack {
            if showCurrentText, let confirmOption {
                Button(confirmOption.text) {
                    onConfirm(confirmOption.next)
                }
                .font(.typography(.bodyMedium))
                .foregroundColor(.textBrandPrimary)
                .frame(width: 114, height: 44)
                .padding(.horizontal, ViewSpacing.medium)
                .padding(.vertical, ViewSpacing.small)
                .background(Color.grey50)
                .cornerRadius(CornerRadius.full.value)
                .padding(.bottom, ViewSpacing.large)
            }
        }
    }
    
    private func toggleSelection(_ option: String) {
        if selectedOptions.contains(option) {
            selectedOptions.remove(option)
        } else {
            selectedOptions.insert(option)
        }
    }
}

struct AnxietyOptionCircleView: View {
    let option: String
    let isSelected: Bool
    let onTap: () -> Void
    
    private let optionColor = Color(red: 169/255.0, green: 216/255.0, blue: 241/255.0)
    
    var body: some View {
        Button(action: onTap) {
            Text(option)
                .font(Font.typography(.bodySmall))
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.center)
                .padding(.vertical, ViewSpacing.large)
                .padding(.horizontal,ViewSpacing.xxxsmall+ViewSpacing.xxsmall+ViewSpacing.xsmall)
                .frame(width: 72, height: 72)
                .background(
                    Circle()
                        .fill(isSelected ? optionColor : Color.clear)
                        .overlay(
                            Circle()
                                .stroke(optionColor, lineWidth: StrokeWidth.width200.value)
                        )
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    AnxietyQuestionStyleMatchingView(
        question: MoodTreatmentQuestion(
            id: 3,
            totalQuestions: 10,
            uiStyle: .styleAnxietyMatching,
            texts: ["然后，小云朵希望你能圈出自己具有的品德："],
            animation: nil,
            options: [
                .init(key: "confirm", text: "继续", next: 4, exclusive: true)
            ],
            introTexts: nil,
            showSlider: false,
            endingStyle: nil,
            customViewName: nil,
            routine: "anxiety"
        ),
        onConfirm: { next in
        }
    )
}
