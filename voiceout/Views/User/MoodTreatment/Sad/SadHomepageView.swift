//
//  MoodTreatmentSadHomepageView.swift
//  voiceout
//
//  Created by Yujia Yang on 4/3/25.
//

import SwiftUI

struct MoodTreatmentSadHomepageView: View {
    @EnvironmentObject var router: RouterModel
    
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

        let rainHeight: CGFloat
        let rainWidth: CGFloat
        let sadHeight: CGFloat
        let rainOffsetY: CGFloat
        let sadOffsetY: CGFloat
        let bubbleTopPadding: CGFloat
        let cloudOffsetY: CGFloat

        switch category {
        case .small:
            rainHeight = 360
            rainWidth = 360
            sadHeight = 80
            rainOffsetY = 2*ViewSpacing.large+ViewSpacing.xsmall
            sadOffsetY = ViewSpacing.xxlarge+ViewSpacing.xxxsmall
            bubbleTopPadding = 168
            cloudOffsetY = ViewSpacing.medium+ViewSpacing.large
        case .medium:
            rainHeight = 400
            rainWidth = 400
            sadHeight = 90
            rainOffsetY = ViewSpacing.xlarge
            sadOffsetY = 2*ViewSpacing.large
            bubbleTopPadding = 184
            cloudOffsetY = ViewSpacing.medium+ViewSpacing.large
        case .large:
            rainHeight = 440
            rainWidth = 440
            sadHeight = 100
            rainOffsetY = ViewSpacing.medium+ViewSpacing.xsmall
            sadOffsetY = ViewSpacing.xlarge+ViewSpacing.xsmall
            bubbleTopPadding = 196
            cloudOffsetY = ViewSpacing.medium+ViewSpacing.large
        }

        return MoodPageContainerView(
            mood: "sad",
            onHealTap: {},
            content: {
                VStack(spacing: 0) {
                    HStack(alignment: .bottom, spacing: 0) {
                        ZStack(alignment: .topLeading) {
                            Image("bubble-right")
                                .resizable()
                                .frame(width: 194, height: 63)
                                .imageShadow()
                            Text("小云朵检测到你今天心情不太好哦！")
                                .font(Font.typography(.bodyMedium))
                                .foregroundColor(.grey500)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.top, ViewSpacing.betweenSmallAndBase)
                                .padding(.leading, ViewSpacing.small-ViewSpacing.xxsmall)
                                .frame(width: 175, alignment: .center)
                        }

                        Image("cloud-chat")
                            .resizable()
                            .frame(width: 100, height: 71)
                            .offset(y: cloudOffsetY)
                    }
                    .padding(.top, bubbleTopPadding)
                    .padding(.trailing, cloudChatTrailingOffset(for: screenWidth))

                    Spacer()

                    Button(action: {
                        router.navigateTo(.sadSingleQuestion(id: 1))
                    }) {
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
    
    private func cloudChatTrailingOffset(for width: CGFloat) -> CGFloat {
        switch width {
        case ..<400:
            return -105
        case 400..<430:
            return -130
        default:
            return -170
        }
    }
}

#Preview {
    MoodTreatmentSadHomepageView()
}
