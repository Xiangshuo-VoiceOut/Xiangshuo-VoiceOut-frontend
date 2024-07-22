//
//  FinishView.swift
//  voiceout
//
//  Created by J. Wu on 7/8/24.
//

import SwiftUI
import Combine

struct FinishView: View {
    @StateObject var router: RouterModel = RouterModel()
    @State var finishText: String
    @State var navigateToText: String
    @State var countdown: Int = 3
    @State var destination: Route
    @State private var timer: AnyCancellable?
    var body: some View {
        ZStack{
            BackgroundView()
            
            VStack{
                HeaderView()
                    .offset(y: -100)
                
                Text(finishText)
                    .font(.typography(.headerMedium))
                    .foregroundColor(Color.textPrimary)
                    .padding(.bottom, ViewSpacing.small)
                Text(navigateToText)
                    .font(.typography(.bodyLarge))
                    .foregroundColor(Color.textPrimary)
                    .padding(.bottom, ViewSpacing.small)
                Text("\(countdown)S")
                    .font(.typography(.headerSmall))
                    .foregroundColor(Color.textPrimary)
                    .padding(.bottom)
            }
            
        }
        .ignoresSafeArea()
        .offset(y: -20)
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    router.navigateTo(.userLogin)
                }) {
                    Text("login")
                        .font(.typography(.bodyMedium))
                        .foregroundColor(.black.opacity(0.69))
                }
            }
        }
        .onAppear{
            startCountdown()
        }
    }
    
    private func startCountdown(){
        timer = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink{_ in
                if countdown > 0 {
                    countdown -= 1
                } else {
                    timer?.cancel()
                    router.navigateTo(destination)
                }
                
            }
    }
}

#Preview {
    FinishView(finishText: "注册成功", navigateToText: "正在跳转至登录页面", destination: .userLogin)
}
