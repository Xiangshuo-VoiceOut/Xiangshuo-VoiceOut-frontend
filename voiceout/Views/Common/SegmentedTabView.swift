//
//  SegmentedTabView.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 9/19/24.
//

import SwiftUI

struct SegmentedTabView: View {
    var tabList: [Tab]
    var panelList: [AnyView]
    var horizontalSpacing: CGFloat? = 0
    var isUsePanelHeight: Bool? = false
    @State var tabProgress: CGFloat = 0.5
    @State var activeTab: Tab?
    @State private var panelHeight: CGFloat = UIScreen.main.bounds.height

    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabList) { tab in
                HStack {
                    Text(tab.name)
                        .font(.typography(.bodyMedium))
                        .foregroundColor(activeTab == tab ? Color.textPrimary : Color.textSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, ViewSpacing.small)
                .contentShape(.capsule)
                .onTapGesture {
                    withAnimation(.snappy) {
                        activeTab = tab
                    }
                }
            }
        }
        .background(
            GeometryReader {
                let size = $0.size
                let capusleWidth = size.width / CGFloat(tabList.count)

                Capsule()
                    .fill(Color.surfacePrimary)
                    .frame(width: capusleWidth)
                    .padding(ViewSpacing.xxsmall)
                    .offset(x: tabProgress * (size.width - capusleWidth - 3))
            }
        )
        .background(Color.surfacePrimaryGrey, in: .capsule)
        .padding(.horizontal, horizontalSpacing)

        GeometryReader {
            let size = $0.size
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(panelList.indices, id: \.self) { index in
                        panelList[index]
                            .background(GeometryReader {gp -> Color in
                                DispatchQueue.main.async {
                                    self.panelHeight = gp.size.height
                                }
                                return Color.clear
                            })
                            .id(tabList[index])
                            .padding(.horizontal, horizontalSpacing)
                            .containerRelativeFrame(.horizontal)
                    }
                }
                .scrollTargetLayout()
                .offsetX { value in
                    let progress = -value / (size.width * CGFloat(tabList.count - 1))
                    tabProgress = max(min(progress, 1), 0)
                }
            }
            .scrollPosition(id: activeTabBinding)
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.paging)
            .scrollClipDisabled()
        }
        .frame(height: isUsePanelHeight == true ? panelHeight : .infinity)
    }

    private var activeTabBinding: Binding<Tab?> {
        Binding<Tab?>(
            get: {
                activeTab
            },
            set: { newValue in
                if let newValue = newValue, let tab = Tab.startEndTimes.first(where: { $0 == newValue }) {
                    activeTab = tab
                }
            }
        )
    }
}

struct PanelHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

#Preview {
    SegmentedTabView(
        tabList: Tab.startEndTimes,
        panelList: [
            AnyView(Text("View 1")),
            AnyView(Text("View 2"))
        ]
    )
}
