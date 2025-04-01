//
//  ShadowModifier.swift
//  voiceout
//
//  Created by Yujia Yang on 3/28/25.
//

import SwiftUI

struct ShadowModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: Color(red: 0.36, green: 0.36, blue: 0.47).opacity(0.03),
                    radius: 8.95, x: 5, y: 3)
            .shadow(color: Color(red: 0.15, green: 0.15, blue: 0.25).opacity(0.08),
                    radius: 5.75, x: 2, y: 4)
    }
}

extension View {
    func imageShadow() -> some View {
        self.modifier(ShadowModifier())
    }
}
