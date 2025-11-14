//
//  MoodTreatmentEnvyHomepageView.swift
//  voiceout
//
//  Created by Yujia Yang on 4/3/25.
//

import SwiftUI

struct MoodTreatmentEnvyHomepageView: View {
    @EnvironmentObject var router: RouterModel
    @State private var introLine: String
    private static let randomPrompts = [
        "哎呀，小云朵在你身边闻到了一点点柠檬味呢～嫉妒情绪就像一颗青柠檬糖，虽然有点涩涩的，但也是人之常情哦。让我们一起温柔地看待它吧！",
        "咦？是不是看到别人拥有的东西让你心里有点刺刺的？别担心，小云朵完全理解这种感受。来，我们先给这份情绪一个大大的拥抱，再慢慢疏解它～",
        "小云朵发现你心里有个小小的声音在说“为什么不是我呢？”～这种酸酸的感觉其实很正常，说明你在意某些东西呢。让我们一起好好聆听这个声音吧！",
        "啊，是不是有朵小嫉妒云在你心里打转儿？它可能让你觉得不太舒服，但这也是你内心的一部分哦。来，我们像对待小朋友一样耐心地陪伴它～",
        "小云朵注意到你眼里闪过一丝失落的光芒～当我们看到别人拥有自己渴望的东西时，心里泛起涟漪是很自然的。让我们一起温柔地探索这份感受吧！"
    ]
    init() {
        _introLine = State(initialValue: Self.randomPrompts.randomElement()!)
    }
    var body: some View {
        let screenWidth = UIScreen.main.bounds.width
        enum ScreenSizeCategory { case small, medium, large }
        let category: ScreenSizeCategory = {
            switch screenWidth {
            case ..<400: return .small
            case 400..<420: return .medium
            default: return .large
            }
        }()

        let bubbleHeight: CGFloat = 156
        let bubbleHorizontalPadding: CGFloat
        let bubbleInnerTextTop: CGFloat
        let bubbleInnerTextLeading: CGFloat
        let bubbleTop: CGFloat

        let cloudChatOffsetX: CGFloat = 52
        let cloudChatOffsetY: CGFloat
        let buttonBottomPadding: CGFloat

        switch category {
        case .small:
            bubbleHorizontalPadding = 32
            bubbleInnerTextTop = 10
            bubbleInnerTextLeading = 14
            bubbleTop = 284
            cloudChatOffsetY = 375
            buttonBottomPadding = 60
        case .medium:
            bubbleHorizontalPadding = 45
            bubbleInnerTextTop = 14
            bubbleInnerTextLeading = 12
            bubbleTop = 300
            cloudChatOffsetY = 400
            buttonBottomPadding = 152
        case .large:
            bubbleHorizontalPadding = 45
            bubbleInnerTextTop = 24
            bubbleInnerTextLeading = 24
            bubbleTop = 314
            cloudChatOffsetY = 410
            buttonBottomPadding = 152
        }

        let questionWidth: CGFloat
        let questionHeight: CGFloat
        let questionOffsetX: CGFloat
        let questionOffsetY: CGFloat
        let envyHeight: CGFloat
        let envyOffsetY: CGFloat

        switch category {
        case .small:
            questionWidth = 135; questionHeight = 120
            questionOffsetX = 74; questionOffsetY = 128
            envyHeight = 115; envyOffsetY = 190
        case .medium:
            questionWidth = 150; questionHeight = 135
            questionOffsetX = 82; questionOffsetY = 118
            envyHeight = 130; envyOffsetY = 190
        case .large:
            questionWidth = 165; questionHeight = 150
            questionOffsetX = 94; questionOffsetY = 112
            envyHeight = 145; envyOffsetY = 190
        }

        return MoodPageContainerView(
            mood: "envy",
            onHealTap: {},
            content: {
                ZStack(alignment: .topTrailing) {

                    VStack(spacing: 0) {
                        VStack(spacing: 0) {
                            ZStack(alignment: .topLeading) {
                                Image("bubble-down-right")
                                    .resizable()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: bubbleHeight)
                                    .imageShadow()

                                Text(introLine)
                                    .font(Font.typography(.bodyMedium))
                                    .foregroundColor(.grey500)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.vertical, bubbleInnerTextTop)
                                    .padding(.horizontal, bubbleInnerTextLeading)
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                            }
                            .padding(.top, bubbleTop)

                            Spacer()

                            Button(action: {
                                router.navigateTo(.envySingleQuestion(id: 1))
                            }) {
                                Text("点击按钮继续")
                                    .font(Font.typography(.bodyMedium))
                                    .kerning(0.64)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.surfaceBrandPrimary)
                                    .frame(maxWidth: .infinity, minHeight: 44)
                                    .background(Color.surfacePrimary)
                                    .clipShape(Capsule())
                            }
                            .padding(.bottom, buttonBottomPadding)
                        }
                        .padding(.horizontal, bubbleHorizontalPadding)

                        Spacer()
                    }

                    Image("cloud-chat")
                        .resizable()
                        .frame(width: 100, height: 71)
                        .offset(x: cloudChatOffsetX, y: cloudChatOffsetY)
                        .allowsHitTesting(false)
                }
            },
            background: {
                ZStack {
                    Image("question")
                        .resizable()
                        .frame(width: questionWidth, height: questionHeight)
                        .offset(x: questionOffsetX, y: questionOffsetY)
                        .allowsHitTesting(false)
                    Image("envy")
                        .resizable()
                        .scaledToFit()
                        .frame(height: envyHeight)
                        .offset(y: envyOffsetY)
                        .allowsHitTesting(false)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
        )
    }
}

#Preview {
    MoodTreatmentEnvyHomepageView()
        .environmentObject(RouterModel())
}
