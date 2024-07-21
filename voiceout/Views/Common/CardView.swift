//
//  CardView.swift
//  voiceout
//
//  Created by 阳羽佳 on 7/18/24.
//

import SwiftUI
struct CardModifiers {
    var padding: EdgeInsets
    var backgroundColor: Color
    var cornerRadius: CGFloat
    var shadow1Color: Color
    var shadow1Radius: CGFloat
    var shadow1X: CGFloat
    var shadow1Y: CGFloat
    var shadow2Color: Color
    var shadow2Radius: CGFloat
    var shadow2X: CGFloat
    var shadow2Y: CGFloat
}

struct CardView<Content: View>: View {
    let content: Content
    let modifiers: CardModifiers

    init(@ViewBuilder content: () -> Content, modifiers: CardModifiers) {
        self.content = content()
        self.modifiers = modifiers
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: modifiers.cornerRadius)
                .fill(modifiers.backgroundColor)
                .shadow(color: modifiers.shadow1Color, radius: modifiers.shadow1Radius, x: modifiers.shadow1X, y: modifiers.shadow1Y)
                .shadow(color: modifiers.shadow2Color, radius: modifiers.shadow2Radius, x: modifiers.shadow2X, y: modifiers.shadow2Y)
            
            content
                .padding(modifiers.padding)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}
