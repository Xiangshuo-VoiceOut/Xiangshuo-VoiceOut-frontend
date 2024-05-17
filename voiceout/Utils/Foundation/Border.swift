//
//  File.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 4/30/24.
//

import SwiftUI

enum CornerRadius {
    case full
    case medium
    
    var value: CGFloat{
        switch self{
        case .full:
            return 360
        case .medium:
            return 16
        }
    }
}

enum StrokeWidth {
    case width100
    case width200
}

extension View {
    func cornerRadius(_ style: CornerRadius) -> some View {
        return clipShape(RoundedRectangle(cornerRadius: style.value))
    }
}

extension RoundedRectangle {
    init(cornerRadius: CornerRadius) {
        let cornerRadiusValue: CGFloat
        
        switch cornerRadius {
        case .full:
            cornerRadiusValue = 360
        case .medium:
            cornerRadiusValue = 16
        }

        self.init(cornerRadius: cornerRadiusValue, style: .continuous)
    }
    
    func stroke(_ strokeWidth: StrokeWidth, _ color: Color? = .clear) -> some View {
        switch strokeWidth {
        case .width100:
            return self.stroke(color!, lineWidth: 1.0)
        case .width200:
            return self.stroke(color!, lineWidth: 2.0)
        }
    }

}
