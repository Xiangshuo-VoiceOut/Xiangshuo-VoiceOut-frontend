//
//  ContentView.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 3/16/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var router: RouterModel
    @StateObject var dialogViewModel = DialogViewModel()
    @StateObject var popupViewModel = PopupViewModel()
    @State var isSelected: Bool = false

    var body: some View {
        VStack {
            Image("logo")
                .padding(.bottom, ViewSpacing.large)

            Text("slogan")
                .font(.typography(.bodyMedium))
                .foregroundColor(.textSecondary)
                .padding(.bottom, ViewSpacing.xxlarge)

            VStack(spacing: ViewSpacing.large) {
                ButtonView(
                    text: "user_login",
                    action: {
                        validateToLogin(
                            screenType: .userLogin,
                            isSelected: isSelected
                        )
                    },
                    spacing: .medium
                )

                ButtonView(
                    text: "consultant_login",
                    action: {
                        validateToLogin(
                            screenType: .therapistLogin,
                            isSelected: isSelected
                        )
                    },
                    variant: .outline,
                    spacing: .medium
                )

                NavigationLink(destination: ChatFrameView(userId: "7ee74d29-a1cd-4ab3-8b44-414f1c62bd42", userName: "咨询师刘雨")) {
                    Text("进入聊天服务")
                        .font(.title2)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(CornerRadius.medium.value)
                }
            }
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [
                    Color(.brandTertiary), .white
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay {
            LegalButton(isSelected: $isSelected)
                .environmentObject(dialogViewModel)
                .environmentObject(popupViewModel)
        }
        .navigationBarBackButtonHidden()
    }

    func validateToLogin(screenType: Route, isSelected: Bool) {
        if isSelected {
            router.navigateTo(screenType)
        } else {
            dialogViewModel.present(
                with: .init(
                    content: AnyView(
                        LegalDialogContent(isSelected: $isSelected)
                    )
                )
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(RouterModel())
    }
}
