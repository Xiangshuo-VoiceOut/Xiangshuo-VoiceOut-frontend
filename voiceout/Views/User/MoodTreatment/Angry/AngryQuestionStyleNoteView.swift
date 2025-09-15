//
//  AngryQuestionStyleNoteView.swift
//  voiceout
//
//  Created by Yujia Yang on 6/10/25.
//

import SwiftUI

struct AngryQuestionStyleNoteView: View {
    let question: MoodTreatmentQuestion
    let onSelect: (MoodTreatmentAnswerOption) -> Void
    
    @State private var isPlayingMusic     = true
    @State private var selectedShapeIndex : Int? = nil
    @State private var draftText          = ""
    @State private var showEditor         = false
    
    @State private var playAnimation      = false
    @State private var showDraftText      = true
    @State private var showCompletion     = false
    
    private let animationDuration: TimeInterval = 4.0
    
    private var completionOption: MoodTreatmentAnswerOption? {
        if let opt = question.options.first(where: { ($0.exclusive ?? false) == true }) {
            return opt
        }

        if let fallbackNext = question.options.first?.next {
            return MoodTreatmentAnswerOption(
                key: "DONE",
                text: "我完成了",
                next: fallbackNext,
                exclusive: true
            )
        }
        return nil
    }
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .topLeading) {
                Color.surfaceBrandTertiaryGreen
                    .ignoresSafeArea()
                
                ZStack(alignment: .topLeading) {
                    HStack {
                        Spacer()
                        Image("cloud-chat")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 168)
                            .padding(.bottom, ViewSpacing.large)
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
                .zIndex(10)
                
                if selectedShapeIndex == nil {
                    VStack(spacing: 0) {
                        Spacer()
                            .frame(height: 140)
                        
                        if let lines = question.texts {
                            VStack(spacing: ViewSpacing.medium) {
                                ForEach(lines, id: \.self) { line in
                                    Text(line)
                                        .font(.typography(.bodyMedium))
                                        .foregroundColor(.grey500)
                                        .multilineTextAlignment(.leading)
                                        .padding(.horizontal, 2*ViewSpacing.xlarge)
                                }
                            }
                            .padding(.bottom, ViewSpacing.xsmall+ViewSpacing.xlarge)
                        }
                        
                        let columns = Array(repeating: GridItem(.flexible(), spacing: ViewSpacing.medium), count: 3)
                        let noteAssets = (1...6).map { "note-\($0)" }
                        LazyVGrid(columns: columns, spacing: ViewSpacing.medium) {
                            ForEach(noteAssets.indices, id: \.self) { idx in
                                Button {
                                    selectedShapeIndex = idx
                                    draftText = ""
                                    showEditor = true
                                } label: {
                                    Image(noteAssets[idx])
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                }
                            }
                        }
                        .padding(.horizontal, ViewSpacing.medium+ViewSpacing.large)
                        Spacer()
                    }
                    .ignoresSafeArea(edges: .bottom)
                    
                } else if !showCompletion {
                    VStack{
                        if !playAnimation {
                            Text("现在试试点击屏幕吧！")
                                .font(.typography(.bodyMedium))
                                .foregroundColor(.grey500)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                                .padding(.bottom, ViewSpacing.large)
                        }
                    }
                    .padding(.top,ViewSpacing.xsmall+ViewSpacing.xlarge+ViewSpacing.xxxxlarge)
                    
                    ZStack {
                        LottieView(
                            animationName: "bubble-breaking",
                            loopMode: .playOnce,
                            autoPlay: playAnimation,
                            onFinished: {
                                withAnimation {
                                    showCompletion = true
                                }
                            },
                            speed: 0.06
                        )
                        .id(playAnimation)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            guard !playAnimation else { return }
                            playAnimation = true
                            showDraftText = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration / 2) {
                                withAnimation { showDraftText = false }
                            }
                        }
                        
                        if showDraftText {
                            Text(draftText)
                                .font(.typography(.bodyMedium))
                                .foregroundColor(.textPrimary)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        }
                    }
                    .ignoresSafeArea(edges: .all)
                } else {
                    VStack(spacing: ViewSpacing.medium) {
                        Text("水泡解压完成!")
                            .font(.typography(.bodyMedium))
                            .foregroundColor(.grey500)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .padding(.top,ViewSpacing.large)
                        
                        if let opt = completionOption {
                            Button {
                                onSelect(opt)
                            } label: {
                                Text(opt.text.isEmpty ? "我完成了" : opt.text)
                                    .font(.typography(.bodyMedium))
                                    .foregroundColor(.textBrandPrimary)
                                    .padding(.horizontal, ViewSpacing.medium)
                                    .padding(.vertical, ViewSpacing.small)
                                    .frame(height: 44)
                                    .background(Color.surfacePrimary)
                                    .cornerRadius(CornerRadius.full.value)
                            }
                            .padding(.top, ViewSpacing.small)
                        }
                    }
                    .padding(.top, ViewSpacing.xlarge+ViewSpacing.xxxlarge)
                    .zIndex(5)
                }
            }
            .ignoresSafeArea(edges: .all)
            .overlay(alignment: .bottom) {
                Image("bucket")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .allowsHitTesting(false)
                    .opacity(selectedShapeIndex != nil ? 1 : 0)
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .fullScreenCover(isPresented: $showEditor) {
            NoteEditorView(
                text: $draftText,
                onDone: {
                    showEditor      = false
                    playAnimation   = false
                    showCompletion  = false
                },
                onCancel: {
                    showEditor         = false
                    selectedShapeIndex = nil
                }
            )
        }
    }
}

private struct NoteEditorView: View {
    @Binding var text: String
    var onDone:   () -> Void
    var onCancel: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    private let placeholder = "把这件令人生气的事情写下来吧~"
    
    var body: some View {
        ZStack {
            Color.surfaceBrandTertiaryGreen.ignoresSafeArea()
            VStack(spacing: 0) {
                StickyHeaderView(
                    title: "心情便签",
                    leadingComponent: AnyView(
                        Button {
                            onCancel()
                            dismiss()
                        } label: {
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
                                onDone()
                                dismiss()
                            },
                            variant: .solid,
                            theme: .action,
                            spacing: .xsmall,
                            fontSize: .small,
                            borderRadius: .full
                        )
                        .fixedSize()
                        .padding(.trailing, ViewSpacing.xlarge)
                    ),
                    backgroundColor: .clear
                )
                .frame(height: 44)
                
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $text)
                        .font(.typography(.bodyMedium))
                        .foregroundColor(.textPrimary)
                        .scrollContentBackground(.hidden)
                    if text.isEmpty {
                        Text(placeholder)
                            .font(.typography(.bodyMedium))
                            .foregroundColor(.grey200)
                            .padding(.top, ViewSpacing.small)
                    }
                }
                .padding(.top, ViewSpacing.small)
                .padding(.leading, 3*ViewSpacing.betweenSmallAndBase)
            }
        }
    }
}

#Preview {
    AngryQuestionStyleNoteView(
        question: MoodTreatmentQuestion(
            id: 123,
            totalQuestions: 45,
            type: .custom,
            uiStyle: .styleNote,
            texts: ["接下来，挑一个你喜欢的便签，把这件令人生气的事情写下来吧~"],
            animation: "bubble-breaking",
            options: [
                .init(key: "A", text: "我完成了", next: 124, exclusive: true)
            ],
            introTexts: nil,
            showSlider: false,
            endingStyle: nil,
            customViewName: nil,
            routine: "anger"
        ),
        onSelect: { _ in }
    )
}
