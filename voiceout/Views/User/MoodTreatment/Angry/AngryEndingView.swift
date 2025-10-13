//
//  AngryEndingView.swift
//  voiceout
//
//  Created by Yujia Yang on 6/10/25.
//

import SwiftUI

struct AngryEndingView: View {
    @State private var showImageBackground = false
    @State private var animationDone = false
    @State private var isPlayingMusic = true

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            ZStack(alignment: .topLeading) {
                if showImageBackground {
                    Image("angry-ending")
                        .resizable()
                        .ignoresSafeArea()
                } else {
                    moodColors["angry"]!.ignoresSafeArea()
                }

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
                } else {
                    HStack(alignment: .center) {
                        Image("happy")
                            .frame(width: 214, height: 124)
                    }
                    .padding(.horizontal, ViewSpacing.xxxsmall)
                    .padding(.vertical, 2*ViewSpacing.betweenSmallAndBase)
                    .frame(width: 216, height: 154, alignment: .center)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .padding(.top,ViewSpacing.large+ViewSpacing.xlarge+ViewSpacing.xxxxlarge)
                }

                VStack(spacing: 0) {
                    HStack {
                        MusicButtonView()
                            .padding(.leading, ViewSpacing.medium)

                        Spacer()
                    }

                    HStack(alignment: .top, spacing: 0) {
                        ZStack {
                            Image("bubble-union")
                                .resizable()
                                .frame(height: 90)
                                .imageShadow()
                            Text("你已经收集了足够多的水滴了，长按屏幕帮助小云朵平息怒火吧!")
                                .font(Font.typography(.bodyMedium))
                                .foregroundColor(.grey500)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, ViewSpacing.medium)
                                .padding(.trailing, ViewSpacing.small)
                        }
                        .padding(.leading, ViewSpacing.xsmall+ViewSpacing.xlarge)

                        Spacer()

                        Image("cloud-chat")
                            .resizable()
                            .frame(width: 100, height: 71)
                            .padding(.trailing, ViewSpacing.medium)
                            .offset(y: -ViewSpacing.small-ViewSpacing.base)
                    }
                    .padding(.top, ViewSpacing.medium+ViewSpacing.large)

                    Spacer()
                }
            }
            .onAppear {
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
    AngryEndingView()
        .environmentObject(RouterModel())
}
