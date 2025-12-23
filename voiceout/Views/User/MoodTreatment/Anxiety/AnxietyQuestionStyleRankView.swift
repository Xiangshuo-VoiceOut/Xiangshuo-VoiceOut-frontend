//
//  AnxietyQuestionStyleRankView.swift
//  voiceout
//
//  Created by Ziyang Ye on 11/10/25.
//

import SwiftUI

private struct Constants {
    static let spacingSpacingM: CGFloat = 16
    static let surfaceSurfacePrimary: Color = Color(red: 0.98, green: 0.99, blue: 1)
    static let textTextPrimary: Color = Color.black
}

struct AnxietyQuestionStyleRankView: View {
    let question: MoodTreatmentQuestion
    let onContinue: () -> Void
    @ObservedObject var vm: MoodTreatmentVM

    @State private var isPlayingMusic = true
    @State private var displayedCount = 0
    @State private var bubbleHeight: CGFloat = 0
    @State private var selectedIconIndex: Int? = nil
    @State private var isSubmitting = false
    @EnvironmentObject var router: RouterModel

    private let displayDuration: TimeInterval = 1.5
    private let animationDuration: TimeInterval = 0.5

    private let bubbleFrameHeight: CGFloat = 48 + 64 + 71

    var body: some View {
        GeometryReader { proxy in
            let _ = proxy.safeAreaInsets.top
            let texts = question.texts ?? []

            ZStack(alignment: .topLeading) {
                backgroundView
//                musicButton
                mainContent(texts: texts)
                endTreatmentButton
            }
            .ignoresSafeArea(edges: .all)
            .onAppear { startBubbleSequence() }
        }
    }
    
    private var backgroundView: some View {
        Color.surfaceBrandTertiaryGreen
            .ignoresSafeArea(edges: .bottom)
    }
    
//    private var musicButton: some View {
//        Button { isPlayingMusic.toggle() } label: {
//            Image(isPlayingMusic ? "music" : "stop-music")
//                .resizable()
//                .frame(width: 48, height: 48)
//        }
//        .padding(.leading, ViewSpacing.medium)
//    }
    
    private var endTreatmentButton: some View {
        VStack {
            Spacer()
            Button(action: {
                submitRatingAndExit()
            }) {
                if isSubmitting {
                    ProgressView()
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(Color.surfacePrimary)
                        .clipShape(Capsule())
                } else {
                    Text("结束疗愈路线")
                        .font(Font.typography(.bodyMedium))
                        .kerning(0.64)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.surfaceBrandPrimary)
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(Color.surfacePrimary)
                        .clipShape(Capsule())
                }
            }
            .disabled(isSubmitting)
            .padding(.horizontal, ViewSpacing.xxxsmall+ViewSpacing.base+ViewSpacing.xlarge)
            .padding(.bottom, 5*ViewSpacing.base)
        }
    }
    
    private func submitRatingAndExit() {
        let rating = (selectedIconIndex ?? 2) + 1
        let routine = question.routine ?? "anxiety"
        
        isSubmitting = true
        
        Task {
            _ = await vm.submitRating(routine: routine, rating: rating)
            
            await MainActor.run {
                isSubmitting = false
                router.navigateTo(.moodHomepageLauncher)
            }
        }
    }
    
    @ViewBuilder
    private func mainContent(texts: [String]) -> some View {
        GeometryReader { geometry in
            let screenHeight = geometry.size.height
            let screenWidth = geometry.size.width
            let cloudChatHeight: CGFloat = 71
            let cloudChatDistanceFromBottom: CGFloat = 404 + 80
            let cloudChatTop: CGFloat = screenHeight - cloudChatDistanceFromBottom - cloudChatHeight
            let cloudChatCenter: CGFloat = screenHeight - cloudChatDistanceFromBottom - cloudChatHeight / 2
            let dialogTop: CGFloat = cloudChatCenter - bubbleFrameHeight
            let dialogBottom: CGFloat = dialogTop + bubbleFrameHeight
            let happyCloudBottom: CGFloat = dialogTop - 62
            let happyCloudHeight: CGFloat = 154.28571
            let happyCloudTop: CGFloat = happyCloudBottom - happyCloudHeight
            let happyCloudCenterY: CGFloat = happyCloudTop + happyCloudHeight / 2 + 100 + 80
            let selectionAreaTop: CGFloat = dialogBottom
            let selectionAreaHeight: CGFloat = 250
            let selectionAreaCenterY: CGFloat = selectionAreaTop + selectionAreaHeight / 2 + 150 - 50
            
            ZStack {
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: cloudChatTop - 44)
                    
                    chatBubbleSection(texts: texts)
                    
                    Spacer()
                }
                
                HStack(alignment: .center) {
                    Spacer()
                    Image("happy")
                        .resizable()
                        .scaledToFit()
                    Spacer()
                }
                .padding(.horizontal, ViewSpacing.xxxsmall)
                .padding(.vertical, ViewSpacing.small+ViewSpacing.base)
                .frame(width: 216, height: 154, alignment: .center)
                .position(
                    x: screenWidth / 2,
                    y: happyCloudCenterY
                )
                .allowsHitTesting(false)
                
                VStack(alignment: .leading, spacing: Constants.spacingSpacingM) {
                    HStack(alignment: .top) {
                        ForEach(0..<5) { index in
                            VStack(spacing: ViewSpacing.small) {
                                Button(action: {
                                    selectedIconIndex = index
                                }) {
                                    Image(selectedIconIndex == index ? "icon\(index + 1)-b" : "icon\(index + 1)")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 32, height: 32, alignment: .center)
                                }
                                
                                if index == 0 {
                                    Text("更糟")
                                        .font(Font.typography(.bodySmall))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Constants.textTextPrimary.opacity(0.6))
                                        .frame(width: 42, alignment: .top)
                                } else if index == 4 {
                                    Text("好多了")
                                        .font(Font.typography(.bodySmall))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Constants.textTextPrimary.opacity(0.6))
                                        .frame(width: 42, alignment: .top)
                                } else {
                                    Spacer()
                                        .frame(height: 20)
                                }
                            }
                            
                            if index < 4 {
            Spacer()
                            }
                        }
                    }
                }
                .padding(Constants.spacingSpacingM)
                .frame(width: 358, alignment: .topLeading)
                .background(Constants.surfaceSurfacePrimary)
                .cornerRadius(CornerRadius.medium.value)
                .position(
                    x: screenWidth / 2,
                    y: selectionAreaCenterY
                )
                .allowsHitTesting(true)
            }
        }
        .padding(.top, ViewSpacing.base+ViewSpacing.xlarge)
    }
    
    private func chatBubbleSection(texts: [String]) -> some View {
        HStack(alignment: .bottom, spacing: 0) {
            Image("cloud-chat")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 71)
                .scaleEffect(x: -1, y: 1)
                .offset(x: -ViewSpacing.medium)
                .frame(width: 68)

            VStack(alignment: .leading, spacing: ViewSpacing.betweenSmallAndBase) {
                AnxietyRankBubbleScrollView(
                    texts: texts,
                    displayedCount: $displayedCount,
                    bubbleHeight: $bubbleHeight,
                    bubbleSpacing: ViewSpacing.small,
                    totalHeight: bubbleFrameHeight
                )
            }
            .padding(0)
            .frame(width: 268, alignment: .bottomLeading)
            .frame(height: bubbleFrameHeight)
            .imageShadow()
            .offset(y: -35.5)

            Spacer()
        }
    }

    private func startBubbleSequence() {
        guard let texts = question.texts else { return }
        for idx in texts.indices {
            let delay = Double(idx) * (displayDuration + animationDuration)
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.easeInOut(duration: animationDuration)) {
                    displayedCount += 1
                }
            }
        }
    }
}

