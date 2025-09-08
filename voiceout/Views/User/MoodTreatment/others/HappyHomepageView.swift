//
//  MoodTreatmentHappyHomepageView.swift
//  voiceout
//
//  Created by Yujia Yang on 4/3/25.
//

import SwiftUI

struct MoodTreatmentHappyHomepageView: View {
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
        
        let sunWidth: CGFloat
        let sunHeight: CGFloat
        let sunOffsetY: CGFloat
        let bubbleTrailingOffset: CGFloat
        
        switch category {
        case .small:
            sunWidth = 340
            sunHeight = 340
            sunOffsetY = ViewSpacing.xxlarge-ViewSpacing.xxsmall
            bubbleTrailingOffset = -11*ViewSpacing.betweenSmallAndBase
        case .medium:
            sunWidth = 360
            sunHeight = 360
            sunOffsetY = ViewSpacing.xxlarge-ViewSpacing.xxsmall
            bubbleTrailingOffset = -13*ViewSpacing.betweenSmallAndBase
        case .large:
            sunWidth = 380
            sunHeight = 380
            sunOffsetY = 2*ViewSpacing.large+ViewSpacing.xsmall
            bubbleTrailingOffset = -17*ViewSpacing.betweenSmallAndBase
        }
        
        return MoodPageContainerView(
            mood: "happy",
            onHealTap: {},
            content: {
                VStack(spacing: 0) {
                    HStack(alignment: .top, spacing: ViewSpacing.small) {
                        Image("cloud-chat")
                            .resizable()
                            .frame(width: 100, height: 71)
                            .scaleEffect(x: -1, y: 1)
                        ZStack(alignment: .topLeading) {
                            Image("bubble-left")
                                .resizable()
                                .frame(width: 200, height: 66)
                                .imageShadow()
                            Text("你的心情如阳光般明亮，继续享受这一刻！")
                                .padding(.top, ViewSpacing.betweenSmallAndBase)
                                .padding(.leading, ViewSpacing.large)
                                .frame(width: 190, alignment: .topLeading)
                                .font(Font.typography(.bodyMedium))
                                .foregroundColor(.grey500)
                        }
                        .offset(y: ViewSpacing.xlarge+ViewSpacing.xxsmall+ViewSpacing.xxxsmall)
                    }
                    .padding(.top, 22*ViewSpacing.betweenSmallAndBase)
                    .padding(.leading, cloudChatLeadingOffset(for: screenWidth))

                    Spacer()
                    
                }
            },
            background: {
                ZStack {
                    Image("sun")
                        .resizable()
                        .frame(width: sunWidth, height: sunHeight)
                        .offset(x: 5*ViewSpacing.betweenSmallAndBase,y: sunOffsetY)
                        .allowsHitTesting(false)
                    Image("happy")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 124)
                        .offset(y: 4*ViewSpacing.large-ViewSpacing.xxxsmall)
                        .allowsHitTesting(false)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
        )
    }
    
    private func cloudChatLeadingOffset(for width: CGFloat) -> CGFloat {
        switch width {
        case ..<400:
            return -90
        case 400..<420:
            return -120
        default:
            return -155
        }
    }
}

#Preview {
    MoodTreatmentHappyHomepageView()
}
