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
