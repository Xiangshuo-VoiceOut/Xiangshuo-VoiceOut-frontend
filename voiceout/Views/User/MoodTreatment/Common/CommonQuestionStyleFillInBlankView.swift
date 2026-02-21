//
//  CommonQuestionStyleFillInBlankView.swift
//  voiceout
//
//  Created by Ziyang Ye on 9/21/25.
//

import SwiftUI

struct CommonQuestionStyleFillInBlankView: View {
    let question: MoodTreatmentQuestion
    let onContinue: () -> Void
    
    @State private var currentTextIndex = 0
    @State private var userInput = ""
    @State private var isPlayingMusic = false
    @State private var showCurrentText = true
    @State private var textDone = false
    @State private var introDone = false
    
    @FocusState private var isTextFieldFocused: Bool
    
    private let typingInterval: TimeInterval = 0.1
    
    private var currentText: String {
        guard let texts = question.texts, currentTextIndex < texts.count else {
            return ""
        }
        return texts[currentTextIndex]
    }
    
    private var currentIntroText: String {
        guard let introTexts = question.introTexts, !introTexts.isEmpty else {
            return ""
        }
        return introTexts[0]
    }
    
    private var hasIntroText: Bool {
        return currentTextIndex == 0 && !(question.introTexts?.isEmpty ?? true)
    }
    
    private var isLastText: Bool {
        return currentTextIndex == (question.texts?.count ?? 0) - 1
    }
    
    var body: some View {
        GeometryReader { proxy in
            let screenHeight = proxy.size.height
            let isSmallScreen = screenHeight < 700
            
            ZStack(alignment: .topLeading) {
                Color.surfaceBrandTertiaryGreen
                    .ignoresSafeArea()
                    .onTapGesture {
                        isTextFieldFocused = false
                    }
                
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        Image("cloud-chat")
                            .resizable()
                            .scaledToFit()
                            .frame(height: min(isSmallScreen ? 120 : 160, screenHeight * (isSmallScreen ? 0.15 : 0.18)))
                            .padding(.vertical, isSmallScreen ? ViewSpacing.small : ViewSpacing.xlarge)
                        Spacer()
                    }

                    if showCurrentText {
                        VStack(spacing: 0) {
                            Text(currentText)
                                .id(currentTextIndex)
                                .font(.typography(.bodyLarge))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.textPrimary)
                                .frame(maxWidth: .infinity)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.horizontal, ViewSpacing.medium)
                                .padding(.bottom, isSmallScreen ? ViewSpacing.medium : ViewSpacing.xlarge)
                                .onAppear {
                                    textDone = true
                                }
                            
                            if hasIntroText {
                                if textDone {
                                    TypewriterText(fullText: currentIntroText, characterDelay: typingInterval) {
                                        introDone = true
                                    }
                                    .id("intro-\(currentTextIndex)")
                                    .font(.typography(.bodyLarge))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.textBrandPrimary)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal, ViewSpacing.medium)
                                    .padding(.bottom, isSmallScreen ? ViewSpacing.small : ViewSpacing.medium)
                                }
                                
                                if introDone {
                                    fillInBlankArea(screenHeight: screenHeight, isSmallScreen: isSmallScreen)
                                    
                                    Spacer(minLength: ViewSpacing.small)
                                    
                                    submitButton
                                }
                            } else {
                                if textDone {
                                    fillInBlankArea(screenHeight: screenHeight, isSmallScreen: isSmallScreen)
                                    
                                    Spacer(minLength: ViewSpacing.small)
                                    
                                    submitButton
                                }
                            }
                        }
                    }
                    
                    Spacer(minLength: 0)
                }
            }
        }
        .ignoresSafeArea(edges: .all)
        .onChange(of: currentTextIndex) { _, _ in
            textDone = false
            introDone = false
            userInput = ""
        }
    }
    
    private func fillInBlankArea(screenHeight: CGFloat, isSmallScreen: Bool) -> some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $userInput)
                .font(.typography(.bodyLarge))
                .foregroundColor(Color.surfaceBrandPrimary)
                .tint(.black)
                .focused($isTextFieldFocused)
                .scrollContentBackground(.hidden)
                .padding(.top, ViewSpacing.medium)
                .padding(.horizontal, ViewSpacing.medium)
                .overlay(
                    Group {
                        if userInput.isEmpty {
                            Text(" 请填写")
                                .font(.typography(.bodyLarge))
                                .foregroundColor(.textLight)
                                .allowsHitTesting(false)
                                .padding(.top, ViewSpacing.large)
                                .padding(.leading, ViewSpacing.medium + ViewSpacing.small)
                        }
                    },
                    alignment: .topLeading
                )
        }
        .frame(maxWidth: .infinity)
        .frame(height: screenHeight * (isSmallScreen ? 0.25 : 0.3))
        .background(Color.surfacePrimary)
        .cornerRadius(CornerRadius.medium.value)
        .padding(.horizontal, ViewSpacing.large)
    }
    
    private var submitButton: some View {
        Button("我写好了") {
            AnalyticsManager.shared.logClick(
                elementName: "submit_button",
                screenName: "CommonQuestionStyleFillInBlank",
                additionalParams: [
                    "question_id": question.id,
                    "input_length": userInput.count
                ]
            )
            onContinue()
        }
        .padding(.horizontal, ViewSpacing.medium)
        .padding(.vertical, ViewSpacing.small)
        .frame(width: 114, height: 44)
        .background(Color.surfacePrimary)
        .disabled(userInput.isEmpty)
        .cornerRadius(CornerRadius.full.value)
        .foregroundColor(userInput.isEmpty ? Color.gray : Color(red: 0x67/255.0, green: 0xB8/255.0, blue: 0x99/255.0))
        .font(Font.typography(.bodyMedium))
        .kerning(0.64)
        .multilineTextAlignment(.center)
        .padding(.bottom, ViewSpacing.large)
    }
    
    private func handleContinue() {
        if currentTextIndex < (question.texts?.count ?? 0) - 1 {
            currentTextIndex += 1
            showCurrentText = true
        } else {
            onContinue()
        }
    }
}

#Preview {
    CommonQuestionStyleFillInBlankView(
        question: MoodTreatmentQuestion(
            id: 7,
            totalQuestions: 10,
            uiStyle: .styleFillInBlank,
            texts: ["那在这些环境里，你最想聊的兴趣或爱好是什么呢？"],
            animation: nil,
            options: [],
            introTexts: ["最想聊的是"],
            showSlider: false,
            endingStyle: nil,
            customViewName: nil,
            routine: "sad"
        ),
        onContinue: {}
    )
    .environmentObject(RouterModel())
}
