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

    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider()
        slider.minimumValue = Float(minValue)
        slider.maximumValue = Float(maxValue)
        slider.value = Float(value)
        slider.minimumTrackTintColor = UIColor(trackColor)
        
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
        uiView.value = Float(value)
        uiView.minimumTrackTintColor = UIColor(trackColor)
        
        let thumbImage = UIImage.circle(
            outerDiameter: thumbOuterDiameter,
            innerDiameter: thumbInnerDiameter,
            innerColor: UIColor(thumbInnerColor),
            outerColor: UIColor(thumbOuterColor)
        )
        uiView.setThumbImage(thumbImage, for: .normal)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(value: $value)
    }

    class Coordinator: NSObject {
        @Binding var value: Double

        init(value: Binding<Double>) {
            self._value = value
        }

        @objc func valueChanged(_ sender: UISlider) {
            value = Double(sender.value)
        }
    }
}

extension UIImage {
    static func circle(outerDiameter: CGFloat, innerDiameter: CGFloat, innerColor: UIColor, outerColor: UIColor) -> UIImage {
        let size = CGSize(width: outerDiameter, height: outerDiameter)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            let outerRect = CGRect(origin: .zero, size: size)
            context.cgContext.setFillColor(outerColor.cgColor)
            context.cgContext.fillEllipse(in: outerRect)

            let innerRect = CGRect(
                x: (outerDiameter - innerDiameter) / 2,
                y: (outerDiameter - innerDiameter) / 2,
                width: innerDiameter,
                height: innerDiameter
            )
            context.cgContext.setFillColor(innerColor.cgColor)
            context.cgContext.fillEllipse(in: innerRect)
        }
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
