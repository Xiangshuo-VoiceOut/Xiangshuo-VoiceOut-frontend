//
//  MoodReportView.swift
//  voiceout
//
//  Created by Yujia Yang on 3/21/25.
//

import SwiftUI

struct MoodReportView: View {
    let moodSegments: [MoodSegment]
    let lastDiary: DiaryEntry?
    let ringLineWidth: CGFloat = ViewSpacing.base
    
    var body: some View {
        GeometryReader { geometry in
            let availableWidth = geometry.size.width
            let ringContainerHeight = availableWidth * 0.7
            let fixedPanelHeight = ringContainerHeight
            
            VStack(spacing: ViewSpacing.medium) {
                ZStack(alignment: .bottom) {
                    ZStack {
                        Circle()
                            .fill(Color.surfacePrimaryGrey)
                            .frame(width: ringContainerHeight, height: ringContainerHeight)
                        
                        Circle()
                            .fill(Color.surfacePrimaryGrey2)
                            .frame(width: ringContainerHeight - 12, height: ringContainerHeight - 12)
                            .padding(.top, ringContainerHeight * 0.05)
                        
                        Circle()
                            .fill(Color.surfacePrimaryGrey2)
                            .stroke(Color.surfacePrimaryGrey, lineWidth: 2)
                            .frame(width: ringContainerHeight - 32, height: ringContainerHeight - 32)
                        
                        arcsView(width: ringContainerHeight)
                        
                        VStack {
                            if let diary = lastDiary {
                                Image(diary.moodType.lowercased())
                                    .resizable()
                                    .scaledToFit()
                                    .padding(.horizontal, ViewSpacing.xsmall)
                                    .padding(.vertical, ringContainerHeight * 0.02)
                                    .frame(width: ringContainerHeight * 0.7, height: ringContainerHeight * 0.7)
                            } else {
                                Image("angry")
                                    .resizable()
                                    .scaledToFit()
                                    .padding(.horizontal, ViewSpacing.xsmall)
                                    .padding(.vertical, ringContainerHeight * 0.02)
                                    .frame(width: ringContainerHeight * 0.7, height: ringContainerHeight * 0.7)
                            }
                        }
                    }
                    .frame(width: ringContainerHeight, height: ringContainerHeight)
                    .overlay(
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [.clear, Color.surfacePrimaryGrey2]),
                                    startPoint: .center,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: ringContainerHeight, height: ringContainerHeight + 16)
                            .allowsHitTesting(false)
                    )
                    
                    Button(action: {
                    }) {
                        Text("👑升级为 PRO 查看分布报告")
                            .foregroundColor(.textInvert)
                            .font(Font.typography(.bodyMedium))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .frame(height: 44)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.surfaceBrandPrimary,
                                Color.surfaceBrandSecondary
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(Capsule())
                    .offset(y: -ringContainerHeight * 0.1)
                }
            }
            .frame(height: fixedPanelHeight)
        }
        .padding(.horizontal, ViewSpacing.medium)
        .background(Color.surfacePrimaryGrey2)
    }
    
    private func arcsView(width: CGFloat) -> some View {
        let gap: CGFloat = 0.015
        let total = moodSegments.map({ CGFloat($0.fraction) }).reduce(0, +)
        
        if total == 0 {
            return AnyView(EmptyView())
        }
        
        let normalizedSegments = moodSegments.map { segment in
            MoodSegment(mood: segment.mood, fraction: segment.fraction / Double(total))
        }
        
        var arcs: [(start: CGFloat, end: CGFloat, mood: String)] = []
        var start: CGFloat = 0
        
        for (i, seg) in normalizedSegments.enumerated() {
            let fraction = CGFloat(seg.fraction)
            let end = start + fraction
            
            let arcEnd: CGFloat
            if i == normalizedSegments.count - 1 {
                arcEnd = 1.0
            } else {
                let arcSize = end - start
                arcEnd = arcSize > 0.02 ? max(start, end - gap) : end
            }
            
            arcs.append((start, arcEnd, seg.mood))
            start = end
        }
        
        let view = ZStack {
            ForEach(arcs.indices, id: \.self) { i in
                let (s, e, mood) = arcs[i]
                let color = moodColors[mood.lowercased()] ?? Color.surfacePrimaryGrey
                Circle()
                    .trim(from: s, to: e)
                    .stroke(
                        color,
                        style: StrokeStyle(
                            lineWidth: ringLineWidth,
                            lineCap: .round,
                            lineJoin: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))
            }
        }
        return AnyView(view.frame(width: width, height: width))
    }
}

struct MoodReportView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MoodReportView(
                moodSegments: [
                    MoodSegment(mood: "happy", fraction: 0.125),
                    MoodSegment(mood: "scare", fraction:0.125),
                    MoodSegment(mood: "sad", fraction: 0.125),
                    MoodSegment(mood: "guilt", fraction: 0.125),
                    MoodSegment(mood: "calm", fraction: 0.125),
                    MoodSegment(mood: "envy", fraction: 0.125),
                    MoodSegment(mood: "shame", fraction: 0.125),
                    MoodSegment(mood: "angry", fraction: 0.125)
                ],
                lastDiary: nil
            )
        }
    }
}
