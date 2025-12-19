//
//  MoodTreatmentSadHomepageView.swift
//  voiceout
//
//  Created by Yujia Yang on 4/3/25.
//

import SwiftUI

struct MoodTreatmentSadHomepageView: View {
    @EnvironmentObject var router: RouterModel
    @State private var introLine: String

    private static let randomPrompts = [
        "嘿，小伙伴，有朵小失落云悄悄飘进你心里了呢～别担心，小云朵会一直陪在你身边，用温暖的风轻轻吹散它，让阳光重新回到你心上。",
        "今天的天空看起来灰蒙蒙的，像是被蒙上了一层薄纱呢～不过没关系，小云朵会牵着你的手，一起拨开乌云，等待阳光慢慢洒落下来。",
        "难过的时候就靠在小云朵怀里吧～所有委屈都会被温柔地接住，像收集露珠一样珍藏着，然后慢慢变成让你闪闪发光的特别力量！",
        "今天也要像对待最珍贵的朋友那样对待自己哦～请记住：你很努力，已经做得很棒很棒啦！小云朵要送你一个软乎乎的治愈能量包！",
        "小云朵发现你的心里泛起了一点小涟漪，让我们一起轻轻抚平它～就像折一只会飞翔的纸鹤，载着希望和勇气，飞向更明亮的天空吧！"
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

        let bubbleHeight: CGFloat = 122
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
            bubbleInnerTextTop = 10
            bubbleInnerTextLeading = 8
            bubbleTop = ViewSpacing.large * ViewSpacing.betweenSmallAndBase + 52
            cloudChatOffsetY = 370
            buttonBottomPadding = 60

        case .medium:
            bubbleHorizontalPadding = 45
            bubbleInnerTextTop = 10
            bubbleInnerTextLeading = 16
            bubbleTop = ViewSpacing.large * ViewSpacing.betweenSmallAndBase + 72
            cloudChatOffsetY = 390
            buttonBottomPadding = ViewSpacing.base + ViewSpacing.medium + ViewSpacing.xxxxlarge

        case .large:
            bubbleHorizontalPadding = 45
            bubbleInnerTextTop = 10
            bubbleInnerTextLeading = 10
            bubbleTop = ViewSpacing.large * ViewSpacing.betweenSmallAndBase + 106
            cloudChatOffsetY = 420
            buttonBottomPadding = ViewSpacing.base + ViewSpacing.medium + ViewSpacing.xxxxlarge
        }

        let rainWidth: CGFloat
        let rainHeight: CGFloat
        let rainOffsetY: CGFloat
        let sadHeight: CGFloat
        let sadOffsetY: CGFloat

        switch category {
        case .small:
            rainWidth = 360;  rainHeight = 360;  rainOffsetY = 40
            sadHeight = 80;   sadOffsetY = 54
        case .medium:
            rainWidth = 400;  rainHeight = 400;  rainOffsetY = 35
            sadHeight = 90;   sadOffsetY = 50
        case .large:
            rainWidth = 440;  rainHeight = 440;  rainOffsetY = 34
            sadHeight = 100;  sadOffsetY = 50
        }

        return MoodPageContainerView(
            mood: "sad",
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
                                let startId = RoutineStartConfig.id(for: .sad)
                                router.navigateTo(.sadSingleQuestion(id: startId))
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
                    Image("rain")
                        .resizable()
                        .frame(width: rainWidth, height: rainHeight)
                        .offset(y: rainOffsetY)
                        .allowsHitTesting(false)
                        .clipped()
                    Image("sad")
                        .resizable()
                        .scaledToFit()
                        .frame(height: sadHeight)
                        .offset(y: sadOffsetY)
                        .allowsHitTesting(false)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
        )
    }
}

#Preview {
    MoodTreatmentSadHomepageView()
        .environmentObject(RouterModel())
}
