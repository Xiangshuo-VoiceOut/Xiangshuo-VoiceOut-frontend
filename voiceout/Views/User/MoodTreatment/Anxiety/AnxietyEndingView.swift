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
    
    // 1. 固定便签坐标：围绕在 anxiety cloud 附近
    private let notePositions: [CGPoint] = [
        CGPoint(x: -130, y: -65), CGPoint(x: 130, y: -75),
        CGPoint(x: -150, y: 10),  CGPoint(x: 150, y: 20),
        CGPoint(x: -110, y: 90),  CGPoint(x: 115, y: 95),
        CGPoint(x: 0, y: 125)
    ]
    
    private let finalText = NSLocalizedString(
        "anxiety_ending_bubble_text",
        value: "不要抓着每一件事不放手，学会在合适的时候画上完美句号。学会允许事情进入人生，也要学会让它们离开。未完成和不完美，本就是生活的一部分。请接受和相信自己已经做得足够好了，调整和相信自己会变得更好。",
        comment: "Anxiety ending bubble text"
    )
    
    var body: some View {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        // 核心位置常量
        let cloudCenterY = screenHeight * 0.40
        // 气泡底部对齐的基准高度（确保气泡底部固定在此，文字多则向上长）
        let bubbleBaselineY = screenHeight * (200.0 / 874.0) 
        
        ZStack(alignment: .top) {
            // --- 1. 背景层 ---
            Color.surfaceBrandTertiaryPurple
                .ignoresSafeArea()
            
            // --- 2. 底部书本层 (填满左右并贴底) ---
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
            
            // --- 3. 中间云朵与线团层 (位置绝对固定) ---
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
            
            // --- 4. 气泡 UI 层 (初始与最终共用逻辑) ---
            Group {
                if animationState == .initial {
                    renderBubbleGroup(text: "长按屏幕帮助小云朵整理焦虑吧！")
                        .transition(.opacity)
                } else if showFinalBubble {
                    renderBubbleGroup(text: finalText)
                        .transition(.opacity.animation(.easeInOut(duration: 0.8)))
                }
            }
            // 关键：通过容器限制，让气泡在 bubbleBaselineY 高度处向上生长
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
    
    // MARK: - 核心组件：向上生长且中心对齐的气泡
    @ViewBuilder
    private func renderBubbleGroup(text: String) -> some View {
        // 使用 .bottomTrailing 确保气泡右下角是稳定的对齐点
        ZStack(alignment: .bottomTrailing) {
            // 1. 气泡主体
            Text(text)
                .font(.typography(.bodyMedium))
                .foregroundColor(.grey500)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 16)
                .padding(.leading, 18)
                .padding(.trailing, 25)
                .padding(.bottom, 35) // 尖角所在位置的留白
                .background(
                    Image("bubble-down-right")
                        .resizable(capInsets: EdgeInsets(top: 20, leading: 20, bottom: 40, trailing: 40))
                        .imageShadow()
                )
            
            // 2. 说话的小云朵 (cloud-chat)
            Image("cloud-chat")
                .resizable()
                .frame(width: 100, height: 71)
                // 关键计算：将云朵向右移动一半宽度(50)，向下移动一半高度(35.5)
                // 这样云朵的正中心就会刚好压在气泡背景的右下角顶点上
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