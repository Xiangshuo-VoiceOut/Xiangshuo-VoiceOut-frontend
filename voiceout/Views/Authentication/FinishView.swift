//
//  FinishView.swift
//  voiceout
//
//  Created by J. Wu on 7/8/24.
//

import SwiftUI

struct FinishView: View {
    @StateObject var router: RouterModel = RouterModel()
    @State var finishText: String
    @State var jumpToText: String
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
                Text(jumpToText)
                    .font(.typography(.bodyLarge))
                    .foregroundColor(Color.textPrimary)
                    .padding(.bottom, ViewSpacing.small)
                Text("3S")
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
    }
}

#Preview {
    FinishView(finishText: "注册成功", jumpToText: "正在跳转至登录页面")
}
