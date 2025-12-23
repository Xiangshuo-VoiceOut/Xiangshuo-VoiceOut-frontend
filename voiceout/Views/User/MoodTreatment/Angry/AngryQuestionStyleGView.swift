//
//  AngryQuestionStyleGView.swift
//  voiceout
//
//  Created by Yujia Yang on 6/10/25.
//

import SwiftUI

struct AngryQuestionStyleGView: View {
    let question: MoodTreatmentQuestion
    let onSelect: (MoodTreatmentAnswerOption) -> Void
    
    @State private var isPlayingMusic = true
    @State private var userInput: String = ""
    
    @State private var introDone = false
    @State private var inputDone = false
    @State private var praiseDone = false
    
    private let praiseText =
    "真棒呀，你已经有可以执行的计划了！这是掌控情绪的一大步。接下来，请给自己一些时间，尝试从第一个方案开始做吧，我相信你~"
    
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
                        
//                        MusicButtonView()
//                            .padding(.leading, ViewSpacing.medium)
                    }

                    VStack(spacing: ViewSpacing.large) {
                        if !inputDone {
                            VStack(spacing: ViewSpacing.small) {
                                ForEach(question.texts ?? [], id: \.self) { line in
                                    if !introDone {
                                        TypewriterText(fullText: line) {
                                            if line == question.texts?.last {
                                                introDone = true
                                            }
                                        }
                                    } else {
                                        Text(line)
                                    }
                                }
                            }
                            .font(.typography(.bodyMedium))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.grey500)
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                        
                        if introDone && !inputDone {
                            Text("我想尝试的第一种：")
                                .font(.typography(.bodyMedium))
                                .foregroundColor(.grey500)
                                .frame(width: 252, alignment: .topLeading)
                            
                            HStack(alignment: .top, spacing: ViewSpacing.small) {
                                Image("edit")
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.textLight)
                                
                                TextField("...", text: $userInput)
                                    .font(.typography(.bodyMedium))
                                    .foregroundColor(.textLight)
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.horizontal, ViewSpacing.medium)
                            .padding(.vertical, ViewSpacing.base)
                            .frame(maxWidth: .infinity, minHeight: 57, alignment: .topLeading)
                            .background(Color.surfacePrimary)
                            .cornerRadius(CornerRadius.medium.value)
                            
                            Button("完成") {
                                inputDone = true
                            }
                            .padding(.horizontal, ViewSpacing.medium)
                            .padding(.vertical, ViewSpacing.small)
                            .frame(width: 114, height: 44)
                            .background(Color.surfacePrimary)
                            .disabled(userInput.isEmpty)
                            .cornerRadius(CornerRadius.full.value)
                            .foregroundColor(Color(red: 0, green: 0.6, blue: 0.8))
                            .font(Font.typography(.bodyMedium))
                            .kerning(0.64)
                            .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.horizontal, 2*ViewSpacing.xlarge)
                    .padding(.bottom,ViewSpacing.xsmall+ViewSpacing.large)
                    
                    if inputDone {
                        if !praiseDone {
                            TypewriterText(fullText: praiseText) {
                                praiseDone = true
                            }
                            .font(.typography(.bodyMedium))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.grey500)
                            .padding(.horizontal, 2*ViewSpacing.xlarge)
                        } else {
                            Text(praiseText)
                                .font(.typography(.bodyMedium))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.grey500)
                                .padding(.horizontal, 2*ViewSpacing.xlarge)
                        }
                    }
                    
                    Spacer()
                    
                    if praiseDone, let option = question.options.first {
                        Button("我会试试的") {
                            onSelect(option)
                        }
                        .padding(.horizontal, ViewSpacing.medium)
                        .padding(.vertical, ViewSpacing.small)
                        .frame(width: 114, height: 44)
                        .background(Color.surfacePrimary)
                        .disabled(userInput.isEmpty)
                        .cornerRadius(CornerRadius.full.value)
                        .foregroundColor(Color(red: 0, green: 0.6, blue: 0.8))
                        .font(Font.typography(.bodyMedium))
                        .kerning(0.64)
                        .multilineTextAlignment(.center)
                    }
                    Spacer()
                }
            }
            .ignoresSafeArea(edges: .all)
        }
    }
}

#Preview {
    AngryQuestionStyleGView(
        question: MoodTreatmentQuestion(
            id: 4,
            totalQuestions: 45,
            uiStyle: .styleG,
            texts: ["看来你已经整理好心中各个方案的排序了，可以给我展示看看你想尝试的一种吗？"],
            animation: nil,
            options: [
                .init(key: "A",text: "完成", next: 5, exclusive: true)
            ],
            introTexts: nil,
            showSlider: nil,
            endingStyle: nil,
            routine: "anger"
        ),
        onSelect: { _ in }
    )
}
