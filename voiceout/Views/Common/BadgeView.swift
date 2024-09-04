//
//  BadgeView.swift
//  voiceout
//
//  Created by J. Wu on 6/11/24.
//

import SwiftUI

struct BadgeView: View {

    @State private var isActive: Bool = false
    var text: String

    var body: some View {
        ButtonView(text: text,
                   action: {isActive.toggle()},
                   theme: isActive ? .badge : .bagdeInactive,
                   spacing: .xsmall,
                   fontSize: .small)
    }
}

#Preview {
    BadgeView(text: "青少年")
}
