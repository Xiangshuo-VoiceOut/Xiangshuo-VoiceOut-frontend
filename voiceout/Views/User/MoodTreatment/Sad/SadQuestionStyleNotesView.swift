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
    @State private var visibleNotesCount = 1 // 当前可见的便签数量（包括添加按钮）
    @State private var showAddButton = true // 是否显示添加按钮
    @State private var showNoteEditor = false // 是否显示便签编辑器
    @State private var editingNoteIndex = 0 // 正在编辑的便签索引
    @State private var noteTexts: [String] = ["", "", "", "", "", ""] // 便签文本（第一个为空，用于显示添加按钮）
    @State private var editingText = "" // 编辑中的临时文本
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
                // 直接显示所有文本和introtext，不需要点击
                // 同时显示whitenote和继续按钮
                showIntroText = true
                currentStep = 1 // 显示便签选择区域（包含whitenote）
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
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                // 可滚动的内容区域
                ScrollView {
                    VStack(spacing: 0) {
                        // 云朵图片
                        cloudImage
                        
                        // 题目题干
                        questionText
                        
                        // introtext和whitenote之间：44px
                        Color.clear
                            .frame(height: 44)
                        
                        // 便签选择（始终显示，包含whitenote）
                        if currentStep == 1 {
                            stickyNotesGrid
                            
                            // 底部额外空间，为固定的继续按钮留出位置
                            Color.clear
                            .frame(height: 100)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, ViewSpacing.large)
                    .padding(.top, ViewSpacing.large)
                }
                
                // 固定在底部的继续按钮
                if currentStep == 1 {
                    VStack {
                        Spacer()
                        addNoteButtonArea
                            .padding(.bottom, 60) // 距离屏幕底部60px，往上移动
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
            .padding(.vertical, 15.569)
            .padding(.horizontal, 0.842)
    }
    
    private var questionText: some View {
        VStack(spacing: ViewSpacing.small) {
            // 显示text
            if let texts = question.texts {
                Text(texts.joined(separator: "\n"))
                    .font(Font.custom("Alibaba PuHuiTi 3.0", size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.29, green: 0.27, blue: 0.31)) // colorGrey500
                    .frame(width: 358, alignment: .top)
                    .fixedSize(horizontal: false, vertical: true) // 允许文本换行，不被截断
            }
            
            // 显示introText
            if let introTexts = question.introTexts, !introTexts.isEmpty {
                Text(introTexts.joined(separator: "\n"))
                    .font(Font.custom("Alibaba PuHuiTi 3.0", size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.4, green: 0.72, blue: 0.6)) // textTextBrand
                    .frame(width: 358, alignment: .top)
                    .fixedSize(horizontal: false, vertical: true) // 允许文本换行
            }
        }
    }
    
    private var stickyNotesGrid: some View {
        // 显示可见的便签
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
            // 先显示所有已填写的便签
            ForEach(0..<6, id: \.self) { index in
                if !noteTexts[index].isEmpty {
                    stickyNoteCard(
                        text: noteTexts[index],
                        imageName: "sadnote-2",
                        isSelected: selectedNotes.contains(index)
                    ) {
                        // 点击便签，重新打开编辑器进行修改
                        editingNoteIndex = index
                        editingText = noteTexts[index] // 加载已有文本
                        showNoteEditor = true
                    }
                }
            }
            
            // 显示whitenote：初始状态在第一个位置，添加第一个note后移到末尾
            let filledCount = noteTexts.filter { !$0.isEmpty }.count
            if filledCount < 6 {
                // 找到第一个空位作为编辑索引
                if let firstEmptyIndex = noteTexts.firstIndex(where: { $0.isEmpty }) {
                    Button(action: {
                        editingNoteIndex = firstEmptyIndex
                        editingText = noteTexts[firstEmptyIndex] // 加载已有文本（如果有）
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
        VStack(spacing: 8) {
            // 检查是否有任何note输入
            let hasAnyNote = noteTexts.contains { !$0.isEmpty }
            
            // 继续按钮 - 直接进入下一题
            // 0个便利贴时灰色禁用，>=1个时可以点击
            Button {
                onContinue() // 直接进入下一题
            } label: {
                Text("继续")
            }
            .disabled(!hasAnyNote) // 没有任何note时禁用
            .padding(.horizontal, ViewSpacing.medium)
            .padding(.vertical, ViewSpacing.small)
            .frame(width: 114, height: 44)
            .background(Color.surfacePrimary) // 白底
            .cornerRadius(CornerRadius.full.value)
            .foregroundColor(hasAnyNote ? Color(red: 0x67/255.0, green: 0xB8/255.0, blue: 0x99/255.0) : Color.gray) // 有note时绿色，无note时灰色
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
                    closeNoteEditor()
                }
            
            VStack(spacing: 0) {
                Spacer()
                
                // note和完成按钮的容器
                VStack(spacing: 0) {
                    // 便签编辑器 - 让用户感觉真的在便签上写字
                    ZStack(alignment: .topLeading) {
                        Image("sadnote-2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 245, height: 257)
                            .aspectRatio(245/257, contentMode: .fit)
                        
                        // 输入区域 - 缩小一倍，向右下移动，支持多行换行
                        ZStack(alignment: .topLeading) {
                            // 使用TextEditor支持多行输入，类似填空题
                            TextEditor(text: $editingText)
                                .font(Font.custom("Abel", size: 12))
                                .kerning(0.36)
                                .foregroundColor(Color(red: 0.29, green: 0.27, blue: 0.31)) // textTextPrimary
                                .scrollContentBackground(.hidden) // 隐藏TextEditor的默认背景
                                .background(Color.clear)
                                .frame(width: 122.5, height: 128.5, alignment: .topLeading) // 缩小一倍：245/2 = 122.5, 257/2 = 128.5
                                .padding(.top, 10) // 从note顶部开始，留出一些边距（缩小一倍）
                                .padding(.leading, 10) // 从note左侧开始（缩小一倍）
                                .padding(.trailing, 10)
                                .padding(.bottom, 10)
                                .focused($isTextFieldFocused)
                                .offset(x: 50, y: 50) // 向右下移动
                                .onAppear {
                                    // 编辑器出现时自动获得焦点
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        isTextFieldFocused = true
                                    }
                                }
                            
                            // "请填写"占位符 - 放在外层ZStack中，不受TextEditor frame限制
                            if editingText.isEmpty {
                                Text(" 请填写")
                                    .font(Font.custom("Abel", size: 12))
                                    .kerning(0.36)
                                    .foregroundColor(Color(red: 0.79, green: 0.77, blue: 0.82)) // textTextLight，灰色
                                    .allowsHitTesting(false)
                                    .padding(.top, 10 + 8) // TextEditor外部padding(10) + 内部默认padding(8)
                                    .padding(.leading, 10 + 5) // TextEditor外部padding(10) + 内部默认padding(5)
                                    .offset(x: 50 + 50, y: 50 + 50) // TextEditor的offset(50,50) + 额外向右下移动(50,50)
                            }
                        }
                    }
                    
                    // 完成按钮 - 在note下方居中，向上移动100px
                    Button {
                        completeNoteEditing()
                    } label: {
                        Text("完成")
                    }
                    .disabled(editingText.isEmpty) // 空文本时禁用完成按钮
                    .padding(.horizontal, 24) // spacingSpacingMd
                    .padding(.vertical, 8) // spacingSpacingSm
                    .frame(width: 139, height: 44, alignment: .center)
                    .background(Color(red: 0.4, green: 0.72, blue: 0.6)) // colorBrandBrandPrimary
                    .cornerRadius(360) // radiusRadiusFull
                    .shadow(color: Color(red: 0.35, green: 0.46, blue: 0.65).opacity(0.04), radius: 10, x: 2, y: 12)
                    .foregroundColor(.white)
                    .font(Font.typography(.bodyMedium))
                    .offset(y: 4) // 向下移动一个身位（44px），从-40变为4
                }
                
                Spacer()
            }
        }
    }
    
    // 添加便利贴按钮卡片
    private var addNoteCard: some View {
        ZStack {
            // 使用asset中的whitenote图片
            Image("whitenote")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 100)
            
            // 绿色文字"添加便利贴"
            Text("添加便利贴")
                .font(Font.custom("Alibaba PuHuiTi 3.0", size: 14))
                .foregroundColor(Color(red: 0.4, green: 0.72, blue: 0.6)) // textTextBrand
                .multilineTextAlignment(.center)
        }
    }
    
    private func stickyNoteCard(text: String, imageName: String, isSelected: Bool, onTap: @escaping () -> Void) -> some View {
        Button(action: onTap) {
            ZStack(alignment: .topLeading) {
                // 使用assets中的便签图片
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 100)
                
                // 文字叠加在便签上
                Text(text)
                    .font(Font.custom("Abel", size: 12))
                    .kerning(0.36)
                    .foregroundColor(Color(red: 0.29, green: 0.27, blue: 0.31)) // textTextPrimary
                    .frame(width: 60, alignment: .topLeading)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil) // 允许多行显示
                    .fixedSize(horizontal: false, vertical: true) // 允许垂直方向扩展
                    .padding(.horizontal, 4)
                    .padding(.vertical, 8)
                    .offset(x: 30, y: 16) // 向右下移动，让文字更靠右（向右20px，向下8px）
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
        if let firstEmptyIndex = noteTexts.firstIndex(where: { $0.isEmpty }) {
            editingNoteIndex = firstEmptyIndex
            editingText = "" // 重置编辑文本
            showNoteEditor = true
        }
    }
    
    private func closeNoteEditor() {
        editingText = "" // 关闭时清空编辑文本
        showNoteEditor = false
    }
    
    private func completeNoteEditing() {
        // 只有在点击完成按钮后，才将编辑中的文本保存到noteTexts
        if !editingText.isEmpty {
            noteTexts[editingNoteIndex] = editingText
            // 计算已填写的便签数量，并确保visibleNotesCount至少包含下一个空位
            let filledCount = noteTexts.filter { !$0.isEmpty }.count
            // 如果还有空位，visibleNotesCount应该是已填写数量+1（包含添加按钮）
            if filledCount < 6 {
                visibleNotesCount = filledCount + 1
            } else {
                visibleNotesCount = 6
            }
        }
        editingText = "" // 清空编辑文本
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
