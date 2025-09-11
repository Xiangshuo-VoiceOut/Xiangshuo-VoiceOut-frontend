//
//  AngryQuestionStyleDView.swift
//  voiceout
//
//  Created by Yujia Yang on 5/20/25.
//

import SwiftUI

struct AngryQuestionStyleDView: View {
    let question:        MoodTreatmentQuestion
    let onButtonTap:     () -> Void
    let onCalendarTap:   (() -> Void)?
    
    @State private var sliderValue     = 0.5
    @State private var isPlayingMusic  = true
    @State private var completedLines  = 0
    
    private let typingInterval: TimeInterval = 0.08
    
    private var displayTexts: [String] {
        if let texts = question.texts, !texts.isEmpty {
            return texts
        }
        return [fallbackText]
    }
    private var displayIntro: [String] {
        if let intros = question.introTexts, !intros.isEmpty {
            return intros
        }
        return [fallbackIntro]
    }
    private var totalTypeCount: Int {
        displayTexts.count + displayIntro.count
    }
    
    private static let praise = [
        "真棒！你已经能够正视这份嫉妒情绪了～它就像一面小镜子，照出了你内心真正的渴望。记住，每个梦想都值得被温柔对待，小云朵会为你加油！",
        "看呀，那朵小绿云已经慢慢变成指引你前行的路标啦！通过这次经历，你更了解自己内心的期待了，这真是很珍贵的成长呢～小云朵为你鼓掌！",
        "你已经把嫉妒转化成了认识自我的机会，这真是太了不起了！每个人都有自己的成长节奏，就像不同的花朵会在不同的季节绽放一样美丽～",
        "小云朵好开心看到你把这份情绪变成了自我探索的礼物～记住，你的人生故事是独一无二的，不需要和别人比较。现在的你已经很棒很棒了！",
        "真为你骄傲！你已经学会用温柔的目光看待嫉妒情绪了～它提醒我们正视自己，而你已经找到了健康的方式来表达。小云朵会一直陪伴着你成长！"
    ]
    @State private var fallbackText  = Self.praise.randomElement()!
    @State private var fallbackIntro = Self.praise.randomElement()!
    
    private var finishOption: MoodTreatmentAnswerOption? {
        question.options.first { $0.exclusive == false }
    }
    private var needCalendarBtn: Bool {
        question.options.contains { $0.exclusive == true }
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.surfaceBrandTertiaryGreen.ignoresSafeArea()
            
            VStack(spacing: 0) {
                ZStack(alignment: .topLeading) {
                    HStack {
                        Spacer()
                        Image("cloud-chat")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 168)
                            .padding(.bottom, 24)
                        Spacer()
                    }
                    
                    Button { isPlayingMusic.toggle() } label: {
                        Image(isPlayingMusic ? "music" : "stop-music")
                            .resizable()
                            .frame(width: 48, height: 48)
                    }
                    .padding(.leading, 16)
                }
                
                ForEach(Array(displayTexts.enumerated()), id: \.offset) { idx, line in
                    TypewriterText(fullText: line,
                                   characterDelay: typingInterval) {
                        completedLines += 1
                    }
                    .font(.typography(.bodyMedium))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.grey500)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 64)
                    .padding(.bottom, 16)
                }
                
                if completedLines >= displayTexts.count {
                    ForEach(displayIntro, id: \.self) { line in
                        TypewriterText(fullText: line,
                                       characterDelay: typingInterval) {
                            completedLines += 1
                        }
                        .font(.typography(.bodyMediumEmphasis))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.textBrandPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 64)
                        .padding(.bottom, 24)
                    }
                }
                
                Spacer()
                
                if completedLines >= totalTypeCount {
                    VStack(spacing: 0) {
                        Text("现在愤怒的强烈程度是？")
                            .font(.typography(.bodyMediumEmphasis))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.textPrimary)
                        
                        SliderView(value: $sliderValue,
                                   minValue: 0, maxValue: 1,
                                   trackColor: .surfaceBrandPrimary,
                                   thumbInnerColor: .surfaceBrandPrimary,
                                   thumbOuterColor: .surfacePrimaryGrey2,
                                   thumbInnerDiameter: 12,
                                   thumbOuterDiameter: 16)
                        .frame(height: 16)
                        
                        HStack {
                            Text("平静")
                                .font(.typography(.bodyXXSmall))
                                .foregroundColor(.textLight)
                            Spacer()
                            Text("愤怒")
                                .font(.typography(.bodyXXSmall))
                                .foregroundColor(.textLight)
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    VStack(spacing: 24) {
                        
                        if let finish = finishOption {
                            Button {
                                onButtonTap()
                            } label: {
                                Text(finish.text)
                                    .font(.typography(.bodyMedium))
                                    .kerning(0.64)
                                    .foregroundColor(Color(red: 0, green: 0.6, blue: 0.8))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color.surfacePrimary)
                                    .cornerRadius(360)
                            }
                            .padding(.top, 70)
                        }
                        
                        if needCalendarBtn, let onCal = onCalendarTap {
                            Button(action: onCal) {
                                Text("前往情绪日历")
                                    .font(.typography(.bodyMediumEmphasis))
                                    .underline(true)
                                    .foregroundColor(.textBrandPrimary)
                            }
                        }
                    }
                    .padding(.bottom, 120)
                }
            }
        }
        .ignoresSafeArea(edges: .all)
    }
}

//  有「前往情绪日历」按钮
#Preview {
    AngryQuestionStyleDView(
        question: MoodTreatmentQuestion(
            id: 888,
            type: .slider,
            uiStyle: .styleD,
            texts:      [],
            animation:  nil,
            options: [
                .init(text: "心情管家-愤怒路线结束",
                      next: nil,
                      exclusive: false),
                .init(text: "",
                      next: nil,
                      exclusive: true)
            ],
            introTexts: [],
            showSlider: true,
            buttonTitle: "",
            endingStyle: nil
        ),
        onButtonTap:   { print("结束 ") },
        onCalendarTap: { print("去情绪日历 ") }
    )
}

// 没有「前往情绪日历」按钮
//#Preview{
//    AngryQuestionStyleDView(
//        question: MoodTreatmentQuestion(
//            id: 889,
//            type: .slider,
//            uiStyle: .styleD,
//            texts:      [],
//            animation:  nil,
//            options: [
//                .init(text: "心情管家-愤怒路线结束",
//                      next: nil,
//                      exclusive: false)
//            ],
//            introTexts: [],
//            showSlider: true,
//            buttonTitle: ""
//        ),
//        onButtonTap:   { print("结束 ") },
//        onCalendarTap: nil
//    )
//}
