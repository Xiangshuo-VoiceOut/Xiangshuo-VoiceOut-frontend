//
//  EnvyFinalEndingView.swift
//  voiceout
//
//  Created by Yujia Yang on 7/1/25.
//

import SwiftUI

struct EnvyFinalEndingView: View {
    @State private var showImageBackground = false
    @State private var animationDone = false
    @State private var isPlayingMusic = true
    
    private let messages: [String] = [
        "真棒！你已经能够正视这份嫉妒情绪了～它就像一面小镜子，照出了你内心真正的渴望。记住，每个梦想都值得被温柔对待，小云朵会为你加油！",
        "看呀，那朵小绿云已经慢慢变成指引你前行的路标啦！通过这次经历，你更了解自己内心的期待了，这真是很珍贵的成长呢～小云朵为你鼓掌！",
        "你已经把嫉妒转化成了认识自我的机会，这真是太了不起了！每个人都有自己的成长节奏，就像不同的花朵会在不同的季节绽放一样美丽～",
        "小云朵好开心看到你把这份情绪变成了自我探索的礼物～记住，你的人生故事是独一无二的，不需要和别人比较。现在的你已经很棒很棒了！",
        "真为你骄傲！你已经学会用温柔的目光看待嫉妒情绪了～它提醒我们正视自己，而你已经找到了健康的方式来表达。小云朵会一直陪伴着你成长！"
    ]
    
    @State private var selectedMessage: String = ""
    
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            
            ZStack(alignment: .topLeading) {
                moodColors["envy"]!.ignoresSafeArea()
                
                if !animationDone {
                    LottieView(
                        animationName: "angry-end",
                        loopMode: .playOnce,
                        autoPlay: true,
                        onFinished: {
                            withAnimation {
                                animationDone = true
                            }
                        },
                        speed: 0.2
                    )
                    .frame(width: w, height: h * 0.9)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    .ignoresSafeArea(edges: .bottom)
                }
                
                VStack(spacing: 0) {
                    HStack {
                        Button {
                            isPlayingMusic.toggle()
                        } label: {
                            Image(isPlayingMusic ? "music" : "stop-music")
                                .frame(width: 48, height: 48)
                        }
                        .padding(.leading, ViewSpacing.medium)
                        
                        Spacer()
                    }
                    
                    HStack(alignment: .top, spacing: 0) {
                        ZStack {
                            Image("bubble-union1")
                                .resizable()
                                .frame(height: 140)
                                .imageShadow()
                            
                            Text(selectedMessage)
                                .font(Font.typography(.bodyMedium))
                                .foregroundColor(.grey500)
                                .multilineTextAlignment(.leading)
                                .padding(.horizontal,ViewSpacing.base)
                                .padding(.vertical, ViewSpacing.betweenSmallAndBase)
                                .padding(.bottom, ViewSpacing.medium)
                        }
                        .padding(.leading, ViewSpacing.medium+ViewSpacing.large)
                        
                        Image("cloud-chat")
                            .resizable()
                            .frame(width: 100, height: 71)
                            .offset(y: ViewSpacing.xlarge+ViewSpacing.xxxlarge)
                    }
                    .offset(x: ViewSpacing.xsmall+ViewSpacing.medium)
                    .padding(.top, ViewSpacing.large)
                    .frame(maxWidth: .infinity)
                    
                    Spacer()
                }
            }
            .onAppear {
                selectedMessage = messages.randomElement() ?? messages[0]

                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    withAnimation {
                        showImageBackground = true
                    }
                }
            }
        }
    }
}

#Preview {
    EnvyFinalEndingView()
        .environmentObject(RouterModel())
}
