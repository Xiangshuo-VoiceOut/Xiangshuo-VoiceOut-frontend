//
//  RotatingWheelView.swift
//  voiceout
//
//  Created by Yujia Yang on 3/6/25.
//

import SwiftUI

struct RotatingWheelView2: View {
    @State private var rotationAngle: Angle = .zero
    @State private var lastRotation: Angle = .zero
    @Binding var selectedImage: String
    
    private let imageNames = ["happy", "scare", "sad", "guilt", "calm", "envy", "anxiety", "angry"]
    private let numberOfImages = 8
    private var comingSoonMoods: [String] {
        ["happy", "calm", "angry", "envy"]
    }
    private func moodLabelColor(for mood: String) -> Color {
        comingSoonMoods.contains(mood.lowercased()) ? .textLight : .surfaceBrandPrimary
    }

    var body: some View {
        GeometryReader { geometry in
            let scale = geometry.size.width / 430
            let center = CGPoint(x: geometry.size.width / 1.6, y: geometry.size.height / 2)
            
            ZStack {
                HStack(alignment: .center, spacing: ViewSpacing.medium) {
                    
                    moodLabels(scale: scale)
                }
                
                moodWheel(geometry: geometry, scale: scale, center: center)
                
                Image("subtract")
                    .resizable()
                    .frame(width: 40 * scale, height: 15 * scale)
                    .position(x: geometry.size.width - 32 * scale, y: center.y)
                    .zIndex(3)
            }
            .background(Color.surfaceBrandTertiaryBlue)
            .gesture(dragGesture(center: center))
        }
    }
    
    private func moodLabels(scale: CGFloat) -> some View {
        VStack(alignment: .center, spacing: 2 * ViewSpacing.large) {
            Text(imageToChinese[imageForTargetAngle(225)] ?? "")
                .font(Font.typography(.bodyMedium))
                .foregroundColor(moodLabelColor(for: imageForTargetAngle(225)))
            Text(imageToChinese[imageForTargetAngle(180)] ?? "")
                .font(Font.typography(.headerSmall))
                .foregroundColor(moodLabelColor(for: imageForTargetAngle(180)))
            Text(imageToChinese[imageForTargetAngle(135)] ?? "")
                .font(Font.typography(.bodyMedium))
                .foregroundColor(moodLabelColor(for: imageForTargetAngle(135)))
        }
        .padding(.top,3 * ViewSpacing.base)
        .padding(.leading, 16 * scale)
        .frame(maxWidth: .infinity, alignment: .leading)
        .zIndex(2)
    }
    
    private func moodWheel(geometry: GeometryProxy, scale: CGFloat, center: CGPoint) -> some View {
        ZStack {
            Circle()
                .fill(Color.surfaceBrandPrimary.opacity(0.2))
                .frame(width: 522 * scale, height: 522 * scale)
            
            ForEach(imageNames, id: \.self) { name in
                moodImage(name: name, scale: scale, center: center)
            }
        }
        .frame(width: geometry.size.width * 0.8)
        .offset(x: geometry.size.width * 0.65)
    }
    
    private func moodImage(name: String, scale: CGFloat, center: CGPoint) -> some View {
        let isSelected = name == imageForTargetAngle(180)
        return Image(name)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(
                width: isSelected ? 214 * scale : 166 * scale,
                height: isSelected ? 124 * scale : 97 * scale
            )
            .modifier(SelectedImageModifier(isSelected: isSelected, scale: scale))
            .position(positionFor(
                angle: getAngleForImage(name) + rotationAngle,
                radius: 261 * scale,
                center: center
            ))
    }
    
    private func dragGesture(center: CGPoint) -> some Gesture {
        DragGesture()
            .onChanged { value in
                let startAngle = atan2(value.startLocation.y - center.y, value.startLocation.x - center.x)
                let currentAngle = atan2(value.location.y - center.y, value.location.x - center.x)
                rotationAngle = lastRotation + Angle(radians: Double(currentAngle - startAngle))
            }
            .onEnded { _ in
                withAnimation(.spring(response: 0.5, dampingFraction: 0.5)) {
                    let snappedDegrees = round(rotationAngle.degrees / 45) * 45
                    rotationAngle = Angle(degrees: snappedDegrees)
                    lastRotation = rotationAngle
                    selectedImage = imageForTargetAngle(180)
                }
            }
    }
    
    private func getAngleForImage(_ name: String) -> Angle {
        guard let index = imageNames.firstIndex(of: name) else { return .zero }
        return .degrees(Double(index) * 360 / Double(numberOfImages))
    }
    
    private func positionFor(angle: Angle, radius: CGFloat, center: CGPoint) -> CGPoint {
        CGPoint(
            x: center.x + radius * cos(CGFloat(angle.radians)),
            y: center.y + radius * sin(CGFloat(angle.radians))
        )
    }
    
    private func imageForTargetAngle(_ target: Double) -> String {
        imageNames.min(by: {
            let angle1 = normalizeAngle(getAngleForImage($0).degrees + rotationAngle.degrees)
            let angle2 = normalizeAngle(getAngleForImage($1).degrees + rotationAngle.degrees)
            return abs(normalizeAngle(angle1 - target)) < abs(normalizeAngle(angle2 - target))
        }) ?? imageNames[0]
    }
    
    private func normalizeAngle(_ degrees: Double) -> Double {
        (degrees.truncatingRemainder(dividingBy: 360) + 360).truncatingRemainder(dividingBy: 360)
    }
}

private struct SelectedImageModifier: ViewModifier {
    let isSelected: Bool
    let scale: CGFloat
    
    func body(content: Content) -> some View {
        content
            .shadow(
                color: isSelected ? Color(red: 0.36, green: 0.36, blue: 0.47).opacity(0.03) : .clear,
                radius: isSelected ? 8.95 * scale : 0,
                x: 5 * scale,
                y: 3 * scale
            )
            .shadow(
                color: isSelected ? Color(red: 0.15, green: 0.15, blue: 0.25).opacity(0.08) : .clear,
                radius: isSelected ? 5.75 * scale : 0,
                x: 2 * scale,
                y: 4 * scale
            )
    }
}

struct RotatingWheelView2_Previews: PreviewProvider {
    static var previews: some View {
        RotatingWheelView2(selectedImage: .constant("calm"))
    }
}
