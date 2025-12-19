//
//  MoodTreatmentHappyHomepageView.swift
//  voiceout
//
//  Created by Yujia Yang on 4/3/25.
//

import SwiftUI

struct MoodTreatmentHappyHomepageView: View {
    @EnvironmentObject var router: RouterModel
    var body: some View {
        let secondaryTextHorizontalPadding: CGFloat = 45
        let cloudChatOverflowLeft: CGFloat = -54
        let buttonBottomPadding: CGFloat
        let screenWidth = UIScreen.main.bounds.width
        enum ScreenSizeCategory { case small, medium, large }
        let category: ScreenSizeCategory = {
            switch screenWidth {
            case ..<400: return .small
            case 400..<420: return .medium
            default: return .large
            }
        }()
        
        let sunWidth: CGFloat
        let sunHeight: CGFloat
        let sunOffsetY: CGFloat
        let sunOffsetX: CGFloat
        let happyOffsetY: CGFloat
        let bubbleTop: CGFloat
        let cloudChatOffsetY: CGFloat
        
        switch category {
        case .small:
            sunWidth = 340; sunHeight = 340
            sunOffsetX = 50
            sunOffsetY = -8
            happyOffsetY = 30
            buttonBottomPadding = 60
            bubbleTop = 290
            cloudChatOffsetY = 350

        case .medium:
            sunWidth = 360; sunHeight = 360
            sunOffsetX = 50
            sunOffsetY = 42
            happyOffsetY = 80
            buttonBottomPadding = 152
            bubbleTop = 350
            cloudChatOffsetY = 390

        case .large:
            sunWidth = 380; sunHeight = 380
            sunOffsetX = 50
            sunOffsetY = 40
            happyOffsetY = 80
            buttonBottomPadding = 152
            bubbleTop = 362
            cloudChatOffsetY = 420
        }
        
        return MoodPageContainerView(
            mood: "happy",
            onHealTap: {},
            content: {
                ZStack(alignment: .topLeading) {
                    Image("cloud-chat")
                        .resizable()
                        .frame(width: 100, height: 71)
                        .scaleEffect(x: -1, y: 1)
                        .offset(x: cloudChatOverflowLeft,y: cloudChatOffsetY)

                    VStack(spacing: 0) {
                        ZStack(alignment: .topLeading) {
                            Image("bubble-down-left")
                                .resizable()
                                .frame(width: 268, height: 90)
                                .imageShadow()
                            Text("你的心情如阳光般明亮，继续享受这一刻！")
                                .font(Font.typography(.bodyMedium))
                                .foregroundColor(.grey500)
                                .frame(width: 244, alignment: .topLeading)
                                .padding(.top, ViewSpacing.medium)
                                .padding(.leading, ViewSpacing.base)
                        }
                        .padding(.top, bubbleTop)
                        .padding(.horizontal,ViewSpacing.xxxsmall+ViewSpacing.base+ViewSpacing.medium)
                        Text("如果哪天想倾诉，也可以回来找我噢～")
                            .font(Font.typography(.bodyMedium))
                            .foregroundColor(.white)
                            .frame(width:244, alignment: .leading)
                            .padding(.horizontal, secondaryTextHorizontalPadding)
                            .padding(.top, ViewSpacing.small+ViewSpacing.base)

                        Spacer()

                        Button(action: {
                            router.navigateTo(.mainHomepage)
                        }) {
                            Text("结束")
                                .font(Font.typography(.bodyMedium))
                                .kerning(0.64)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.surfaceBrandPrimary)
                                .frame(maxWidth: .infinity, minHeight: 44)
                        }
                        .background(Color.surfacePrimary)
                        .clipShape(Capsule())
                        .buttonStyle(PlainButtonStyle())
                        .padding(.horizontal, 138)
                        .padding(.bottom, buttonBottomPadding)
                    }
                }
            },
            background: {
                ZStack {
                    Image("sun")
                        .resizable()
                        .frame(width: sunWidth, height: sunHeight)
                        .offset(x: sunOffsetX, y: sunOffsetY)
                        .allowsHitTesting(false)
                    Image("happy")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 124)
                        .offset(y: happyOffsetY)
                        .allowsHitTesting(false)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
        )
    }
}

#Preview {
    MoodTreatmentHappyHomepageView()
        .environmentObject(RouterModel())
}
