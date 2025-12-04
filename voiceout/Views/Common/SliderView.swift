//
//  SliderView.swift
//  voiceout
//
//  Created by Yujia Yang on 3/7/25.
//

import SwiftUI

struct SliderView: UIViewRepresentable {
    @Binding var value: Double
    var minValue: Double = 0
    var maxValue: Double = 1
    var trackColor: Color = .surfaceBrandPrimary
    var thumbInnerColor: Color = .surfaceBrandPrimary
    var thumbOuterColor: Color = .surfacePrimaryGrey2
    var thumbInnerDiameter: CGFloat = 12
    var thumbOuterDiameter: CGFloat = 16
    var snapToIntegers: Bool = false // 是否对齐到整数

    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider()
        slider.minimumValue = Float(minValue)
        slider.maximumValue = Float(maxValue)
        slider.value = Float(value)
        
        // 创建8px高的track图片，使用实际颜色
        let trackHeight: CGFloat = 8
        let greyColor = UIColor(red: 0.92, green: 0.91, blue: 0.92, alpha: 1.0) // surfaceSurfacePrimaryGrey
        let minimumTrackImage = UIImage.track(height: trackHeight, color: UIColor(trackColor), cornerRadius: 20) // 左边绿色
        let maximumTrackImage = UIImage.track(height: trackHeight, color: greyColor, cornerRadius: 20) // 右边灰色
        slider.setMinimumTrackImage(minimumTrackImage, for: .normal)
        slider.setMaximumTrackImage(maximumTrackImage, for: .normal)
        
        let thumbImage = UIImage.circle(
            outerDiameter: thumbOuterDiameter,
            innerDiameter: thumbInnerDiameter,
            innerColor: UIColor(thumbInnerColor),
            outerColor: UIColor(thumbOuterColor)
        )
        slider.setThumbImage(thumbImage, for: .normal)

        slider.addTarget(
            context.coordinator,
            action: #selector(Coordinator.valueChanged(_:)),
            for: .valueChanged
        )

        return slider
    }

    func updateUIView(_ uiView: UISlider, context: Context) {
        // 如果启用整数对齐，确保值是对齐后的整数
        let finalValue = snapToIntegers ? round(value) : value
        uiView.value = Float(finalValue)
        
        // 创建8px高的track图片，使用实际颜色
        let trackHeight: CGFloat = 8
        let greyColor = UIColor(red: 0.92, green: 0.91, blue: 0.92, alpha: 1.0) // surfaceSurfacePrimaryGrey
        let minimumTrackImage = UIImage.track(height: trackHeight, color: UIColor(trackColor), cornerRadius: 20) // 左边绿色
        let maximumTrackImage = UIImage.track(height: trackHeight, color: greyColor, cornerRadius: 20) // 右边灰色
        uiView.setMinimumTrackImage(minimumTrackImage, for: .normal)
        uiView.setMaximumTrackImage(maximumTrackImage, for: .normal)
        
        let thumbImage = UIImage.circle(
            outerDiameter: thumbOuterDiameter,
            innerDiameter: thumbInnerDiameter,
            innerColor: UIColor(thumbInnerColor),
            outerColor: UIColor(thumbOuterColor)
        )
        uiView.setThumbImage(thumbImage, for: .normal)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(value: $value, snapToIntegers: snapToIntegers, minValue: minValue, maxValue: maxValue)
    }

    class Coordinator: NSObject {
        @Binding var value: Double
        let snapToIntegers: Bool
        let minValue: Double
        let maxValue: Double

        init(value: Binding<Double>, snapToIntegers: Bool, minValue: Double, maxValue: Double) {
            self._value = value
            self.snapToIntegers = snapToIntegers
            self.minValue = minValue
            self.maxValue = maxValue
        }

        @objc func valueChanged(_ sender: UISlider) {
            if snapToIntegers {
                // 对齐到最近的整数
                let rawValue = Double(sender.value)
                let roundedValue = round(rawValue)
                let clampedValue = max(minValue, min(maxValue, roundedValue))
                value = clampedValue
                // 更新 slider 的值以对齐到整数
                sender.value = Float(clampedValue)
            } else {
                // slider应该是丝滑的，不需要对齐到整数
                value = Double(sender.value)
            }
        }
    }
}

extension UIImage {
    static func circle(outerDiameter: CGFloat, innerDiameter: CGFloat, innerColor: UIColor, outerColor: UIColor) -> UIImage {
        // 如果需要绘制边框，需要更大的尺寸
        let borderWidth: CGFloat = 4
        let inset: CGFloat = -2
        // 边框向外扩展：inset -2 意味着边框在圆外2px，加上borderWidth 4px，总共需要额外6px
        let totalSize = outerDiameter + abs(inset) * 2 + borderWidth * 2
        let size = CGSize(width: totalSize, height: totalSize)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            // 绘制内圈（绿色填充，24x24）
            let innerRect = CGRect(
                x: (totalSize - innerDiameter) / 2,
                y: (totalSize - innerDiameter) / 2,
                width: innerDiameter,
                height: innerDiameter
            )
            context.cgContext.setFillColor(innerColor.cgColor)
            context.cgContext.fillEllipse(in: innerRect)
            
            // 绘制外圈（灰色边框，inset -2，lineWidth 4）
            // inset -2 意味着边框在innerRect的基础上向外扩展2px
            let strokeRect = innerRect.insetBy(dx: inset, dy: inset)
            context.cgContext.setStrokeColor(UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0).cgColor)
            context.cgContext.setLineWidth(borderWidth)
            context.cgContext.strokeEllipse(in: strokeRect)
        }
    }
    
    static func track(height: CGFloat, color: UIColor, cornerRadius: CGFloat) -> UIImage {
        // 创建一个可拉伸的track图片，高度为8px，带圆角
        let size = CGSize(width: max(cornerRadius * 2, 1), height: height)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            let rect = CGRect(origin: .zero, size: size)
            let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
            context.cgContext.setFillColor(color.cgColor)
            path.fill()
        }.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: cornerRadius, bottom: 0, right: cornerRadius), resizingMode: .stretch)
    }
}

struct SliderView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SliderView(value: .constant(0.5))
                .frame(height: 6)
                .padding()
        }
    }
}
