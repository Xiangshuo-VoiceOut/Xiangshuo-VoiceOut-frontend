//
//  EnvyQuestionStyleScrollDownView.swift
//  voiceout
//
//  Created by Yujia Yang on 6/28/25.
//

import SwiftUI

struct EnvyQuestionStyleScrollDownView: View {
    
    let question: MoodTreatmentQuestion
    let onSelect: (MoodTreatmentAnswerOption) -> Void
    
    @State private var selectedTrigger: DropdownOption?
    @State private var otherText: String = ""
    @State private var isPlayingMusic = true
    @State private var introDone = false
    
    private let triggers: [DropdownOption] = [
        DropdownOption(option: "觉得自己没有被足够肯定或关注"),
        DropdownOption(option: "看到别人取得成就，自己却停滞不前"),
        DropdownOption(option: "近期经历了失败或挫折，对自己失去信心"),
        DropdownOption(option: "发现自己在某个重要关系中被忽视或不被重视"),
        DropdownOption(option: "我不知道是什么原因"),
        DropdownOption(option: "其他")
    ]
    
    private var confirmOption: MoodTreatmentAnswerOption? {
        question.options.first { $0.exclusive == true }
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
                                .padding(.bottom, 24)
                            Spacer()
                        }
                        Button {
                            isPlayingMusic.toggle()
                        } label: {
                            Image(isPlayingMusic ? "music" : "stop-music")
                                .resizable()
                                .frame(width: 48, height: 48)
                        }
                        .padding(.leading, 16)
                    }
                    
                    VStack(spacing: 8) {
                        ForEach(question.texts ?? [], id: \.self) { line in
                            if !introDone {
                                TypewriterText(fullText: line, characterDelay: 0.1) {
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
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 64)
                    .padding(.top, 24)
                    
                    if introDone {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("我最近有些敏感是因为：")
                                .font(.typography(.bodyMedium))
                                .foregroundColor(.textPrimary)
                            
                            Dropdown(
                                selectionOption: $selectedTrigger,
                                label: nil,
                                prefixIcon: nil,
                                placeholder: selectedTrigger?.option ?? "点击选择",
                                options: triggers,
                                backgroundColor: .white,
                                isRequiredField: false,
                                dividerIndex: nil
                            )
                            .frame(maxWidth: .infinity, minHeight: 44, maxHeight: 44)
                            .accentColor(.grey500)
                            
                            if selectedTrigger?.option == "其他" {
                                HStack(spacing: 8) {
                                    Image("edit")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.textLight)
                                    
                                    Rectangle()
                                        .foregroundColor(.clear)
                                        .frame(width: 1, height: 16)
                                        .background(.black)
                                    
                                    TextField("请填写", text: $otherText, onCommit: {
                                        selectedTrigger = DropdownOption(option: otherText)
                                    })
                                    .font(.typography(.bodySmall))
                                    .foregroundColor(.textPrimary)
                                }
                                .padding(16)
                                .background(Color.surfacePrimary)
                                .cornerRadius(16)
                            }
                            
                            if let confirm = confirmOption,
                               selectedTrigger != nil,
                               (selectedTrigger?.option != "其他" || !otherText.isEmpty)
                            {
                                Button {
                                    onSelect(
                                        MoodTreatmentAnswerOption(
                                            text: selectedTrigger!.option,
                                            next: nil,
                                            exclusive: false
                                        )
                                    )
                                    onSelect(confirm)
                                } label: {
                                    Text(confirm.text)
                                        .font(.typography(.bodyMedium))
                                        .foregroundColor(.textBrandPrimary)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .frame(width: 114, height: 44)
                                        .background(Color.surfacePrimary)
                                        .cornerRadius(360)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.top, 24)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 100)
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    EnvyQuestionStyleScrollDownView(
        question: MoodTreatmentQuestion(
            id: 4,
            type: .custom,
            uiStyle: .styleScrollDown,
            texts: ["你觉得自己最近的脆弱和敏感是由哪些事情引发的？"],
            animation: nil,
            options: [
                .init(text: "我选好了", next: 5, exclusive: true)
            ],
            introTexts: nil,
            showSlider: nil,
            endingStyle: nil
        ),
        onSelect: { _ in }
    )
}
