//
//  AngryQuestionStyleBottleView.swift
//  voiceout
//
//  Created by Yujia Yang on 6/10/25.
//

import SwiftUI

struct AngryQuestionStyleBottleView: View {
    let messages: [String]
    
    @State private var selectedIndex: Int?
    @State private var isExpanded: Bool = false
    @State private var isPlayingMusic: Bool = true
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.surfaceBrandTertiaryGreen
                .ignoresSafeArea()
            
            VStack {
                ZStack(alignment: .top) {
                    HStack {
                        Spacer()
                        Image("cloud-chat")
                            .frame(width:168,height: 120)
                            .padding(.bottom, 24)
                        Spacer()
                    }
                    
                    HStack {
                        Button {
                            isPlayingMusic.toggle()
                        } label: {
                            Image(isPlayingMusic ? "music" : "stop-music")
                                .resizable()
                                .frame(width: 48, height: 48)
                        }
                        Spacer()
                    }
                }
                .padding(.leading, 16)
                
                if selectedIndex == nil {
                    Text("请选择其中一个漂流瓶")
                        .font(Font.typography(.bodyMedium))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.grey500)
                        .frame(alignment: .top)
                        .padding(.bottom, 60)
                    
                    let cols = Array(repeating: GridItem(.flexible(), spacing: 16), count: 3)
                    LazyVGrid(columns: cols, spacing: 8) {
                        ForEach(messages.indices, id: \.self) { idx in
                            Button {
                                withAnimation { selectedIndex = idx }
                            } label: {
                                Image("bottle")
                                    .frame(width: 40, height: 106)
                            }
                        }
                    }
                    .padding(.horizontal, 70)
                    
                } else {
                    Text("请大声念出来或者默念")
                        .font(Font.typography(.bodyMedium))
                        .multilineTextAlignment(.center)
                        .frame(alignment: .top)
                        .foregroundColor(.grey500)
                        .padding(.bottom, 24)
                    
                    if let idx = selectedIndex {
                        if !isExpanded {
                            HStack(spacing:0){
                                LottieView(
                                    animationName: "scroll",
                                    loopMode: .playOnce,
                                    autoPlay: false
                                )
                                .onTapGesture {
                                    withAnimation { isExpanded = true }
                                }
                                .padding(.bottom, 24)
                                
                                Text("← 点击展开")
                                    .font(Font.typography(.bodyMedium))
                                    .foregroundColor(.grey500)
                            }
                            .padding(.horizontal,16)
                            
                        } else {
                            ZStack {
                                LottieView(
                                    animationName: "scroll",
                                    loopMode: .playOnce,
                                    autoPlay: true
                                )
                                .padding(.horizontal,16)
                                
                                Text(messages[idx])
                                    .font(Font.typography(.bodyMedium))
                                    .foregroundColor(.textInvert)
                                    .frame(alignment: .topLeading)
                                    .padding(.top, -24)
                                    .padding(.horizontal,75)
                            }
                            .padding(.bottom, 24)
                        }
                        
                        Image("bottle2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 106)
                        
                        Image("voice3")
                            .frame(width: 120, height: 120)
                            .foregroundColor(.textBrandPrimary)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .ignoresSafeArea(edges: .all)
    }
}

#Preview {
    AngryQuestionStyleBottleView(
        messages: [
            "现在我感到生气是完全合理的，但是更重要且有利的是保持头脑冷静，思维清醒，并作出最佳的判断。",
            "我不希望看到的事情出现了，这个状况使我的情绪波动，但我足够强大，可以接受已经发生的事实，所以没关系。",
            "我不会让这件事，或这个人影响自己的情绪。我才是掌控自己身体和心灵的主人。",
            "我不能掌控他人的想法或行为。他们有自己选择的路要走。世界也并不会永远按照我的想法运转，这很正常。",
            "我愿意给自己一点时间，温和的处理愤怒情绪，现在并不需要决定任何事。",
            "现状使人不满，但是我接下来会选择让事情朝着好的方向发展。我有信心，也足够有能力应对未来。"
        ]
    )
}
