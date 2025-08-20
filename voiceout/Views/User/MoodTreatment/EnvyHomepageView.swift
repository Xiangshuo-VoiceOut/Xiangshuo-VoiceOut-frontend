//
//  MoodTreatmentEnvyHomepageView.swift
//  voiceout
//
//  Created by Yujia Yang on 4/3/25.
//

import SwiftUI

struct MoodTreatmentEnvyHomepageView: View {
    var body: some View {
        let screenWidth = UIScreen.main.bounds.width

        return MoodPageContainerView(
            mood: "envy",
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
                            .offset(y: ViewSpacing.medium+ViewSpacing.large)
                    }
                    .padding(.top, 2*LogoSize.large+ViewSpacing.large)
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
                    Image("question")
                        .resizable()
                        .frame(width: 150, height: 135)
                        .offset(x: 85,y: LogoSize.large+ViewSpacing.medium+ViewSpacing.large)
                        .allowsHitTesting(false)
                    Image("envy")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 130)
                        .offset(y: 2*LogoSize.large+ViewSpacing.medium)
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
    MoodTreatmentEnvyHomepageView()
}
