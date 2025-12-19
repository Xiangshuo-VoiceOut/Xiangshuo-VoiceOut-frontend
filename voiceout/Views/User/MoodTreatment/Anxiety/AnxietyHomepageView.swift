//
//  AnxietyHomepageView.swift
//  voiceout
//
//  Created by Ziyang Ye on 10/15/25.
//

import SwiftUI

struct MoodTreatmentAnxietyHomepageView: View {
    @EnvironmentObject var router: RouterModel
    @State private var introLine: String

    private static let randomPrompts = [
        "嗯，小伙伴，最近是不是有点焦虑？那种心里轻轻发紧、呼吸也有点浅的感觉。别急，先坐下来，我们慢一点，好吗？有时候，只要给自己一点时间，心就会慢慢松开。"
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

        let bubbleHeight: CGFloat = ViewSpacing.xxxxlarge + ViewSpacing.xlarge
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
            bubbleInnerTextTop     = 10
            bubbleInnerTextLeading = 14
            bubbleTop              = 284
            cloudChatOffsetY       = 375
            buttonBottomPadding    = 60

        case .medium:
            bubbleHorizontalPadding = 45
            bubbleInnerTextTop     = 14
            bubbleInnerTextLeading = 12
            bubbleTop              = 300
            cloudChatOffsetY       = 400
            buttonBottomPadding    = 152

        case .large:
            bubbleHorizontalPadding = 45
            bubbleInnerTextTop     = 24
            bubbleInnerTextLeading = 24
            bubbleTop              = 314
            cloudChatOffsetY       = 410
            buttonBottomPadding    = 152
        }

        let anxietyHomeWidth: CGFloat
        let anxietyHomeHeight: CGFloat
        let anxietyHomeOffsetY: CGFloat
        let anxietyHome2Width: CGFloat
        let anxietyHome2Height: CGFloat
        let anxietyHome2OffsetY: CGFloat

        switch category {
        case .small:
            anxietyHomeWidth = 180
            anxietyHomeHeight = 100
            anxietyHomeOffsetY = 200
            anxietyHome2Width = 150
            anxietyHome2Height = 100
            anxietyHome2OffsetY = 70
        case .medium:
            anxietyHomeWidth = 200
            anxietyHomeHeight = 110
            anxietyHomeOffsetY = 210
            anxietyHome2Width = 170
            anxietyHome2Height = 110
            anxietyHome2OffsetY = 70
        case .large:
            anxietyHomeWidth = 213
            anxietyHomeHeight = 113
            anxietyHomeOffsetY = 220
            anxietyHome2Width = 176
            anxietyHome2Height = 114
            anxietyHome2OffsetY = 80
        }

        return MoodPageContainerView(
            mood: "anxiety",
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
                                let startId = RoutineStartConfig.id(for: .anxiety)
                                router.navigateTo(.anxietySingleQuestion(id: startId))
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
                    Image("anxietyhomed")
                        .resizable()
                        .frame(width: anxietyHome2Width, height: anxietyHome2Height)
                        .offset(y: anxietyHome2OffsetY)
                        .allowsHitTesting(false)
                    
                    Image("anxietyhome")
                        .resizable()
                        .scaledToFit()
                        .frame(height: anxietyHomeHeight)
                        .offset(y: anxietyHomeOffsetY)
                        .allowsHitTesting(false)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
        )
    }
}

#Preview {
    MoodTreatmentAnxietyHomepageView()
        .environmentObject(RouterModel())
}
