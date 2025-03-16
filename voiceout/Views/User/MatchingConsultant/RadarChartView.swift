//
//  RadarChartView.swift
//  voiceout
//
//  Created by Yujia Yang on 1/30/25.
//

import SwiftUI

struct RadarChartView: View {
    let data: [RadarData]
    let maxValue: Double

    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height) * 0.9
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            let sides = data.count
            let angleStep = 2 * .pi / Double(sides)

            ZStack {
                ForEach(1...5, id: \.self) { step in
                    PolygonShape(sides: sides, scale: CGFloat(step) / 5)
                        .stroke(Color.borderHairline, lineWidth: 1)
                        .frame(width: size, height: size)
                        .position(center)
                }

                Path { path in
                    for (index, entry) in data.enumerated() {
                        let normalizedValue = max(0, min(1, entry.value / maxValue))
                        let angle = angleStep * Double(index) - .pi / 2
                        let pointX = center.x + CGFloat(normalizedValue) * (size / 2) * CGFloat(cos(angle))
                        let pointY = center.y + CGFloat(normalizedValue) * (size / 2) * CGFloat(sin(angle))

                        if index == 0 {
                            path.move(to: CGPoint(x: pointX, y: pointY))
                        } else {
                            path.addLine(to: CGPoint(x: pointX, y: pointY))
                        }
                    }
                    path.closeSubpath()
                }
                .fill(Color.brandSecondary.opacity(0.2))
                .overlay(
                    Path { path in
                        for (index, entry) in data.enumerated() {
                            let normalizedValue = max(0, min(1, entry.value / maxValue))
                            let angle = angleStep * Double(index) - .pi / 2
                            let pointX = center.x + CGFloat(normalizedValue) * (size / 2) * CGFloat(cos(angle))
                            let pointY = center.y + CGFloat(normalizedValue) * (size / 2) * CGFloat(sin(angle))

                            if index == 0 {
                                path.move(to: CGPoint(x: pointX, y: pointY))
                            } else {
                                path.addLine(to: CGPoint(x: pointX, y: pointY))
                            }
                        }
                        path.closeSubpath()
                    }
                    .stroke(Color.brandSecondary, lineWidth: 2.12405)
                )

                ForEach(0..<sides, id: \.self) { index in
                    let entry = data[index]
                    let normalizedValue = max(0, min(1, entry.value / maxValue))
                    let angle = angleStep * Double(index) - .pi / 2
                    let pointX = center.x + CGFloat(normalizedValue) * (size / 2) * CGFloat(cos(angle))
                    let pointY = center.y + CGFloat(normalizedValue) * (size / 2) * CGFloat(sin(angle))

                    Circle()
                        .fill(Color.brandSecondary)
                        .frame(width: 6.4, height: 6.4)
                        .position(x: pointX, y: pointY)
                }

                ForEach(0..<sides, id: \.self) { index in
                    let angle = angleStep * Double(index) - .pi / 2
                    let offset: CGFloat = size / 2 + 20
                    let labelX = center.x + offset * CGFloat(cos(angle))
                    let labelY = center.y + offset * CGFloat(sin(angle))

                    Text(data[index].dimension)
                        .foregroundColor(.grey300)
                        .font(.typography(.bodyXXSmall))
                        .kerning(0.3)
                        .frame(width: 60, height: 15)
                        .minimumScaleFactor(0.7)
                        .position(x: labelX, y: labelY)
                }
            }
        }
    }
}

struct PolygonShape: Shape {
    let sides: Int
    let scale: CGFloat

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let radius = min(rect.width, rect.height) / 2 * scale
        let angleStep = 2 * .pi / CGFloat(sides)

        var path = Path()
        for i in 0..<sides {
            let angle = angleStep * CGFloat(i) - .pi / 2
            let pointX = center.x + radius * cos(angle)
            let pointY = center.y + radius * sin(angle)

            if i == 0 {
                path.move(to: CGPoint(x: pointX, y: pointY))
            } else {
                path.addLine(to: CGPoint(x: pointX, y: pointY))
            }
        }
        path.closeSubpath()
        return path
    }
}

struct RadarData {
    let dimension: String
    let value: Double
}

#Preview {
    let sampleData = [
        RadarData(dimension: "负面情绪", value: 12.0),
        RadarData(dimension: "人际关系", value: 8.0),
        RadarData(dimension: "家庭关系", value: 9.0),
        RadarData(dimension: "亲子关系", value: 7.0),
        RadarData(dimension: "亲密关系", value: 12.0),
        RadarData(dimension: "自我探索", value: 8.0),
        RadarData(dimension: "个人疗愈", value: 9.0),
        RadarData(dimension: "强迫行为", value: 10.0),
        RadarData(dimension: "成瘾行为", value: 6.0),
        RadarData(dimension: "过滤条件", value: 8.0)
    ]
    let maxValue = sampleData.map { $0.value }.max() ?? 1.0
    return RadarChartView(data: sampleData, maxValue: maxValue)
        .frame(width: 300, height: 300)
}
