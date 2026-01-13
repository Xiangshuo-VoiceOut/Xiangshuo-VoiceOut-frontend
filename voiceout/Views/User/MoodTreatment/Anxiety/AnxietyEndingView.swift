//
//  AnxietyEndingView.swift
//  voiceout
// Created by Ziyang Ye on 1/12/26.

import SwiftUI

/// 焦虑流程结算页状态机
enum AnxietyAnimationState {
    case initial    // 初始状态
    case pressing   // 长按中
    case resolved   // 已释放
}

struct AnxietyEndingView: View {
    let question: MoodTreatmentQuestion
    let onContinue: () -> Void
    
    @EnvironmentObject var router: RouterModel
    @State private var animationState: AnxietyAnimationState = .initial
    @State private var showFinalBubble = false
    @Namespace private var animation
    

    private var initialText: String {
        question.texts?.first ?? "长按屏幕帮助小云朵整理焦虑吧！"
    }
    
    private var endText: String {
        if let texts = question.texts, texts.count > 1 {
            return texts[1]
        }
        return "" 
    }
    

    private let notePositions: [CGPoint] = [
        CGPoint(x: -130, y: -65), CGPoint(x: 130, y: -75),
        CGPoint(x: -150, y: 10),  CGPoint(x: 150, y: 20),
        CGPoint(x: -110, y: 90),  CGPoint(x: 115, y: 95),
        CGPoint(x: 0, y: 125)
    ]
    
    var body: some View {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        

        let cloudCenterY = screenHeight * 0.40

        let bubbleBaselineY = screenHeight * (200.0 / 874.0) 
        
        ZStack(alignment: .top) {

            Color.surfaceBrandTertiaryPurple
                .ignoresSafeArea()
            

            VStack(spacing: 0) {
                Spacer()
                ZStack(alignment: .bottom) {
                    Image("anxietybook")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: screenWidth)
                    
                    if animationState == .resolved {
                        ZStack {
                            ForEach(0..<7, id: \.self) { index in
                                stickyNoteOnBook(index: index)
                                    .transition(.scale.combined(with: .opacity))
                            }
                        }
                        .padding(.bottom, screenHeight * 0.08)
                    }
                }
            }
            .ignoresSafeArea(edges: .bottom)
            

            ZStack {
                if animationState == .pressing {
                    Image("anxiety-ending-mess")
                        .resizable()
                        .frame(width: 140, height: 140)
                        .rotationEffect(.degrees(360))
                        .animation(.linear(duration: 4).repeatForever(autoreverses: false), value: animationState)
                        .offset(y: -180)
                        .transition(.opacity)
                }
                
                Image(animationState == .resolved ? "happy" : "anxiety")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 213)
                
                if animationState == .pressing {
                    ForEach(0..<7, id: \.self) { index in
                        Image("anxiety-ending-note\(index + 1)")
                            .resizable()
                            .frame(width: 55, height: 55)
                            .matchedGeometryEffect(id: "note-\(index)", in: animation)
                            .offset(x: notePositions[index].x, y: notePositions[index].y)
                            .transition(.opacity)
                    }
                }
            }
            .position(x: screenWidth / 2, y: cloudCenterY)
            

            Group {
                if animationState == .initial {
                    renderBubbleGroup(text: initialText)
                        .transition(.opacity)
                } else if showFinalBubble {
                    renderBubbleGroup(text: endText)
                        .transition(.opacity.animation(.easeInOut(duration: 0.8)))
                }
            }

            .frame(maxWidth: .infinity, maxHeight: bubbleBaselineY, alignment: .bottom)
        }
        .contentShape(Rectangle())
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if animationState == .initial {
                        withAnimation(.easeInOut(duration: 0.6)) {
                            animationState = .pressing
                        }
                    }
                }
                .onEnded { _ in
                    if animationState == .pressing {
                        withAnimation(.easeInOut(duration: 0.7)) {
                            animationState = .resolved
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            withAnimation(.easeInOut(duration: 0.8)) {
                                showFinalBubble = true
                            }
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
                            onContinue()
                        }
                    }
                }
        )
    }

    @ViewBuilder
    private func renderBubbleGroup(text: String) -> some View {
        ZStack(alignment: .bottomTrailing) {

            Text(text)
                .font(.typography(.bodyMedium))
                .foregroundColor(.grey500)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 16)
                .padding(.leading, 18)
                .padding(.trailing, 25)
                .padding(.bottom, 35) 
                .background(
                    Image("bubble-down-right")
                        .resizable(capInsets: EdgeInsets(top: 20, leading: 20, bottom: 40, trailing: 40))
                        .imageShadow()
                )
            

            Image("cloud-chat")
                .resizable()
                .frame(width: 100, height: 71)

                .offset(x: 80, y: 50)
                .allowsHitTesting(false)
        }
        .padding(.horizontal, 45)
    }
    
    private func stickyNoteOnBook(index: Int) -> some View {
        let positions: [CGPoint] = [
            CGPoint(x: -90, y: -40), CGPoint(x: -35, y: -45), CGPoint(x: 25, y: -40),
            CGPoint(x: 80, y: -35), CGPoint(x: -80, y: 15), CGPoint(x: -25, y: 20), CGPoint(x: 50, y: 25)
        ]
        
        return Image("anxiety-ending-note\(index + 1)")
            .resizable()
            .frame(width: 40, height: 40)
            .matchedGeometryEffect(id: "note-\(index)", in: animation)
            .offset(x: positions[index].x, y: positions[index].y)
            .animation(.spring(response: 0.7, dampingFraction: 0.8).delay(Double(index) * 0.08), value: animationState)
    }
}