private struct AnxietyRankChatBubbleView: View {
    let text: String
    let showTriangle: Bool
    static let width: CGFloat = 268

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 4, x: 2, y: 2)
                .frame(width: Self.width)

            Text(text)
                .font(Font.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
                .frame(width: 244, alignment: .topLeading)
                .padding(.horizontal, ViewSpacing.base)
                .padding(.vertical, ViewSpacing.medium)

            if showTriangle {
                Image("vector49")
                    .resizable()
                    .frame(width: 15, height: 14)
                    .offset(x: ViewSpacing.large, y: ViewSpacing.xxsmall+ViewSpacing.base)
            }
        }
    }
}

private struct AnxietyRankBubbleScrollView: View {
    let texts: [String]
    @Binding var displayedCount: Int
    @Binding var bubbleHeight: CGFloat
    let bubbleSpacing: CGFloat
    let totalHeight: CGFloat

    private let animationDuration: TimeInterval = 0.25

    var body: some View {
        ScrollViewReader { reader in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: bubbleSpacing) {
                    ForEach(Array(texts.prefix(displayedCount).enumerated()), id: \.offset) { idx, line in
                        HStack {
                            let isLast = idx == displayedCount - 1
                            AnxietyRankChatBubbleView(text: line, showTriangle: isLast)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .background(
                            GeometryReader { geo in
                                Color.clear
                                    .preference(key: AnxietyRankBubbleHeightKey.self, value: geo.size.height)
                            }
                        )
                        .id(idx)
                    }
                }
                .frame(height: totalHeight, alignment: .bottom)
                .onPreferenceChange(AnxietyRankBubbleHeightKey.self) { bubbleHeight = $0 }
            }
            .frame(height: totalHeight + 14)
            .onAppear {
                scrollToLast(with: reader)
            }
            .onChange(of: displayedCount) { _, _ in
                withAnimation(.easeInOut(duration: animationDuration)) {
                    scrollToLast(with: reader)
                }
            }
        }
    }

    private func scrollToLast(with reader: ScrollViewProxy) {
        let lastIndex = max(0, displayedCount - 1)
        reader.scrollTo(lastIndex, anchor: .bottom)
    }

    private struct AnxietyRankBubbleHeightKey: PreferenceKey {
        static var defaultValue: CGFloat = 0
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = max(value, nextValue())
        }
    }
}

#Preview {
    AnxietyQuestionStyleRankView(
        question: MoodTreatmentQuestion(
            id: 1,
            totalQuestions: 10,
            uiStyle: .styleAnxietyRank,
            texts: [
                "相比疗愈前，你现在的感受是"
            ],
            animation: nil,
            options: [],
            introTexts: nil,
            showSlider: false,
            endingStyle: nil,
            customViewName: nil,
            routine: "anxiety"
        ),
        onContinue: {},
        vm: MoodTreatmentVM()
    )
}

