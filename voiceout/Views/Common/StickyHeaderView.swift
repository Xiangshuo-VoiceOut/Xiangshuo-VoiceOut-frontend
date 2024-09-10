//
//  StickyHeaderView.swift
//  voiceout
//
//  Created by Yujia Yang on 9/4/24.
//

import SwiftUI

struct StickyHeaderView: View {
    let title: String
    let leadingComponent: AnyView?
    let trailingComponent: AnyView?

    var body: some View {
        VStack {
            HStack {
                if let leadingComponent = leadingComponent {
                    leadingComponent
                } else{
                    Spacer()
                }
                Spacer()
                if let trailingComponent = trailingComponent {
                    trailingComponent
                } else {
                    Spacer()
                }
            }
            .padding(.horizontal, ViewSpacing.medium)
            .padding(.vertical, 0)
            .frame(height: 44, alignment: .leading)
            .background(Color.surfacePrimary)
            .overlay(
                Text(title)
                    .font(Font.typography(.bodyLargeEmphasis))
                    .foregroundColor(.textPrimary)
                    .frame( height: 24, alignment: .bottomLeading)
            )
        }
        .navigationTitle("")
        .navigationBarHidden(true)
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
