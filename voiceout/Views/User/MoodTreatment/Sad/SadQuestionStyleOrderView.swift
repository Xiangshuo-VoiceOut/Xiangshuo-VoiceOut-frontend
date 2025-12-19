//
//  SadQuestionStyleOrderView.swift
//  voiceout
//
//  Created by Ziyang Ye on 9/24/25.
//

import SwiftUI

struct SadQuestionStyleOrderView: View {
    let question: MoodTreatmentQuestion
    let onContinue: () -> Void
    
    @State private var currentTextIndex = 0
    @State private var isPlayingMusic = false
    @State private var showCurrentText = true
    @State private var sortedItems: [String] = []
    @State private var isOrdered = false
    
    private let typingInterval: TimeInterval = 0.1
    
    private let testOptions = [
        "善良", "诚实", "责任感", "勇气", "感恩", "礼貌",
        "耐心", "坚持", "独立", "宽容", "同情心", "正义感"
    ]
    
    private var currentText: String {
        guard let texts = question.texts, currentTextIndex < texts.count else {
            return ""
        }
        return texts[currentTextIndex]
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
                                .frame(width: 120, height: 80)
                                .padding(.bottom, ViewSpacing.small)
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

                    VStack(spacing: ViewSpacing.medium) {
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
                            .padding(.bottom, ViewSpacing.small)
                        }
                        
                        if isLastText {
                            sortingArea
                        }
                    }
                    .padding(.horizontal, ViewSpacing.large)
                    
                    bottomButtonArea
                }
            }
        }
        .ignoresSafeArea(edges: .all)
    }
    
    private var sortingArea: some View {
        VStack(spacing: ViewSpacing.small) {
            Text("拖拽整行或点击箭头调整顺序，最看重的放在最上面")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.bottom, ViewSpacing.small)
            
            GeometryReader { geometry in
                ScrollView {
                    LazyVStack(spacing: 4) {
                        ForEach(Array(sortedItems.enumerated()), id: \.element) { index, item in
                            OrderItemView(
                                item: item,
                                index: index,
                                items: $sortedItems
                            )
                        }
                    }
                    .padding(.horizontal, ViewSpacing.small)
                    .padding(.bottom, ViewSpacing.large)
                }
                .frame(maxHeight: geometry.size.height)
            }
            .frame(maxHeight: 450)
        }
        .padding(.horizontal, ViewSpacing.medium)
        .onAppear {
            if sortedItems.isEmpty {
                sortedItems = testOptions
            }
        }
    }
    
    private var bottomButtonArea: some View {
        VStack {
            if isLastText && !sortedItems.isEmpty {
                Button("完成") {
                    isOrdered = true
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

struct OrderItemView: View {
    let item: String
    let index: Int
    @Binding var items: [String]
    @State private var dragOffset = CGSize.zero
    @State private var isDragging = false
    @State private var dragStartPosition: CGPoint = .zero
    
    var body: some View {
        HStack {
            Text("\(index + 1)")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(Color(red: 0.404, green: 0.722, blue: 0.6))
                .frame(width: 25)
            
            Image(systemName: "line.3.horizontal")
                .font(.system(size: 14))
                .foregroundColor(.textSecondary)
                .frame(width: 16)
                .opacity(isDragging ? 0.5 : 1.0)
            
            Text(item)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 2) {
                Button {
                    moveItem(direction: -1)
                } label: {
                    Image(systemName: "chevron.up")
                        .font(.system(size: 10))
                        .foregroundColor(.textSecondary)
                }
                .disabled(index == 0)
                
                Button {
                    moveItem(direction: 1)
                } label: {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 10))
                        .foregroundColor(.textSecondary)
                }
                .disabled(index == items.count - 1)
            }
            .frame(width: 25)
        }
        .padding(.horizontal, ViewSpacing.small)
        .padding(.vertical, 6)
        .background(isDragging ? Color.surfacePrimary.opacity(0.8) : Color.surfacePrimary)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isDragging ? Color(red: 0.404, green: 0.722, blue: 0.6) : Color.gray.opacity(0.3), lineWidth: isDragging ? 2 : 1)
        )
        .offset(dragOffset)
        .scaleEffect(isDragging ? 1.05 : 1.0)
        .shadow(color: isDragging ? Color.black.opacity(0.3) : Color.clear, radius: 10)
        .contentShape(Rectangle())
        .gesture(
            DragGesture()
                .onChanged { value in
                    if !isDragging {
                        isDragging = true
                        dragStartPosition = value.startLocation
                    }
                    dragOffset = value.translation
                }
                .onEnded { value in
                    isDragging = false
                    dragOffset = .zero
                    
                    let dragDistance = value.translation.height
                    let itemHeight: CGFloat = 45
                    let positionsToMove = Int(abs(dragDistance) / itemHeight)
                    
                    if positionsToMove > 0 {
                        let direction = dragDistance > 0 ? 1 : -1
                        moveItemMultiplePositions(direction: direction, positions: positionsToMove)
                    }
                }
        )
    }
    
    private func moveItem(direction: Int) {
        let currentIndex = items.firstIndex(of: item) ?? 0
        let newIndex = currentIndex + direction
        
        guard newIndex >= 0 && newIndex < items.count else { return }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            items.swapAt(currentIndex, newIndex)
        }
    }
    
    private func moveItemMultiplePositions(direction: Int, positions: Int) {
        let currentIndex = items.firstIndex(of: item) ?? 0
        let newIndex = currentIndex + (direction * positions)
        
        guard newIndex >= 0 && newIndex < items.count else { return }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            let itemToMove = items.remove(at: currentIndex)
            items.insert(itemToMove, at: newIndex)
        }
    }
}

#Preview {
    SadQuestionStyleOrderView(
        question: MoodTreatmentQuestion(
            id: 10,
            totalQuestions: 10,
            uiStyle: .styleOrder,
            texts: ["小云朵想要你给一下几个品德按照你最看重的顺序进行排序"],
            animation: nil,
            options: [],
            introTexts: nil,
            showSlider: false,
            endingStyle: nil,
            customViewName: nil,
            routine: "sad"
        ),
        onContinue: {}
    )
    .environmentObject(RouterModel())
}
