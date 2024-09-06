//
//  BackgroundView.swift
//  voiceout
//
//  Created by J. Wu on 6/8/24.
//

import SwiftUI

enum BackgroundType {
    case linear
    case radial
}

struct BackgroundView: View {
    var backgroundType: BackgroundType = .radial

    var body: some View {
        if case .radial = backgroundType {
            LinearGradient(
                stops: [
                    Gradient.Stop(color: Color.surfacePrimary, location: BGConstants.Background.startPointY),
                    Gradient.Stop(color: Color.brandTertiary, location: BGConstants.centerLocation),
                    Gradient.Stop(color: Color.brandTertiary, location: BGConstants.centerLocation),
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
        } else {
            LinearGradient(
                stops: [
                    Gradient.Stop(color: .brandTertiary, location: 0),
                    Gradient.Stop(color: .brandTertiary, location: 0.63),
                    Gradient.Stop(color: .surfacePrimary, location: 1)
                ],
                startPoint: UnitPoint(x: 0.5, y: 0.05),
                endPoint: UnitPoint(x: 0.5, y: 0.94)
            )
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
            .ignoresSafeArea()
        }
    }
}

#Preview {
    BackgroundView()
}
