//
//  ToggleButtonView.swift
//  voiceout
//
//  Created by Yujia Yang on 4/14/25.
//

import SwiftUI

struct ToggleButtonConfig {
    var width: CGFloat
    var height: CGFloat
    var thumbSize: CGFloat
    var onColor: Color
    var offColor: Color
    var thumbColor: Color
    var animation: Animation
}

struct ToggleButtonView: ToggleStyle {
    let config: ToggleButtonConfig

    func makeBody(configuration: Configuration) -> some View {
        ZStack(alignment: configuration.isOn ? .trailing : .leading) {
            RoundedRectangle(cornerRadius: config.height / 2)
                .fill(configuration.isOn ? config.onColor : config.offColor)
                .frame(width: config.width, height: config.height)
            Circle()
                .fill(config.thumbColor)
                .frame(width: config.thumbSize, height: config.thumbSize)
                .padding(ViewSpacing.xxsmall)
                .shadow(radius: 1)
        }
        .onTapGesture {
            withAnimation(config.animation) {
                configuration.isOn.toggle()
            }
        }
        .frame(width: config.width, height: config.height) 
    }
}

extension ToggleButtonConfig {
    static var `default`: ToggleButtonConfig {
        ToggleButtonConfig(
            width: 52,
            height: 26,
            thumbSize: 22,
            onColor: .surfaceBrandPrimary,
            offColor: .grey200,
            thumbColor: .white,
            animation: .easeInOut(duration: 0.2)
        )
    }
}

#Preview {
    Toggle(isOn: .constant(true)) {
        EmptyView()
    }
    .toggleStyle(ToggleButtonView(config: .default))
}

