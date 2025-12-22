//
//  SadQuestionStyleFillInBlankView.swift
//  voiceout
//
//  Created by Ziyang Ye on 9/21/25.
//

import SwiftUI

struct SadQuestionStyleFillInBlankView: View {
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
        return texts[currentTextIndex].replacingOccurrences(of: "，", with: "，\n")
            .replacingOccurrences(of: ",", with: ",\n")
    }
    
    private var currentIntroText: String {
        guard let introTexts = question.introTexts, !introTexts.isEmpty else {
            return ""
        }
        var text = introTexts[0]
        text = text.replacingOccurrences(of: "，", with: "，\n")
        text = text.replacingOccurrences(of: ",", with: ",\n")
        text = text.replacingOccurrences(of: "？", with: "？\n")
        text = text.replacingOccurrences(of: "?", with: "?\n")
        return text
    }
    
    private var hasIntroText: Bool {
        return currentTextIndex == 0 && !(question.introTexts?.isEmpty ?? true)
    }
    
    private var isLastText: Bool {
        return currentTextIndex == (question.texts?.count ?? 0) - 1
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .topLeading) {
                Color.surfaceBrandTertiaryGreen
                    .ignoresSafeArea()
                    .onTapGesture {
                        isTextFieldFocused = false  // Dismiss keyboard
                    }
                
                VStack(spacing: 0) {
                    ZStack(alignment: .topLeading) {
                        HStack {
                            Spacer()
                            Image("cloud-chat")
                                .resizable()
                                .frame(width: 168, height: 120)
                                .padding(.vertical, 15.569)
                                .padding(.horizontal, 0.842)
                            Spacer()
                        }
                        
                        Button {
                            isPlayingMusic.toggle()
                        } label: {
                            Image(isPlayingMusic ? "music" : "stop-music")
                                .resizable()
                                .frame(width: 48, height: 48)
                        }
                        .padding(.leading, ViewSpacing.medium)
                    }
                    .padding(.bottom, 24)

                    if showCurrentText {
                        VStack(spacing: 0) {
                            VStack {
                                Text(currentText)
                                    .id(currentTextIndex)
                                    .font(Font.custom("Alibaba PuHuiTi 3.0", size: 16))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(red: 0.29, green: 0.27, blue: 0.31))
                                    .frame(width: 358, alignment: .top)
                                    .onAppear {
                                        textDone = true
                                    }
                            }
                            .frame(minHeight: 22.4 * 2, alignment: .top)
                            
                            if hasIntroText {
                                Color.clear
                                    .frame(height: 16)
                                
                                VStack {
                                    if textDone {
                                        TypewriterText(fullText: currentIntroText, characterDelay: typingInterval) {
                                            introDone = true
                                        }
                                        .id("intro-\(currentTextIndex)")
                                        .font(Font.custom("Alibaba PuHuiTi 3.0", size: 16))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.4, green: 0.72, blue: 0.6))
                                        .fixedSize(horizontal: false, vertical: true)
                                        .frame(width: 358, alignment: .top)
                                    }
                                }
                                .frame(width: 358)
                                .frame(minHeight: 22.4 * 4, alignment: .top)
                                
                                if introDone {
                                    Color.clear
                                        .frame(height: 40)
                                    
                                    fillInBlankArea
                                    
                                    Color.clear
                                        .frame(height: 142)
                                    
                                    Button("我写好了") {
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
                                    .padding(.bottom, 68)
                                }
                            } else {
                                if textDone {
                                    Color.clear
                                        .frame(height: 40)
                                    
                                    fillInBlankArea
                                    
                                    Color.clear
                                        .frame(height: 142)
                                    
                                    Button("我写好了") {
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
                                    .padding(.bottom, 68)
                                }
                            }
                        }
                        .padding(.horizontal, ViewSpacing.medium)
                    }
                    
                    Spacer()
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
    
    
    private var fillInBlankArea: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $userInput)
                .font(Font.custom("Alibaba PuHuiTi 3.0", size: 18))
                .foregroundColor(Color(red: 0.29, green: 0.27, blue: 0.31))
                .tint(.black)
                .focused($isTextFieldFocused)
                .scrollContentBackground(.hidden)
                .frame(width: 294, height: 241, alignment: .topLeading)
                .padding(.top, 25)
                .padding(.leading, 16)
                .padding(.trailing, 11)
                .overlay(
                    Group {
                        if userInput.isEmpty {
                            Text(" 请填写")
                                .font(Font.custom("Alibaba PuHuiTi 3.0", size: 18))
                                .foregroundColor(Color(red: 0.79, green: 0.77, blue: 0.82))
                                .allowsHitTesting(false)
                                .padding(.top, 25 + 8)
                                .padding(.leading, 16 + 5)
                        }
                    },
                    alignment: .topLeading
                )
        }
        .frame(width: 294 + 16 + 11, height: 241, alignment: .topLeading)
        .background(Color(red: 0.98, green: 0.99, blue: 1))
        .cornerRadius(16)
        .clipped()
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
    SadQuestionStyleFillInBlankView(
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
