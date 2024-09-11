//
//  StickyHeaderView.swift
//  voiceout
//
//  Created by Yujia Yang on 9/4/24.
//

import SwiftUI

struct StickyHeaderView: View {
    var title: String?
    var leadingComponent: AnyView?
    var trailingComponent: AnyView?
    var backgroundColor: Color = Color.surfacePrimary

    var body: some View {
        VStack {
            HStack {
                leadingComponent

                Spacer()

                trailingComponent
            }
            .padding(.horizontal, ViewSpacing.medium)
            .padding(.vertical, 0)
            .frame(height: 44, alignment: .leading)
            .background(backgroundColor)
            .overlay(
                Text(LocalizedStringKey(title ?? ""))
                    .font(Font.typography(.bodyLargeEmphasis))
                    .foregroundColor(.textPrimary)
                    .frame( height: 24, alignment: .bottomLeading)
            )

            Spacer()
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    StickyHeaderView(
        title: "个人主页",
        leadingComponent: AnyView(BackButtonView(navigateBackTo: .therapistLogin)),
        trailingComponent: AnyView(Button(action: {
           print("")
        }) {
           Image(systemName: "gear")
               .frame(height: 24)
               .foregroundColor(.black)
        })
    )
    .environmentObject(RouterModel())
}
