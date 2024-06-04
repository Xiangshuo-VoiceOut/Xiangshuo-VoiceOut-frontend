//
//  BackgroundView.swift
//  voiceout
//
//  Created by J. Wu on 6/8/24.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        LinearGradient (
            stops: [
                Gradient.Stop(color: Color(.surfacePrimary), location: BGConstants.Background.startPointY),
                Gradient.Stop(color: Color(.brandTertiary), location: BGConstants.centerLocation),
                Gradient.Stop(color: Color(.surfacePrimary), location: BGConstants.Background.endPointY)
            ],
            startPoint: UnitPoint(x: BGConstants.centerPoint, y: BGConstants.Background.startPointY), endPoint: UnitPoint(x: BGConstants.centerPoint, y: BGConstants.Background.endPointY)
            )
        .ignoresSafeArea()
    }
}

#Preview {
    BackgroundView()
}
