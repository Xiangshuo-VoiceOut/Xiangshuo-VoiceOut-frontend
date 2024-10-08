//
//  BadgeView.swift
//  voiceout
//
//  Created by J. Wu on 6/11/24.
//

import SwiftUI

struct BadgeView: View {
    var isActive: Bool
    var text: String

    var body: some View {
        ButtonView(
            text: text,
            action: {},
            theme: isActive ? .action : .bagdeInactive,
            spacing: .xsmall,
            fontSize: .small
        )
    }
}

#Preview {
    BadgeView(isActive: false, text: "青少年")
}
