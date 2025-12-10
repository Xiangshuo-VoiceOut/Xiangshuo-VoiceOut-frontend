//
//  MoodTreatmentScareHomepageView.swift
//  voiceout
//
//  Created by Yujia Yang on 4/3/25.
//

import SwiftUI

struct MoodTreatmentScareHomepageView: View {
    @State private var introLine: String
    private static let randomPrompts = [
        "小云朵听见了你心跳‘怦怦怦’的声音，是不是遇到什么让你紧张或不安的事了？别急，我在这儿。",
        "别怕，我看到你身边飘来了一朵颤颤巍巍的小害怕云，它躲在你身后偷偷发抖呢。别担心，我们可以一起慢慢走出来。",
        "啊，是不是有种心里凉凉的感觉，好像黑暗里有什么东西在盯着你？别怕，有我在，小云朵会点亮你的灯火！",
        "天空突然暗了下来，是不是让你有点不安？那来，我牵紧你的手，在这片小小乌云下，悄悄等阳光透进来吧～"
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

        let bubbleHeight: CGFloat = 106
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
            bubbleInnerTextTop = 14
            bubbleInnerTextLeading = 8
            bubbleTop = 310
            cloudChatOffsetY = 390
            buttonBottomPadding = 60

        case .medium:
            bubbleHorizontalPadding = 45
            bubbleInnerTextTop = 12
            bubbleInnerTextLeading = 6
            bubbleTop = 310
            cloudChatOffsetY = 400
            buttonBottomPadding = 152

        case .large:
            bubbleHorizontalPadding = 45
            bubbleInnerTextTop = 14
            bubbleInnerTextLeading = 8
            bubbleTop = 340
            cloudChatOffsetY = 400
            buttonBottomPadding = 152
        }

        let lightSize: CGFloat
        let lightOffsetY: CGFloat
        let scareHeight: CGFloat
        let scareOffsetY: CGFloat

        switch category {
        case .small:
            lightSize = 260;  lightOffsetY = 90
            scareHeight = 110; scareOffsetY = 127
        case .medium:
            lightSize = 286;  lightOffsetY = 65
            scareHeight = 125; scareOffsetY = 113
        case .large:
            lightSize = 310;  lightOffsetY = 76
            scareHeight = 135; scareOffsetY = 122
        }
        return MoodPageContainerView(
            mood: "scare",
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
                                    .padding(.top, bubbleInnerTextTop)
                                    .padding(.leading, bubbleInnerTextLeading)
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                            }
                            .padding(.top, bubbleTop)

                            Spacer()

                            Button(action: {
                                router.navigateTo(.scareSingleQuestion(id: 501))
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
                    Image("light")
                        .resizable()
                        .frame(width: lightSize, height: lightSize)
                        .offset(x: 3 * ViewSpacing.betweenSmallAndBase, y: lightOffsetY)
                        .allowsHitTesting(false)
                    Image("scare")
                        .resizable()
                        .scaledToFit()
                        .frame(height: scareHeight)
                        .offset(y: scareOffsetY)
                        .allowsHitTesting(false)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
        )
    }
}

#Preview {
    MoodTreatmentScareHomepageView()
}
