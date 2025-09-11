//
//  MoodTreatmentEnvyHomepageView.swift
//  voiceout
//
//  Created by Yujia Yang on 4/3/25.
//

import SwiftUI

struct MoodTreatmentEnvyHomepageView: View {
    @State private var introLine: String
    
    private static let randomPrompts = [
        "哎呀，小云朵在你身边闻到了一点点柠檬味呢～嫉妒情绪就像一颗青柠檬糖，虽然有点涩涩的，但也是人之常情哦。让我们一起温柔地看待它吧！",
        "咦？是不是看到别人拥有的东西让你心里有点刺刺的？别担心，小云朵完全理解这种感受。来，我们先给这份情绪一个大大的拥抱，再慢慢疏解它～",
        "小云朵发现你心里有个小小的声音在说\"为什么不是我呢？\"～这种酸酸的感觉其实很正常，说明你在意某些东西呢。让我们一起好好聆听这个声音吧！",
        "啊，是不是有朵小嫉妒云在你心里打转儿？它可能让你觉得不太舒服，但这也是你内心的一部分哦。来，我们像对待小朋友一样耐心地陪伴它～",
        "小云朵注意到你眼里闪过一丝失落的光芒～当我们看到别人拥有自己渴望的东西时，心里泛起涟漪是很自然的。让我们一起温柔地探索这份感受吧！"
    ]
    
    init() {
        _introLine = State(initialValue: Self.randomPrompts.randomElement()!)
    }
    
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
                                .frame(width: 265, height: 130)
                                .imageShadow()
                            Text(introLine)
                                .font(Font.typography(.bodyMedium))
                                .foregroundColor(.grey500)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.top, ViewSpacing.betweenSmallAndBase)
                                .padding(.leading, ViewSpacing.small-ViewSpacing.xxsmall)
                                .frame(width: 240, alignment: .center)
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
            return -35
        case 400..<430:
            return -65
        default:
            return -100
        }
    }
}

#Preview {
    MoodTreatmentEnvyHomepageView()
}
