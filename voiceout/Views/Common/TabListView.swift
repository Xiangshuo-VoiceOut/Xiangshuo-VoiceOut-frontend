//
//  TabListView.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 9/28/24.
//

import SwiftUI

struct TabListView: View {
    var tabList: [Tab]
    @Binding var activeTab: Tab
    @State var tabProgress: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            let tabWidth = geometry.size.width / CGFloat(tabList.count)

            HStack(spacing: 0) {
                ForEach(Array(tabList.enumerated()), id: \.element.id) { index, tab in
                    HStack {
                        Text(tab.name)
                            .font(.typography(.bodyMedium))
                            .foregroundColor(activeTab == tab ? Color.textPrimary : Color.textSecondary)
                    }
                    .frame(maxWidth: tabWidth)
                    .padding(.vertical, ViewSpacing.small)
                    .contentShape(.capsule)
                    .onTapGesture {
                        withAnimation(.snappy) {
                            activeTab = tab
                            tabProgress = CGFloat(index) / (CGFloat(tabList.count) - 1)
                        }
                    }
                }
            }
            .background(
                GeometryReader {
                    let size = $0.size
                    let capusleWidth = tabWidth + 3
                    Capsule()
                        .fill(Color.surfacePrimary)
                        .frame(width: tabWidth)
                        .padding(ViewSpacing.xxsmall)
                        .offset(x: tabProgress * (size.width - capusleWidth))
                }
            )
            .background(Color.surfacePrimaryGrey, in: .capsule)
        }
        .frame(width: .infinity, height: 38)
    }
}

#Preview {
    TabListView(
        tabList: Tab.startEndTimes,
        activeTab: .constant(Tab.startEndTimes[0])
    )
}
