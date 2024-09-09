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

extension View {
    func frameStyle() -> some View {
        self.modifier(FrameStyle())
    }
}
