//
//  MoodTreatmentAnxietyHomepageView.swift
//  voiceout
//
//  Created by Yujia Yang on 4/3/25.
//

import SwiftUI

struct MoodTreatmentAnxietyHomepageView: View {
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

        return MoodPageContainerView(
            mood: "anxiety",
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
                                .padding(.leading, ViewSpacing.xxsmall+ViewSpacing.xsmall)
                                .frame(width: 175, alignment: .center)
                        }
                        
                        Image("cloud-chat")
                            .resizable()
                            .frame(width: 100, height: 71)
                            .offset(y: ViewSpacing.medium+ViewSpacing.large)
                    }
                    .padding(.top, 22*ViewSpacing.betweenSmallAndBase)
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
                    Image("anxiety")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 113)
                        .offset(y: 185)
                        .allowsHitTesting(false)
                    Image("clew")
                        .resizable()
                        .frame(width: 176, height: 114)
                        .offset(y: 2*ViewSpacing.xlarge+ViewSpacing.xxxsmall)
                        .allowsHitTesting(false)
                        .padding(.top,-ViewSpacing.betweenSmallAndBase)
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
    MoodTreatmentAnxietyHomepageView()
}
