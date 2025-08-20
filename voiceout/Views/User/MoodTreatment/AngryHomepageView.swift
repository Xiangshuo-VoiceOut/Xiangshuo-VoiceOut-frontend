//
//  MoodTreatmentAngryHomepageView.swift
//  voiceout
//
//  Created by Yujia Yang on 4/3/25.
//

import SwiftUI

struct MoodTreatmentAngryHomepageView: View {
    var body: some View {
        let screenWidth = UIScreen.main.bounds.width
        
        enum ScreenSizeCategory {
            case small, medium, large
        }
        
        let category: ScreenSizeCategory = {
            switch screenWidth {
            case ..<400:
                return .small
            case 400..<420:
                return .medium
            default:
                return .large
            }
        }()
        
        let bubbleTopPadding: CGFloat
        let bubbleWidth: CGFloat
        let bubbleHeight: CGFloat
        let textWidth: CGFloat
        
        switch category {
        case .small:
            bubbleTopPadding = 22*ViewSpacing.betweenSmallAndBase
            bubbleWidth = 260
            bubbleHeight = 120
            textWidth = 235
        case .medium:
            bubbleTopPadding = 24*ViewSpacing.betweenSmallAndBase
            bubbleWidth = 300
            bubbleHeight = 102
            textWidth = 270
        case .large:
            bubbleTopPadding = 24*ViewSpacing.betweenSmallAndBase
            bubbleWidth = 300
            bubbleHeight = 102
            textWidth = 270
        }
        
        return MoodPageContainerView(
            mood: "angry",
            onHealTap: {},
            content: {
                VStack(spacing: 0) {
                    HStack(alignment: .bottom, spacing: 0) {
                        ZStack(alignment: .topLeading) {
                            Image("bubble-right")
                                .resizable()
                                .frame(width: bubbleWidth, height: bubbleHeight)
                                .imageShadow()
                            Text("小云朵感受到了你现在有些心情不好，我想要试着帮帮你呀。可以告诉我，你现在感觉有多愤怒吗？")
                                .font(Font.typography(.bodyMedium))
                                .foregroundColor(.grey500)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.top, ViewSpacing.medium)
                                .padding(.leading, ViewSpacing.base)
                                .frame(width: textWidth, alignment: .center)
                        }
                        
                        Image("cloud-chat")
                            .resizable()
                            .frame(width: 100, height: 71)
                            .offset(y: ViewSpacing.large+ViewSpacing.medium)
                    }
                    .padding(.top, bubbleTopPadding)
                    .padding(.trailing, cloudChatTrailingOffset(for: screenWidth))
                    
                    Spacer()
                    
                    Button(action: {}) {
                        ZStack {
                            Circle()
                                .fill(Color.surfacePrimary)
                                .frame(width: 72, height: 72)
                                .imageShadow()
                            VStack(spacing: 0) {
                                Image("love-and-help")
                                    .frame(width: 24, height: 24)
                                Text("疗愈")
                                    .font(Font.typography(.bodyMedium))
                                    .kerning(0.64)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.textBrandPrimary)
                            }
                        }
                        .overlay(
                            Circle()
                                .stroke(Color.grey50, lineWidth: StrokeWidth.width200.value)
                        )
                    }
                    .frame(width: 72, height: 72)
                }
            },
            background: {
                ZStack {
                    Image("fire")
                        .resizable()
                        .frame(width: 183, height: 253)
                        .offset(y: ViewSpacing.xxsmall+ViewSpacing.xxxlarge)
                        .allowsHitTesting(false)
                    
                    Image("angry")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 110)
                        .offset(y: 165)
                        .allowsHitTesting(false)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
        )
    }
    
    private func cloudChatTrailingOffset(for width: CGFloat) -> CGFloat {
        switch width {
        case ..<400:
            return -50
        case 400..<430:
            return -35
        default:
            return -75
        }
    }
}

#Preview {
    MoodTreatmentAngryHomepageView()
}
