//
//  BackgroundView.swift
//  voiceout
//
//  Created by J. Wu on 6/8/24.
//

import SwiftUI

enum BackgroundType {
    case surfacePrimaryGrey
    case brandTertiaryRadial
}

struct BackgroundView: View {
    var backgroundType: BackgroundType = .brandTertiaryRadial

    var body: some View {
        if case .brandTertiaryRadial = backgroundType {
            LinearGradient(
                stops: [
                    Gradient.Stop(color: Color.surfacePrimary, location: BGConstants.Background.startPointY),
                    Gradient.Stop(color: Color.brandTertiaryPeach, location: BGConstants.centerLocation),
                    Gradient.Stop(color: Color.brandTertiaryPeach, location: BGConstants.centerLocation),
                    Gradient.Stop(color: Color.surfacePrimary, location: BGConstants.Background.endPointY)
                ],
                startPoint: UnitPoint(
                    x: BGConstants.centerPoint,
                    y: BGConstants.Background.startPointY
                ),
                endPoint: UnitPoint(
                    x: BGConstants.centerPoint,
                    y: BGConstants.Background.endPointY
                )
            )
            .ignoresSafeArea()
        } else if case .surfacePrimaryGrey = backgroundType {
            Color.surfacePrimaryGrey2
                .ignoresSafeArea()
        }
    }
}

#Preview {
    BackgroundView()
}
