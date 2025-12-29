//
//  SadQuestionStyleNotesView.swift
//  voiceout
//
//  Created by Ziyang Ye on 9/16/25.
//

import SwiftUI

struct SadQuestionStyleNotesView: View {
    let question: MoodTreatmentQuestion
    let onContinue: () -> Void
    
    @State private var showContinueText = false
    @State private var showIntroText = false
    @State private var currentStep = 0
    @State private var selectedNotes: Set<Int> = []
    @State private var visibleNotesCount = 1
    @State private var showAddButton = true
    @State private var showNoteEditor = false
    @State private var editingNoteIndex = 0
    @State private var noteTexts: [String] = ["", "", "", "", "", ""]
    @State private var editingText = ""
    @State private var isFirstContinue = true
    @FocusState private var isTextFieldFocused: Bool
    
    private let animationDelay: TimeInterval = 2.0
    
    var body: some View {
        GeometryReader { proxy in
            let _ = proxy.safeAreaInsets.top
            
            ZStack(alignment: .topLeading) {
                backgroundView
//                musicButton
                mainContent
                
                if showNoteEditor {
                    noteEditorOverlay
                }
            }
            .ignoresSafeArea(edges: .all)
            .onAppear {
                showIntroText = true
                currentStep = 1
            }
        }
    }
    
    private var backgroundView: some View {
        Color.surfaceBrandTertiaryGreen
            .ignoresSafeArea(edges: .all)
    }
    
//    private var musicButton: some View {
//        Button { } label: {
//            Image("music")
//                .resizable()
//                .frame(width: 48, height: 48)
//        }
//        .padding(.leading, ViewSpacing.medium)
//    }
    
    
    private var mainContent: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(spacing: 0) {
                        cloudImage
                        
                        questionText
                        
                        Color.clear
                            .frame(height: 44)
                        
                        if currentStep == 1 {
                            stickyNotesGrid
                            
                            Color.clear
                            .frame(height: 100)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, ViewSpacing.large)
                    .padding(.top, ViewSpacing.large)
                }
                
