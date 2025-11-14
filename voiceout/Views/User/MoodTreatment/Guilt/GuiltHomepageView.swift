//
//  MoodTreatmentGuiltHomepageView.swift
//  voiceout
//
//  Created by Yujia Yang on 4/3/25.
//

import SwiftUI

struct MoodTreatmentGuiltHomepageView: View {
    @State private var introLine: String
    private static let randomPrompts = [
        "小云朵检测到你今天心里有点沉甸甸的～别担心，我们可以一起把这份内疚轻轻放下。",
        "当你觉得“我是不是哪里做错了”的时候，小云朵会先抱抱你：先照顾好自己，再慢慢看清事情的样子。",
        "内疚像一块小石头落在心里，我们可以一起捡起来、看一看、再把它放回该放的地方。",
        "你已经很在意、也很用心了。小云朵希望你先原谅自己，再温柔地向前走。"
    ]
    init() {
        _introLine = State(initialValue: Self.randomPrompts.randomElement()!)
    }
    var body: some View {
        let screenWidth = UIScreen.main.bounds.width
        enum ScreenSizeCategory { case small, medium, large }
        let category: ScreenSizeCategory = {
            switch screenWidth {
            case ..<400:       return .small
            case 400..<420:    return .medium
            default:           return .large
            }
        }()

        let bubbleHeight: CGFloat = 112
        let bubbleHorizontalPadding: CGFloat
        let bubbleInnerTextTop: CGFloat
        let bubbleInnerTextLeading: CGFloat
        let bubbleTop: CGFloat

        let cloudChatOffsetX: CGFloat = 52
        let cloudChatOffsetY: CGFloat

        let buttonBottomPadding: CGFloat

        switch category {
        case .small:
            bubbleHorizontalPadding = 45
            bubbleInnerTextTop     = 16
            bubbleInnerTextLeading = 8
            bubbleTop              = 282
            cloudChatOffsetY       = 350
            buttonBottomPadding    = 60

        case .medium:
            bubbleHorizontalPadding = 45
            bubbleInnerTextTop     = 16
            bubbleInnerTextLeading = 8
            bubbleTop              = 292
            cloudChatOffsetY       = 360
            buttonBottomPadding    = 152
        case .large:
            bubbleHorizontalPadding = 45
            bubbleInnerTextTop     = 14
            bubbleInnerTextLeading = 10
            bubbleTop              = 304
            cloudChatOffsetY       = 370
            buttonBottomPadding    = 152
        }

        let heartWidth: CGFloat
        let heartHeight: CGFloat
        let heartOffsetX: CGFloat = 55
        let heartOffsetY: CGFloat

        let guiltHeight: CGFloat
        let guiltOffsetY: CGFloat

        switch category {
        case .small:
            heartWidth = 160; heartHeight = 150; heartOffsetY = 130
            guiltHeight = 110; guiltOffsetY = 175
        case .medium:
            heartWidth = 175; heartHeight = 160; heartOffsetY = 130
            guiltHeight = 122; guiltOffsetY = 175
        case .large:
            heartWidth = 190; heartHeight = 175; heartOffsetY = 130
            guiltHeight = 130; guiltOffsetY = 175
        }

        return MoodPageContainerView(
            mood: "guilt",
            onHealTap: {},
            content: {
                ZStack(alignment: .topTrailing) {
                    VStack(spacing: 0) {
                        VStack(spacing: 0) {
                            ZstackBubble(introLine: introLine,
                                         bubbleHeight: bubbleHeight,
                                         textTop: bubbleInnerTextTop,
                                         textLeading: bubbleInnerTextLeading)
                                .padding(.top, bubbleTop)

                            Spacer()

                            Button(action: {
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
                    Image("heart")
                        .resizable()
                        .frame(width: heartWidth, height: heartHeight)
                        .offset(x: heartOffsetX, y: heartOffsetY)
                        .allowsHitTesting(false)

                    Image("guilt")
                        .resizable()
                        .scaledToFit()
                        .frame(height: guiltHeight)
                        .offset(y: guiltOffsetY)
                        .allowsHitTesting(false)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
        )
    }
}

private struct ZstackBubble: View {
    let introLine: String
    let bubbleHeight: CGFloat
    let textTop: CGFloat
    let textLeading: CGFloat

    var body: some View {
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
                .padding(.top, textTop)
                .padding(.leading, textLeading)
                .frame(maxWidth: .infinity, alignment: .topLeading)
        }
    }
}

#Preview {
    MoodTreatmentGuiltHomepageView()
}
