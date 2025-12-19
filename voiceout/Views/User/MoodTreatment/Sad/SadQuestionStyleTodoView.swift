//
//  SadQuestionStyleTodoView.swift
//  voiceout
//
//  Created by Ziyang Ye on 9/22/25.
//

import SwiftUI

struct SadQuestionStyleTodoView: View {
    let question: MoodTreatmentQuestion
    let onContinue: () -> Void
    
    @State private var currentTextIndex = 0
    @State private var isPlayingMusic = false
    @State private var showCurrentText = true
    @State private var currentTodoText = ""
    @State private var selectedTimeframe: String = ""
    @State private var todos: [TodoItem] = []
    @State private var showTodoList = false
    @State private var completedTodos: Set<UUID> = []
    
    @FocusState private var isTextFieldFocused: Bool
    
    private let typingInterval: TimeInterval = 0.1
    
    private let timeframes = ["明天", "后天", "5天内", "1周内", "1个月内", "3个月内"]
    
    struct TodoItem: Identifiable {
        let id = UUID()
        let text: String
        let timeframe: String
        var isCompleted: Bool = false
    }
    
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
        return !currentIntroText.isEmpty
    }
    
    private var isLastText: Bool {
        return currentTextIndex == (question.texts?.count ?? 0) - 1
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
                        
                        Button {
                            isPlayingMusic.toggle()
                        } label: {
                            Image(isPlayingMusic ? "music" : "stop-music")
                                .resizable()
                                .frame(width: 48, height: 48)
                        }
                        .padding(.leading, ViewSpacing.medium)
                    }

                    VStack(spacing: ViewSpacing.large) {
                        if showCurrentText {
                            VStack(spacing: ViewSpacing.small) {
                                TypewriterText(fullText: currentText, characterDelay: typingInterval) {
                                }
                                .id(currentTextIndex)
                            }
                            .font(.typography(.bodyMedium))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.grey500)
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                        
                        if showCurrentText && hasIntroText && !showTodoList {
                            TypewriterText(fullText: currentIntroText, characterDelay: typingInterval) {
                            }
                            .id("intro-\(currentTextIndex)")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(Color(red: 0.404, green: 0.722, blue: 0.6))
                            .multilineTextAlignment(.center)
                            .frame(width: 252, alignment: .center)
                            
                            todoInputArea
                        }
                        
                        if showTodoList {
                            todoListView
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
    
    private var todoInputArea: some View {
        VStack(spacing: ViewSpacing.medium) {
            VStack(spacing: ViewSpacing.small) {
                TextField("输入你的计划", text: $currentTodoText)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.textPrimary)
                    .focused($isTextFieldFocused)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.surfacePrimary)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            }
            
            if !currentTodoText.isEmpty {
                VStack(spacing: ViewSpacing.small) {
                    Text("打算什么时候去？")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: ViewSpacing.small) {
                        ForEach(timeframes, id: \.self) { timeframe in
                            Button {
                                selectedTimeframe = timeframe
                            } label: {
                                Text(timeframe)
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(selectedTimeframe == timeframe ? .white : .textPrimary)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(selectedTimeframe == timeframe ? Color(red: 0.404, green: 0.722, blue: 0.6) : Color.surfacePrimary)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(selectedTimeframe == timeframe ? Color(red: 0.404, green: 0.722, blue: 0.6) : Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                            }
                        }
                    }
                }
            }
            
            if !currentTodoText.isEmpty && !selectedTimeframe.isEmpty {
                Button("我写好了") {
                    let newTodo = TodoItem(text: currentTodoText, timeframe: selectedTimeframe)
                    todos.append(newTodo)
                    currentTodoText = ""
                    selectedTimeframe = ""
                }
                .font(.typography(.bodyMedium))
                .foregroundColor(Color.white)
                .padding(.horizontal, ViewSpacing.large)
                .padding(.vertical, ViewSpacing.small)
                .background(Color(red: 0.404, green: 0.722, blue: 0.6))
                .cornerRadius(CornerRadius.full.value)
                .padding(.top, ViewSpacing.small)
            }
            
            if !todos.isEmpty {
                Button("跳过") {
                    showTodoList = true
                }
                .font(.typography(.bodyMedium))
                .foregroundColor(Color(red: 0.404, green: 0.722, blue: 0.6))
                .padding(.horizontal, ViewSpacing.large)
                .padding(.vertical, ViewSpacing.small)
                .background(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.full.value)
                        .stroke(Color(red: 0.404, green: 0.722, blue: 0.6), lineWidth: 1)
                )
                .padding(.top, ViewSpacing.small)
            }
        }
        .padding(.horizontal, ViewSpacing.medium)
    }
    
    private var todoListView: some View {
        VStack(spacing: ViewSpacing.medium) {
            Text("你的计划清单")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.textPrimary)
                .padding(.bottom, ViewSpacing.small)
            
            ScrollView {
                LazyVStack(spacing: ViewSpacing.small) {
                    ForEach(todos) { todo in
                        let isCompleted = completedTodos.contains(todo.id)
                        Button {
                            if isCompleted {
                                completedTodos.remove(todo.id)
                            } else {
                                completedTodos.insert(todo.id)
                            }
                        } label: {
                            HStack {
                                Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(isCompleted ? Color(red: 0.404, green: 0.722, blue: 0.6) : Color.gray)
                                    .font(.system(size: 20))
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("\(todo.timeframe) - \(todo.text)")
                                        .font(.system(size: 16, weight: .regular))
                                        .foregroundColor(.textPrimary)
                                        .multilineTextAlignment(.leading)
                                        .strikethrough(isCompleted)
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal, ViewSpacing.medium)
                            .padding(.vertical, ViewSpacing.small)
                            .background(Color.surfacePrimary)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(isCompleted ? Color(red: 0.404, green: 0.722, blue: 0.6) : Color.gray.opacity(0.3), lineWidth: 1)
                            )
                        }
                    }
                }
            }
            .frame(maxHeight: 300)
        }
        .padding(.horizontal, ViewSpacing.medium)
    }
    
    private var bottomButtonArea: some View {
        VStack {
            if showTodoList {
                Button("继续") {
                    onContinue()
                }
                .font(.typography(.bodyMedium))
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, ViewSpacing.large)
                .padding(.vertical, ViewSpacing.medium)
                .background(Color(red: 0.404, green: 0.722, blue: 0.6))
                .cornerRadius(CornerRadius.full.value)
                .padding(.horizontal, ViewSpacing.large)
                .padding(.bottom, ViewSpacing.large)
            }
        }
    }
}

#Preview {
    SadQuestionStyleTodoView(
        question: MoodTreatmentQuestion(
            id: 8,
            totalQuestions: 10,
            uiStyle: .styleTodo,
            texts: ["你计划吃点什么呢？"],
            animation: nil,
            options: [],
            introTexts: ["输入你的计划"],
            showSlider: false,
            endingStyle: nil,
            customViewName: nil,
            routine: "sad"
        ),
        onContinue: {}
    )
    .environmentObject(RouterModel())
}
