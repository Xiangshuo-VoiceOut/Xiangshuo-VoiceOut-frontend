//
//  TherapistRegistrationFinishedView.swift
//  voiceout
//
//  Created by J. Wu on 7/23/24.
//

import SwiftUI

struct TherapistRegistrationFinishedView: View {
    var title: String
    var content: String
    var buttonText: String
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack {
                    Spacer()
                    VStack(alignment: .center, spacing: ViewSpacing.medium) {
                        Text(title)
                            .font(.typography(.headerSmall))
                            .foregroundColor(.textPrimary)
                            .padding(.bottom, ViewSpacing.large)

                        Text(content)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.textPrimary)
                            .font(.typography(.bodyMedium))
                            .padding(.bottom, ViewSpacing.large)

                        ButtonView(text: buttonText, action: {}, spacing: .large, maxWidth: .infinity)
                    }
                    .padding(.horizontal)
                    .padding(.vertical)
                    .background(
                        RoundedRectangle(cornerRadius: .large)
                            .fill(Color.white)
                            .frame(width: 342, height: 300)
                            .shadow(color: Color(red: 0.35, green: 0.46, blue: 0.65).opacity(0.04), radius: 10, x: 2, y: 12)
                    )
                    .padding(.horizontal)
                    Spacer()
                }
                .padding(.bottom,ViewSpacing.xxxlarge)
                .padding(.horizontal, ViewSpacing.medium)
                .navigationBarTitle("voice_out", displayMode: .inline)
                .navigationBarItems(leading: Image("logo")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .padding(.leading,ViewSpacing.xsmall)
                )
                    
                .navigationBarItems(trailing: Button(action:{}){
                    Text("login")
                        .font(.typography(.bodyMedium))
                        .foregroundColor(.textTitle)
                })
            }
        }
    }
}

#Preview {
    TherapistRegistrationFinishedView(title: "注册成功!", content: "感谢您选择想说！请耐心等待3-5天，待资料审核成功后通知您。\n确认后跳转至登录页面。", buttonText: "确认")
//    TherapistRegistrationFinishedView(title: "注册成功!", content: "接下来请继续完成入驻流程！", buttonText: "确认")
}
