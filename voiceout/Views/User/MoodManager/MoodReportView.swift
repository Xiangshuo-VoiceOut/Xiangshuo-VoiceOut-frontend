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
    @State private var totalEntries: Int = 0
    @State private var moodPercentages: [String: Double] = [:]
    @State private var moodOccurrences: [String: Int] = [:]
    @State var period: String = "week"
    
    var body: some View {
        GeometryReader { geometry in
            let availableWidth = geometry.size.width
            let ringContainerHeight = availableWidth * 0.7
            let fixedPanelHeight = ringContainerHeight
            
            VStack(spacing: ViewSpacing.medium) {
                HStack {
                    Spacer(minLength: 0)
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
                            .stroke(Color.surfacePrimaryGrey, lineWidth: StrokeWidth.width200.value)
                            .frame(width: ringContainerHeight - 32, height: ringContainerHeight - 32)
                        
                        arcsView(width: ringContainerHeight)
                        
                        VStack {
                            let dominantMood = moodSegments.max(by: { $0.fraction < $1.fraction })?.mood.lowercased() ?? "angry"
                            
                            Image(dominantMood)
                                .resizable()
                                .scaledToFit()
                                .padding(.horizontal, ViewSpacing.xsmall)
                                .padding(.vertical, ringContainerHeight * 0.02)
                                .frame(width: ringContainerHeight * 0.7, height: ringContainerHeight * 0.7)
                        }
                    }
                    .frame(width: ringContainerHeight, height: ringContainerHeight)

                    Spacer(minLength: 0)
                }
                
                VStack(spacing: ViewSpacing.medium) {
                    ForEach(moodSegments.sorted(by: { $0.fraction > $1.fraction }), id: \.id) { segment in
                        HStack {
                            VStack{
                                Circle()
                                    .fill(moodColors[segment.mood.lowercased()] ?? Color(red: 0.91, green: 0.92, blue: 0.95))
                                    .frame(width: 48, height: 47)
                                    .overlay(
                                        Image(segment.mood.lowercased())
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 40, height: 23)
                                    )
                            }
                            .padding(.leading,ViewSpacing.small)
                            .padding(.trailing,ViewSpacing.base)
                            
                            VStack(alignment: .leading, spacing: ViewSpacing.xsmall) {
                                Text(imageToChinese[segment.mood.lowercased()] ?? segment.mood.capitalized)
                                    .font(Font.typography(.bodyMedium))
                                    .foregroundColor(.textPrimary)
                                
                                let displayPeriod = (period == "week") ? "这一周" : "这一月"
                                let times = moodOccurrences[segment.mood.lowercased()] ?? 0
                                Text("\(displayPeriod)，我感到 \(times) 次 \(imageToChinese[segment.mood] ?? segment.mood.capitalized)")
                                    .font(Font.typography(.bodySmall))
                                    .foregroundColor(.textSecondary)
                            }
                            .padding(.vertical,2 * ViewSpacing.betweenSmallAndBase)
                            
                            Spacer()
                            
                            ZStack {
                                Circle()
                                    .stroke(
                                        Color(red: 0.91, green: 0.92, blue: 0.95),
                                        lineWidth: 4
                                    )
                                    .frame(width: 60, height: 60)
                                Circle()
                                    .trim(from: 0, to: CGFloat(segment.fraction))
                                    .stroke(
                                        moodColors[segment.mood.lowercased()] ?? .gray,
                                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                                    )
                                    .rotationEffect(.degrees(-135))
                                    .frame(width: 60, height: 60)
                                
                                Text(String(format: "%.1f%%", segment.fraction * 100))
                                    .font(Font.typography(.bodyLarge))
                                    .foregroundColor(Color(red: 0.14, green: 0.2, blue: 0.4))
                            }
                            .padding(.trailing,ViewSpacing.medium)
                        }
                        .foregroundColor(.clear)
                        .frame(height: 86)
                        .background(Color.surfacePrimary)
                        .cornerRadius(10)
                        .shadow(color: Color(red: 0.35, green: 0.46, blue: 0.65).opacity(0.04), radius: 10, x: 2, y: 12)
                    }
                }
                .padding(.horizontal, ViewSpacing.medium)
                .padding(.top, ViewSpacing.small)
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.surfacePrimaryGrey2)
        .onAppear {
            fetchMoodStatsFromServer(for: period)
        }
    }
    
    private func fetchMoodStatsFromServer(for period: String) {
        MoodManagerService.shared.fetchMoodStats(period: period) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let statsResponse):
                    self.totalEntries = statsResponse.total_entries
                    self.moodPercentages = statsResponse.mood_percentages
                    var occurrencesDict: [String: Int] = [:]
                    for (mood, percent) in statsResponse.mood_percentages {
                        let count = Int( round( Double(statsResponse.total_entries) * (percent / 100.0) ) )
                        occurrencesDict[mood.lowercased()] = count
                    }
                    self.moodOccurrences = occurrencesDict
                    
                case .failure(let error):
                    print("Failed to obtain emotion statistics: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func arcsView(width: CGFloat) -> some View {
        let total = moodSegments.map({ CGFloat($0.fraction) }).reduce(0, +)
        if total == 0 {
            return AnyView(EmptyView())
        }
        
        let normalizedSegments = moodSegments.map { seg -> MoodSegment in
            MoodSegment(mood: seg.mood, fraction: seg.fraction / Double(total))
        }
        
        var arcs: [(start: CGFloat, end: CGFloat, mood: String)] = []
        var start: CGFloat = 0
        
        for (i, seg) in normalizedSegments.enumerated() {
            let fraction = CGFloat(seg.fraction)
            let end = start + fraction
            
            let gap: CGFloat = 0.015
            let arcSize = end - start
            let arcEnd = (i == normalizedSegments.count - 1)
            ? 1.0
            : (arcSize > 0.02 ? max(start, end - gap) : end)
            
            arcs.append((start, arcEnd, seg.mood))
            start = end
        }
        
        let view = ZStack {
            ForEach(arcs.indices, id: \.self) { i in
                let (s, e, moodName) = arcs[i]
                let color = moodColors[moodName.lowercased()] ?? Color.surfacePrimaryGrey
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
        .frame(width: width, height: width)
        return AnyView(view)
    }
}

struct MoodReportView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleSegments = [
            MoodSegment(mood: "happy", fraction: 0.1),
            MoodSegment(mood: "scare", fraction: 0.2),
            MoodSegment(mood: "sad", fraction: 0.1),
            MoodSegment(mood: "guilt", fraction: 0.15),
            MoodSegment(mood: "calm", fraction: 0.1),
            MoodSegment(mood: "envy", fraction: 0.1),
            MoodSegment(mood: "shame", fraction: 0.1),
            MoodSegment(mood: "angry", fraction: 0.15),
        ]
        
        return Group {
            MoodReportView(
                moodSegments: sampleSegments,
                lastDiary: nil
            )
            MoodReportView(
                moodSegments: sampleSegments,
                lastDiary: nil,
                period: "month"
            )
        }
    }
}
