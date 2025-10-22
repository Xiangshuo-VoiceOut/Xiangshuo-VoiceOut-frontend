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
    @State private var currentStep = 0 // 0: 显示主文本, 1: 显示便签选择
    @State private var selectedNotes: Set<Int> = [] // 选中的便签
    @State private var visibleNotesCount = 1 // 当前可见的便签数量
    @State private var showAddButton = true // 是否显示添加按钮
    @State private var showNoteEditor = false // 是否显示便签编辑器
    @State private var editingNoteIndex = 0 // 正在编辑的便签索引
    @State private var noteTexts: [String] = ["存下500元", "", "", "", "", ""] // 便签文本
    @State private var isFirstContinue = true // 是否是第一次点击继续
    @FocusState private var isTextFieldFocused: Bool // TextField焦点状态
    
    private let animationDelay: TimeInterval = 2.0
    
    var body: some View {
        GeometryReader { proxy in
            let _ = proxy.safeAreaInsets.top
            
            ZStack(alignment: .topLeading) {
                backgroundView
                musicButton
                mainContent
                
                // 便签编辑器覆盖层
                if showNoteEditor {
                    noteEditorOverlay
                }
            }
            .ignoresSafeArea(edges: .all)
            .onAppear {
                startAnimation()
            }
        }
    }
    
    private var backgroundView: some View {
        Color(red: 0.95, green: 0.98, blue: 0.96) // 浅绿色背景，参照图片
            .ignoresSafeArea(edges: .all)
    }
    
    private var musicButton: some View {
        Button { } label: {
            Image("music")
                .resizable()
                .frame(width: 48, height: 48)
        }
        .padding(.leading, ViewSpacing.medium)
    }
    
    
    private var mainContent: some View {
        VStack(spacing: ViewSpacing.xlarge) {
            // 云朵图片
            cloudImage
            
            // 题目题干
            questionText
            
            // 第二阶段：便签选择
            if currentStep == 1 {
                stickyNotesGrid
            }
            
            // 点击屏幕继续（只在第一阶段显示）
            if showContinueText && currentStep == 0 {
                continueText
                    .transition(.opacity)
            }
            
            Spacer() // 只保留底部Spacer，让内容靠上
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, ViewSpacing.large)
        .padding(.top, ViewSpacing.large)
    }
    
    private var cloudImage: some View {
        Image("noteswind-f")
            .resizable()
            .scaledToFit()
            .frame(width: 168, height: 120)
            .padding(.vertical, 15.569)
            .padding(.horizontal, 0.842)
    }
    
    private var questionText: some View {
        VStack(spacing: ViewSpacing.small) {
            // 第一阶段：显示主文本（三行）
            if currentStep == 0 {
                if let texts = question.texts {
                    ForEach(texts.indices, id: \.self) { index in
                        Text(texts[index])
                            .font(.body)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                            .transition(.opacity)
                    }
                }
            }
            
            // 第二阶段：显示原题目 + introText
            if currentStep == 1 {
                // 保留原题目
                if let texts = question.texts {
                    ForEach(texts.indices, id: \.self) { index in
                        Text(texts[index])
                            .font(.body)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                            .transition(.opacity)
                    }
                }
                
                // 添加introText
                if showIntroText, let introTexts = question.introTexts {
                    ForEach(introTexts.indices, id: \.self) { index in
                        Text(introTexts[index])
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color(red: 0.404, green: 0.722, blue: 0.6)) // #67B899
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                            .transition(.opacity)
                    }
                }
            }
        }
    }
    
    private var stickyNotesGrid: some View {
        VStack {
            // 显示可见的便签
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
                ForEach(0..<visibleNotesCount, id: \.self) { index in
                    stickyNoteCard(
                        text: noteTexts[index],
                        imageName: "sadnote-\(index + 1)",
                        isSelected: selectedNotes.contains(index)
                    ) {
                        // 便签点击逻辑
                    }
                }
            }
            .padding(.horizontal, ViewSpacing.medium)
            
            Spacer() // 推到底部
            
            // 添加按钮区域 - 贴住屏幕下方
            if showAddButton {
                addNoteButtonArea
            }
        }
    }
    
    private var addNoteButtonArea: some View {
        VStack(spacing: 8) {
            if isFirstContinue {
                // 第一次：继续按钮
                Button {
                    handleFirstContinue()
                } label: {
                    Text("继续")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color(red: 0.404, green: 0.722, blue: 0.6))
                        .padding(.horizontal, 40)
                        .padding(.vertical, 12)
                        .background(Color.white)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(red: 0.404, green: 0.722, blue: 0.6), lineWidth: 2)
                        )
                }
            } else {
                // 后续：添加便签按钮
                VStack(spacing: 4) {
                    // 只有未完成时才显示提示文字
                    if visibleNotesCount < 6 {
                        Text("试试点击添加便利贴")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Button {
                        if visibleNotesCount >= 6 {
                            // 全部完成，进入下一题
                            onContinue()
                        } else {
                            addNewNote()
                        }
                    } label: {
                        Text(visibleNotesCount >= 6 ? "完成" : "添加便利贴")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color(red: 0.404, green: 0.722, blue: 0.6))
                            .padding(.horizontal, 40)
                            .padding(.vertical, 12)
                            .background(Color.white)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color(red: 0.404, green: 0.722, blue: 0.6), lineWidth: 2)
                            )
                    }
                    
                    if visibleNotesCount < 6 {
                        Text("剩余\(6 - visibleNotesCount)张")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding(.bottom, 20)
    }
    
    private var noteEditorOverlay: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    closeNoteEditor()
                }
            
            VStack {
                // 完成按钮 - 右上角
                HStack {
                    Spacer()
                    Button("完成") {
                        completeNoteEditing()
                    }
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(red: 0.404, green: 0.722, blue: 0.6))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(Color.white)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(red: 0.404, green: 0.722, blue: 0.6), lineWidth: 2)
                    )
                    .padding(.top, 20)
                    .padding(.trailing, 20)
                }
                
                Spacer()
                
                // 便签编辑器 - 让用户感觉真的在便签上写字
                ZStack {
                    Image("sadnote-\(editingNoteIndex + 1)")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 245, height: 257)
                        .aspectRatio(245/257, contentMode: .fit)
                    
                    // 输入区域精确定位在便签图片的写字区域
                    VStack {
                        Spacer()
                            .frame(height: 260) // 再往下80px
                        
                        HStack {
                            Spacer()
                                .frame(width: 20) // 往左40px (30+40=70)
                            
                            ZStack {
                                TextField("", text: Binding(
                                    get: { noteTexts[editingNoteIndex] },
                                    set: { noteTexts[editingNoteIndex] = $0 }
                                ), axis: .vertical) // 支持多行输入
                                .font(.custom("Abel", size: 12))
                                .foregroundColor(Color.black) // #000
                                .fontWeight(.regular) // 400
                                .kerning(0.36)
                                .textCase(.uppercase)
                                .multilineTextAlignment(.center)
                                .textFieldStyle(PlainTextFieldStyle())
                                .background(Color.clear)
                                .frame(maxWidth: 150, maxHeight: 100, alignment: .top)
                                .lineLimit(2) // 限制最多1行
                                .focused($isTextFieldFocused)
                                .onAppear {
                                    // 编辑器出现时自动获得焦点
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        isTextFieldFocused = true
                                    }
                                }
                                
                                // "请填写"提示 - 覆盖在TextField上，用户输入时消失
                                if noteTexts[editingNoteIndex].isEmpty {
                                    Text("请填写")
                                        .font(.custom("Abel", size: 12))
                                        .foregroundColor(Color.black) // #000
                                        .fontWeight(.regular) // 400
                                        .kerning(0.36)
                                        .textCase(.uppercase)
                                        .multilineTextAlignment(.center)
                                        .frame(maxWidth: 150, maxHeight: 100, alignment: .top)
                                        .background(Color.clear)
                                        .allowsHitTesting(false) // 不拦截点击事件
                                }
                            }
                            
                            Spacer()
                                .frame(width: 30) // 右边距，避开便签边缘
                        }
                        
                        Spacer()
                    }
                }
                
                Spacer()
            }
        }
    }
    
    private func stickyNoteCard(text: String, imageName: String, isSelected: Bool, onTap: @escaping () -> Void) -> some View {
        Button(action: onTap) {
            ZStack {
                // 使用assets中的便签图片
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 100)
                
                // 文字叠加在便签上
                Text(text)
                    .font(.custom("Abel", size: 12)) // 使用与编辑器相同的字体大小
                    .foregroundColor(Color.black) // #000
                    .fontWeight(.regular) // 400
                    .kerning(0.36)
                    .textCase(.uppercase)
                    .multilineTextAlignment(.center)
                    .lineLimit(3) // 允许2行显示
                    .frame(maxWidth: 80) // 恢复合适的宽度
                    .padding(.horizontal, 4)
                    .padding(.vertical, 8)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
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
        // 延迟显示"点击屏幕继续"
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDelay) {
            withAnimation(.easeInOut(duration: 0.5)) {
                showContinueText = true
            }
        }
    }
    
    private func handleContinueTap() {
        if currentStep == 0 {
            // 第一阶段：进入第二阶段
            currentStep = 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showIntroText = true
                }
            }
        } else {
            // 第二阶段：进入下一题
            onContinue()
        }
    }
    
    private func addNewNote() {
        editingNoteIndex = visibleNotesCount
        showNoteEditor = true
    }
    
    private func closeNoteEditor() {
        showNoteEditor = false
    }
    
    private func completeNoteEditing() {
        if !noteTexts[editingNoteIndex].isEmpty {
            visibleNotesCount += 1
        }
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
            type: .fillInBlank,
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
