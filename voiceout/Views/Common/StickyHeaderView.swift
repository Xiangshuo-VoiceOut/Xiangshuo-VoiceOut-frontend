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
        HStack {
            leadingComponent
                .frame(width: 24)
                .padding(.leading, ViewSpacing.medium)
            Text(LocalizedStringKey(title ?? ""))
                .font(Font.typography(.bodyLargeEmphasis))
                .foregroundColor(.textPrimary)
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(maxWidth: .infinity, alignment: .center)
            if let trailingComponent = trailingComponent {
                trailingComponent
                    .frame(width: 24)
                    .padding(.trailing, ViewSpacing.medium)
            } else {
                Spacer()
                    .frame(width: 24)
                    .padding(.trailing, ViewSpacing.medium)
            }
        }
        .frame(height: 44)
        .background(backgroundColor)
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
