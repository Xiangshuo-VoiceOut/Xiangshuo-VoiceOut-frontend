//
//  AngryQuestionStyleNoteView.swift
//  voiceout
//
//  Created by Yujia Yang on 6/10/25.
//

import SwiftUI

struct AngryQuestionStyleNoteView: View {
    let question: MoodTreatmentQuestion
    
    @State private var isPlayingMusic     = true
    @State private var selectedShapeIndex : Int? = nil
    @State private var draftText          = ""
    @State private var showEditor         = false
    
    @State private var playAnimation      = false
    @State private var showDraftText      = true
    @State private var showCompletion     = false
    
    private let animationDuration: TimeInterval = 4.0
    
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
                .zIndex(10)
                
                if selectedShapeIndex == nil {
                    VStack(spacing: 0) {
                        Spacer()
                            .frame(height: 140)
                        
                        if let lines = question.texts {
                            VStack(spacing: 16) {
                                ForEach(lines, id: \.self) { line in
                                    Text(line)
                                        .font(.typography(.bodyMedium))
                                        .foregroundColor(.grey500)
                                        .multilineTextAlignment(.leading)
                                        .padding(.horizontal, 64)
                                }
                            }
                            .padding(.bottom, 36)
                        }
                        
                        let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 3)
                        let noteAssets = (1...6).map { "note-\($0)" }
                        LazyVGrid(columns: columns, spacing: 16) {
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
                        .padding(.horizontal, 40)
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
                                .padding(.bottom, 24)
                        }
                    }
                    .padding(.top,160)
                    
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
                    VStack(spacing: 16) {
                        Text("水泡解压完成!")
                            .font(.typography(.bodyMedium))
                            .foregroundColor(.grey500)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .padding(.top,24)
                    }
                    .padding(.top, 120)
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
                        .padding(.trailing, 32)
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
                            .padding(.top, 8)
                    }
                }
                .padding(.top, 8)
                .padding(.leading, 30)
            }
        }
    }
}

#Preview {
    AngryQuestionStyleNoteView(
        question: MoodTreatmentQuestion(
            id: 999,
            type: .animationOnly,
            uiStyle: .styleNote,
            texts: ["接下来，挑一个你喜欢的便签，把这件令人生气的事情写下来吧~"],
            animation: "bubble-breaking",
            options: [],
            introTexts: nil,
            showSlider: nil,
            endingStyle: nil
        )
    )
}
