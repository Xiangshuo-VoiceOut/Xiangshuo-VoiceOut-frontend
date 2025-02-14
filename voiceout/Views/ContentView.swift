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
                    maxWidth: 258
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
                    maxWidth: 258
                )
            }
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [
                    Color(Color.surfaceBrandTertiaryPeach), .white
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
