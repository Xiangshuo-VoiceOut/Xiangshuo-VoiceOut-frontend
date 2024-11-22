//
//  BottomNavigationBar.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 11/22/24.
//

import SwiftUI

struct BottomNavigationBar: View {
    @State private var tabSelection = 0
    var tabList: [Tab]
    var screens: [AnyView]

    var body: some View {
        TabView(selection: $tabSelection) {
            ForEach(Array(screens.enumerated()), id: \.offset) { index, screen in
                screen
                    .tag(index)
            }
        }
        .overlay(alignment: .bottom) {
            HStack {
                ForEach(Array(tabList.enumerated()), id: \.offset) { index, tab in
                    Spacer()

                    Button(action: {
                        tabSelection = index
                    }) {
                        VStack(spacing: ViewSpacing.xsmall) {
                            Image(tab.icon ?? "")
                                .frame(width: 24, height: 24)
                                .foregroundColor(.borderPrimary)
                            Text(tab.name)
                                .font(.typography(.bodyXXSmall))
                                .foregroundColor(.textPrimary)
                        }
                    }

                    Spacer()
                }
            }
            .padding(.horizontal, ViewSpacing.medium)
            .padding(.top, ViewSpacing.base)
            .background(Color.surfacePrimary)
            .shadow(
                color: Color(red: 0.15, green: 0.15, blue: 0.25).opacity(0.06), radius: 5.75, x: 2, y: -4
            )
        }
    }
}

#Preview {
    BottomNavigationBar(
        tabList: Tab.bottomNavigationBar,
        screens: [
            AnyView(Text("View 1")),
            AnyView(Text("View 2")),
            AnyView(Text("View 3")),
            AnyView(Text("View 4"))
        ]
    )
}
