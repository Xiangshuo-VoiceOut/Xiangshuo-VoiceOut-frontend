//
//  MoodTreatmentAngryHomepageView.swift
//  voiceout
//
//  Created by Yujia Yang on 4/3/25.
//

import SwiftUI

struct MoodTreatmentAngryHomepageView: View {
    @EnvironmentObject var router: RouterModel
    @State private var introLine: String

    private static let randomPrompts = [
        "哇！你的头顶飘来了小小的愤怒云，冒着火光呢～别担心，我会一直陪你度过情绪，恢复笑容！",
        "咦？空气中传来一丝烧焦的味道，是愤怒云在作怪呀～让我牵着你的手，一起收集水滴浇灭它！",
        "啊！我明显感受到你的怒气值快要爆表了～请快拉住我的手，放心吧，一切都会马上变好的！",
        "生气到忍不住挥动小拳拳捶大地了吗？别担心，不管怎么样，我都会坚定不移地站在你这边！",
        "你的心情现在一定像一杯被搅乱的奶茶～别怕，我会陪伴你，安静地等待它慢慢沉淀下来！"
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
            bubbleHorizontalPadding = 32
            bubbleInnerTextTop     = 16
            bubbleInnerTextLeading = 12
            bubbleTop              = 302
            cloudChatOffsetY       = 380
            buttonBottomPadding    = 60

        case .medium:
            bubbleHorizontalPadding = 45
            bubbleInnerTextTop     = 16
            bubbleInnerTextLeading = 14
            bubbleTop              = 338
            cloudChatOffsetY       = 405
            buttonBottomPadding    = 152

        case .large:
            bubbleHorizontalPadding = 45
            bubbleInnerTextTop     = 16
            bubbleInnerTextLeading = 20
            bubbleTop              = 349
            cloudChatOffsetY       = 415
            buttonBottomPadding    = 152
        }

        let fireWidth: CGFloat
        let fireHeight: CGFloat
        let fireOffsetY: CGFloat

        let angryHeight: CGFloat
        let angryOffsetY: CGFloat

        switch category {
        case .small:
            fireWidth = 160; fireHeight = 220; fireOffsetY = 55
            angryHeight = 100; angryOffsetY = 126
        case .medium:
            fireWidth = 183; fireHeight = 253; fireOffsetY = 75
            angryHeight = 110; angryOffsetY = 140
        case .large:
            fireWidth = 200; fireHeight = 270; fireOffsetY = 60
            angryHeight = 120; angryOffsetY = 138
        }

        return MoodPageContainerView(
            mood: "angry",
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
                                let startId = RoutineStartConfig.id(for: .angry)
                                router.navigateTo(.angrySingleQuestion(id: startId))
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
                    Image("fire")
                        .resizable()
                        .frame(width: fireWidth, height: fireHeight)
                        .offset(y: fireOffsetY)
                        .allowsHitTesting(false)
                    
                    Image("angry")
                        .resizable()
                        .scaledToFit()
                        .frame(height: angryHeight)
                        .offset(y: angryOffsetY)
                        .allowsHitTesting(false)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
        )
    }
}

#Preview {
    MoodTreatmentAngryHomepageView()
        .environmentObject(RouterModel())
}
