//
//  ViewModifiers.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 9/6/24.
//

import SwiftUI

struct FrameStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(ViewSpacing.large)
            .background(Color.surfacePrimary)
            .cornerRadius(CornerRadius.medium.value)
            .shadow(
                color: Color(.grey200),
                radius: CornerRadius.xxsmall.value
            )
            .padding(.horizontal, ViewSpacing.xlarge)
    }
}

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(ViewSpacing.medium)
            .background(Color.surfacePrimary)
            .cornerRadius(CornerRadius.medium.value)
    }
}

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension View {
    func frameStyle() -> some View {
        self.modifier(FrameStyle())
    }

    // profile cards style
    func cardStyle() -> some View {
        self.modifier(CardStyle())
    }

    @ViewBuilder
    func offsetX(completion: @escaping (CGFloat) -> Void) -> some View {
        self
            .overlay {
                GeometryReader {
                    let minX = $0.frame(in: .scrollView(axis: .horizontal)).minX

                    Color.clear
                        .preference(key: OffsetKey.self, value: minX)
                        .onPreferenceChange(OffsetKey.self, perform: completion)
                }
            }
    }
}
