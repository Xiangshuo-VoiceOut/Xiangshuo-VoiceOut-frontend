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
                    .padding(.horizontal, 1)
                    .padding(.vertical, 20)
                    .frame(width: 216, height: 154, alignment: .center)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .padding(.top,180)
                }

                VStack(spacing: 0) {
                    HStack {
                        Button {
                            isPlayingMusic.toggle()
                        } label: {
                            Image(isPlayingMusic ? "music" : "stop-music")
                                .frame(width: 48, height: 48)
                        }
                        .padding(.leading, 16)

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
                                .padding(.horizontal, 16)
                                .padding(.trailing, 8)
                        }
                        .padding(.leading, 36)

                        Spacer()

                        Image("cloud-chat")
                            .resizable()
                            .frame(width: 100, height: 71)
                            .padding(.trailing, 16)
                            .offset(y: -20)
                    }
                    .padding(.top, 40)

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
