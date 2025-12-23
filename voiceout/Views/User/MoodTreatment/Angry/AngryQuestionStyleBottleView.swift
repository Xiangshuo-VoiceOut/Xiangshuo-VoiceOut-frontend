//
//  AngryQuestionStyleBottleView.swift
//  voiceout
//
//  Created by Yujia Yang on 6/10/25.
//

import SwiftUI

struct AngryQuestionStyleBottleView: View {
    let question: MoodTreatmentQuestion
    let onSelect: (MoodTreatmentAnswerOption) -> Void
    
    @State private var selectedIndex: Int?
    @State private var isExpanded: Bool = false
    @State private var isPlayingMusic: Bool = true
    @State private var showFollowUp: Bool = false
    private var messages: [String] {
        question.introTexts ?? []
    }
    private var promptText: String {
        question.texts?.first ?? "在进行积极自我对话之后，现在你是否感觉情绪平稳一些了呢？"
    }
    private var followUpOptions: [MoodTreatmentAnswerOption] {
        question.options
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.surfaceBrandTertiaryGreen
                .ignoresSafeArea()
            
            VStack {
                header
                if showFollowUp {
                    followUpSingleChoice
                        .transition(.opacity)
                } else {
                    bottleChoosing
                        .transition(.opacity)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .ignoresSafeArea(edges: .all)
        .animation(.easeInOut, value: showFollowUp)
    }
    
    private var header: some View {
        ZStack(alignment: .top) {
            HStack {
                Spacer()
                Image("cloud-chat")
                    .frame(width:168,height: 120)
                    .padding(.bottom, ViewSpacing.large)
                Spacer()
            }
            
//            HStack {
//                MusicButtonView()
//                Spacer()
//            }
        }
        .padding(.leading, ViewSpacing.medium)
    }

    private var bottleChoosing: some View {
        Group {
            if selectedIndex == nil {
                Text("请选择其中一个漂流瓶")
                    .font(Font.typography(.bodyMedium))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.grey500)
                    .frame(alignment: .top)
                    .padding(.bottom, 5*ViewSpacing.base)
                
                let cols = Array(repeating: GridItem(.flexible(), spacing: ViewSpacing.medium), count: 3)
                LazyVGrid(columns: cols, spacing: ViewSpacing.small) {
                    ForEach(messages.indices, id: \.self) { idx in
                        Button {
                            withAnimation { selectedIndex = idx }
                        } label: {
                            Image("bottle")
                                .frame(width: 40, height: 106)
                        }
                    }
                }
                .padding(.horizontal, 7*ViewSpacing.betweenSmallAndBase)
            } else {
                Text("请大声念出来或者默念")
                    .font(Font.typography(.bodyMedium))
                    .multilineTextAlignment(.center)
                    .frame(alignment: .top)
                    .foregroundColor(.grey500)
                    .padding(.bottom, ViewSpacing.large)
                
                if let idx = selectedIndex {
                    if !isExpanded {
                        HStack(spacing:0){
                            LottieView(
                                animationName: "scroll",
                                loopMode: .playOnce,
                                autoPlay: false
                            )
                            .onTapGesture { withAnimation { isExpanded = true } }
                            .padding(.bottom, ViewSpacing.large)
                            
                            Text("← 点击展开")
                                .font(Font.typography(.bodyMedium))
                                .foregroundColor(.grey500)
                        }
                        .padding(.horizontal,ViewSpacing.medium)
                        
                    } else {
                        ZStack {
                            LottieView(
                                animationName: "scroll",
                                loopMode: .playOnce,
                                autoPlay: true
                            )
                            .padding(.horizontal,ViewSpacing.medium)
                            
                            Text(messages[idx])
                                .font(Font.typography(.bodyMedium))
                                .foregroundColor(.textInvert)
                                .frame(alignment: .topLeading)
                                .padding(.top, -ViewSpacing.large)
                                .padding(.horizontal,ViewSpacing.small+ViewSpacing.betweenSmallAndBase+ViewSpacing.xxlarge)
                        }
                        .padding(.bottom, ViewSpacing.large)
                    }
                    
                    Image("bottle2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 106)
                        .contentShape(Rectangle())
                        .onTapGesture { withAnimation { showFollowUp = true } }
                    
                    Image("voice3")
                        .frame(width: 120, height: 120)
                        .foregroundColor(.textBrandPrimary)
                }
            }
        }
    }

    private var followUpSingleChoice: some View {
        VStack(spacing: ViewSpacing.large) {
            Text(promptText)
                .font(Font.typography(.bodyMedium))
                .multilineTextAlignment(.center)
                .foregroundColor(.grey500)
                .padding(.horizontal, ViewSpacing.xlarge)

            ForEach(followUpOptions, id: \.self) { opt in
                HStack {
                    Spacer()
                    Button {
                        onSelect(opt)
                    } label: {
                        Text(opt.text)
                            .font(Font.typography(.bodyMedium))
                            .foregroundColor(.grey500)
                            .padding(.horizontal, ViewSpacing.medium)
                            .padding(.vertical, ViewSpacing.base)
                            .background(Color.surfacePrimary)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .inset(by: 2)
                                    .stroke(Color(red: 0.42, green: 0.81, blue: 0.95),
                                            lineWidth: 4)
                            )
                    }
                }
                .padding(.trailing, ViewSpacing.medium)
            }

            Spacer()
        }
        .padding(.top, ViewSpacing.large)
    }
}

#Preview {
    let q = MoodTreatmentQuestion(
        id: 24,
        totalQuestions: 45,
        uiStyle: .styleBottle,
        texts: ["在进行积极自我对话之后，现在你是否感觉情绪平稳一些了呢？"],
        animation: nil,
        options: [
            .init(key: "A", text: "我感觉好多啦~", next: 35, exclusive: false),
            .init(key: "B", text: "我想试试其他练习", next: 36, exclusive: false)
        ],
        introTexts: [
            "现在我感到生气是完全合理的，但是更重要且有利的是保持头脑冷静，思维清醒，并作出最佳的判断。",
            "我不希望看到的事情出现了，这个状况使我的情绪波动，但我足够强大，可以接受已经发生的事实，所以没关系。",
            "我不会让这件事，或这个人影响自己的情绪。我才是掌控自己身体和心灵的主人。",
            "我不能掌控他人的想法或行为。他们有自己选择的路要走。世界也并不会永远按照我的想法运转，这很正常。",
            "我愿意给自己一点时间，温和的处理愤怒情绪，现在并不需要决定任何事。",
            "现状使人不满，但是我接下来会选择让事情朝着好的方向发展。我有信心，也足够有能力应对未来。"
        ],
        showSlider: false,
        endingStyle: nil,
        customViewName: nil,
        routine: "anger"
    )
    return AngryQuestionStyleBottleView(question: q, onSelect: { _ in })
        .environmentObject(RouterModel())
}

