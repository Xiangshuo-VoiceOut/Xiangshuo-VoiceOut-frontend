//
//  Border.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 4/30/24.
//

import SwiftUI

enum CornerRadius {
    case full
    case medium
    case small
    case xxsmall
    
    var value: CGFloat{
        switch self{
        case .full:
            return 360
        case .medium:
            return 16
        case .small:
            return 8
        case .xxsmall:
            return 3
        }
    }
}

enum StrokeWidth {
    case width100
    case width200
    
    var value: CGFloat {
        switch self {
        case .width100:
            return 1.0
        case .width200:
            return 2.0
        }
    }
}

extension View {
    func cornerRadius(_ radius: CornerRadius, corners: UIRectCorner) -> some View {
        return clipShape(RoundedCorner(radius: radius.value, corners: corners))
    }
}
                  
struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        return Path(path.cgPath)
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
        case .small:
            cornerRadiusValue = 8
        case .xxsmall:
            cornerRadiusValue = 3
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