                if currentStep == 1 {
                    VStack {
                        Spacer()
                        addNoteButtonArea
                            .padding(.bottom, ViewSpacing.xlarge+ViewSpacing.large+ViewSpacing.xsmall)
                    }
                }
            }
        }
    }
    
    private var cloudImage: some View {
        Image("noteswind-f")
            .resizable()
            .scaledToFit()
            .frame(width: 168, height: 120)
            .padding(.vertical, ViewSpacing.medium)
            .padding(.horizontal, ViewSpacing.xxxsmall)
    }
    
    private var questionText: some View {
        VStack(spacing: ViewSpacing.small) {
            if let texts = question.texts {
                Text(texts.joined(separator: "\n"))
                    .font(Font.typography(.bodyMedium))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.textPrimary)
                    .frame(width: 358, alignment: .top)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            if let introTexts = question.introTexts, !introTexts.isEmpty {
                Text(introTexts.joined(separator: "\n"))
                    .font(Font.typography(.bodyMedium))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.textBrandPrimary)
                    .frame(width: 358, alignment: .top)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
    
    private var stickyNotesGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: ViewSpacing.medium) {
            ForEach(0..<6, id: \.self) { index in
                if !noteTexts[index].isEmpty {
                    stickyNoteCard(
                        text: noteTexts[index],
                        imageName: "sadnote-2",
                        isSelected: selectedNotes.contains(index)
                    ) {
                        editingNoteIndex = index
                        editingText = noteTexts[index]
                        showNoteEditor = true
                    }
                }
            }
            
            let filledCount = noteTexts.filter { !$0.isEmpty }.count
            if filledCount < 6 {
                if let firstEmptyIndex = noteTexts.firstIndex(where: { $0.isEmpty }) {
                    Button(action: {
                        editingNoteIndex = firstEmptyIndex
                        editingText = noteTexts[firstEmptyIndex]
                        showNoteEditor = true
                    }) {
                        addNoteCard
                    }
                }
            }
        }
        .padding(.horizontal, ViewSpacing.medium)
    }
    
    private var addNoteButtonArea: some View {
        VStack(spacing: ViewSpacing.small) {
            let hasAnyNote = noteTexts.contains { !$0.isEmpty }
            
            Button {
                onContinue()
            } label: {
                Text("继续")
            }
            .disabled(!hasAnyNote)
            .padding(.horizontal, ViewSpacing.medium)
            .padding(.vertical, ViewSpacing.small)
            .frame(width: 114, height: 44)
            .background(Color.surfacePrimary)
            .cornerRadius(CornerRadius.full.value)
            .foregroundColor(hasAnyNote ? Color.textBrandPrimary : Color.textLight)
            .font(Font.typography(.bodyMedium))
            .kerning(0.64)
            .multilineTextAlignment(.center)
        }
    }
    
    private var noteEditorOverlay: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    // 如果键盘显示中，先收起键盘
                    if isTextFieldFocused {
                        isTextFieldFocused = false
                    } else {
                        // 键盘已收起，关闭编辑器
                        closeNoteEditor()
                    }
                }
            
            VStack(spacing: 0) {
                Spacer()
                
                VStack(spacing: 0) {
                    ZStack(alignment: .topLeading) {
                        Image("sadnote-2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 245, height: 257)
                            .aspectRatio(245/257, contentMode: .fit)
                        
                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $editingText)
                                .font(Font.typography(.bodyXSmall))
                                .kerning(0.36)
                                .foregroundColor(.textPrimary)
                                .scrollContentBackground(.hidden)
                                .background(Color.clear)
                                .frame(width: 122.5, height: 128.5, alignment: .topLeading)
                                .padding(ViewSpacing.betweenSmallAndBase)
                                .focused($isTextFieldFocused)
                                .offset(x: 5*ViewSpacing.betweenSmallAndBase, y: 5*ViewSpacing.betweenSmallAndBase)
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        isTextFieldFocused = true
                                    }
                                }
                            
                            if editingText.isEmpty {
                                Text(" 请填写")
                                    .font(Font.typography(.bodyXSmall))
                                    .kerning(0.36)
                                    .foregroundColor(.textLight)
                                    .allowsHitTesting(false)
                                    .padding(.top, ViewSpacing.small+ViewSpacing.betweenSmallAndBase)
                                    .padding(.leading, ViewSpacing.base+ViewSpacing.xxxsmall+ViewSpacing.xxsmall)
                                    .offset(x: 10*ViewSpacing.betweenSmallAndBase, y: 10*ViewSpacing.betweenSmallAndBase)
                            }
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        // 点击便签区域：如果键盘收起则弹出，如果已显示则保持编辑状态
                        if !isTextFieldFocused {
                            isTextFieldFocused = true
                        }
                    }
                    
                    Button {
                        isTextFieldFocused = false
                        completeNoteEditing()
                    } label: {
                        Text("完成")
                    }
                    .disabled(editingText.isEmpty)
                    .padding(.horizontal, ViewSpacing.large)
                    .padding(.vertical, ViewSpacing.small)
                    .frame(width: 139, height: 44, alignment: .center)
                    .background(Color.surfaceBrandPrimary)
                    .cornerRadius(CornerRadius.full.value)
                    .shadow(color: Color(red: 0.35, green: 0.46, blue: 0.65).opacity(0.04), radius: 10, x: 2, y: 12)
                    .foregroundColor(.white)
                    .font(Font.typography(.bodyMedium))
                    .offset(y: ViewSpacing.xsmall)
                    .allowsHitTesting(true)
                }
                .background(Color.clear)
                .allowsHitTesting(true)
                
                Spacer()
            }
        }
    }
    
    private var addNoteCard: some View {
        ZStack {
            Image("whitenote")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 100)
            
            Text("添加便利贴")
                .font(Font.typography(.bodySmall))
                .foregroundColor(.textBrandPrimary)
                .multilineTextAlignment(.center)
        }
    }
    
    private func stickyNoteCard(text: String, imageName: String, isSelected: Bool, onTap: @escaping () -> Void) -> some View {
        Button(action: onTap) {
            ZStack(alignment: .topLeading) {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 100)
                
                Text(text)
                    .font(Font.typography(.bodyXSmall))
                    .kerning(0.36)
                    .foregroundColor(.textPrimary)
                    .frame(width: 60, alignment: .topLeading)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, ViewSpacing.xsmall)
                    .padding(.vertical, ViewSpacing.small)
                    .offset(x: ViewSpacing.medium+ViewSpacing.base+ViewSpacing.xxsmall, y: ViewSpacing.medium)
            }
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.small.value)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: StrokeWidth.width200.value)
            )
        }
    }
    
    private func toggleNoteSelection(_ index: Int) {
        if selectedNotes.contains(index) {
            selectedNotes.remove(index)
        } else {
            selectedNotes.insert(index)
        }
    }

    private var continueText: some View {
        Button {
            handleContinueTap()
        } label: {
            Text("(点击屏幕继续)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    private func startAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDelay) {
            withAnimation(.easeInOut(duration: 0.5)) {
                showContinueText = true
            }
        }
    }
    
    private func handleContinueTap() {
        if currentStep == 0 {
            currentStep = 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showIntroText = true
                }
            }
        } else {
            onContinue()
        }
    }
    
    private func addNewNote() {
        if let firstEmptyIndex = noteTexts.firstIndex(where: { $0.isEmpty }) {
            editingNoteIndex = firstEmptyIndex
            editingText = ""
            showNoteEditor = true
        }
    }
    
    private func closeNoteEditor() {
        editingText = ""
        showNoteEditor = false
    }
    
    private func completeNoteEditing() {
        if !editingText.isEmpty {
            noteTexts[editingNoteIndex] = editingText
            let filledCount = noteTexts.filter { !$0.isEmpty }.count
            if filledCount < 6 {
                visibleNotesCount = filledCount + 1
            } else {
                visibleNotesCount = 6
            }
        }
        editingText = ""
        isTextFieldFocused = false  // 确保键盘收起
        showNoteEditor = false
    }
    
    private func handleFirstContinue() {
        isFirstContinue = false
    }
}

#Preview {
    SadQuestionStyleNotesView(
        question: MoodTreatmentQuestion(
            id: 2,
            totalQuestions: 10,
            uiStyle: .styleNotes,
            texts: [
                "和小云朵一起给自己创建一个短期目标吧!",
                "想想最近有什么想要完成的事情嘛,",
                "可以试着把这个当成一个短期目标去努力哦!"
            ],
            animation: nil,
            options: [],
            introTexts: [],
            showSlider: false,
            endingStyle: nil,
            customViewName: nil,
            routine: "sad"
        ),
        onContinue: {}
    )
    .environmentObject(RouterModel())
}
