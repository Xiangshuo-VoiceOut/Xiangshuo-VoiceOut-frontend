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
                        if isSelected {
                            router.navigateTo(.login)
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
                )
                
                ButtonView(
                    text: "consultant_login",
                    action: {
    //                    todo: add signup view
    //                    router.navigateTo()
                    },
                    variant: .outline
                )
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(RouterModel())
    }
}
