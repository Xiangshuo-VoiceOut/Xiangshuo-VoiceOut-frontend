//
//  MoodCalendarView.swift
//  voiceout
//
//  Created by Yujia Yang on 3/13/25.
//

import SwiftUI

let moodColors: [String: Color] = [
    "angry":Color(red: 0.94, green: 0.54, blue: 0.54),
    "sad": Color(red: 0.66, green: 0.84, blue: 0.97),
    "scare": Color(red: 0.65, green: 0.83, blue: 0.82),
    "envy": Color(red: 0.98, green: 0.77, blue: 0.81),
    "guilt": Color(red: 0.76, green: 0.82, blue: 0.69),
    "calm": Color(red: 0.99, green: 0.83, blue: 0.3),
    "happy": Color(red: 0.99, green: 0.83, blue: 0.3),
    "shame": Color(red: 0.83, green: 0.75, blue: 0.95)
]

struct MoodSegment: Identifiable {
    let id = UUID()
    let mood: String
    let fraction: Double
    
    static func normalizedSegments(_ segments: [MoodSegment]) -> [MoodSegment] {
        let total = segments.reduce(0) { $0 + $1.fraction }
        guard total > 0 else { return [] }
        return segments.map {
            MoodSegment(mood: $0.mood, fraction: $0.fraction / total)
        }
    }
}

struct MoodCalendarView: View {
    @EnvironmentObject var router: RouterModel
    @State private var selectedDate: Date = Date()
    @State private var selectedDay: Int? = nil
    @State private var activeTab: Tab? = Tab.startEndTimes.first(where: { $0.id == "week" })
    @State private var highlightedDates: Set<Int> = []
    @State private var visibleMoodDates: Set<Int> = []
    @State private var moodSegmentsWeek: [MoodSegment] = []
    @State private var moodSegmentsMonth: [MoodSegment] = []
    @State private var calendarData: [(year: Int, month: Int, day: Int, emotion: String)] = []
    @State private var allEntries: [DiaryEntry] = []
    
    let calendar = Calendar.current
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.surfacePrimaryGrey2.ignoresSafeArea()
            
            VStack(spacing: 0) {
                StickyHeaderView(
                    title: "mood_cloud_title",
                    leadingComponent: AnyView(BackButtonView().foregroundColor(.grey500)),
                    trailingComponent: AnyView(
                        Button(action: { router.navigateBack() }) {
                            Image("close")
                                .frame(width: 24, height: 24)
                                .foregroundColor(.grey500)
                        }
                    ),
                    backgroundColor: Color.surfacePrimaryGrey2
                )
                .frame(maxWidth: .infinity, minHeight: 44)
                
                GeometryReader { geo in
                    ScrollView {
                        VStack(spacing: ViewSpacing.medium) {
                            MoodMonthHeader(selectedDate: $selectedDate)
                            MoodCalendarGrid(
                                selectedDate: $selectedDate,
                                selectedDay: $selectedDay,
                                calendarData: calendarData,
                                allDiaries: allEntries,
                                highlightedDates: $highlightedDates,
                                visibleMoodDates: $visibleMoodDates,
                                moodColors: moodColors
                            )
                            
                            let compsSelected = Calendar.current.dateComponents([.year, .month, .day], from: selectedDate)
                            let diariesForSelectedDay = allEntries.filter { diary in
                                let compsDiary = Calendar.current.dateComponents([.year, .month, .day], from: diary.timestamp)
                                return compsDiary.year == compsSelected.year &&
                                compsDiary.month == compsSelected.month &&
                                compsDiary.day == compsSelected.day
                            }
                            let lastDiaryOfSelectedDay = diariesForSelectedDay.sorted { $0.timestamp < $1.timestamp }.last
                            let filteredTabs = Tab.startEndTimes.filter { $0.id == "week" || $0.id == "month" }
                            
                            SegmentedTabView(
                                tabList: filteredTabs,
                                panelList: [
                                    AnyView(MoodReportView(
                                        moodSegments: MoodSegment.normalizedSegments(moodSegmentsWeek),
                                        lastDiary: lastDiaryOfSelectedDay
                                    )),
                                    AnyView(MoodReportView(
                                        moodSegments: MoodSegment.normalizedSegments(moodSegmentsMonth),
                                        lastDiary: lastDiaryOfSelectedDay
                                    ))
                                ],
                                activeTab: activeTab
                            )
                            .padding(.top, ViewSpacing.large)
                            .frame(minWidth: 300)
                            .zIndex(2)
                        }
                        .padding(.horizontal,ViewSpacing.medium)
                        .frame(minHeight: geo.size.height + 9 * ViewSpacing.betweenSmallAndBase)
                        .padding(.bottom, 9 * ViewSpacing.betweenSmallAndBase)
                    }
                }
            }
            .padding(.bottom, ViewSpacing.medium)
        }
        .onAppear {
            let startDate = ISO8601DateFormatter().date(from: "2025-01-01T00:00:00Z")!
            let endDate = ISO8601DateFormatter().date(from: "2025-12-31T23:59:59Z")!
            
            MoodManagerService.shared.fetchDiaryEntries(startDate: startDate, endDate: endDate, page: 1, limit: 100) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        let entries = response.data.entries
                        self.allEntries = entries
                        var newCalendarData: [(Int, Int, Int, String)] = []
                        for diary in entries {
                            let comps = Calendar.current.dateComponents([.year, .month, .day], from: diary.timestamp)
                            let mood = diary.moodType.lowercased()
                            if let y = comps.year, let m = comps.month, let d = comps.day {
                                newCalendarData.append((y, m, d, mood))
                            }
                        }
                        self.calendarData = newCalendarData
                        self.computeWeekAndMonth()
                    case .failure(let error):
                        print(">>> Current selectedDate:", selectedDate)
                    }
                }
            }
            
            MoodManagerService.shared.fetchMoodStats(period: "week") { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let stats):
                        let total = stats.mood_percentages.values.reduce(0, +)
                        self.moodSegmentsWeek = stats.mood_percentages.map {
                            MoodSegment(mood: $0.key.lowercased(),
                                        fraction: total > 0 ? $0.value / total : 0)
                        }
                    case .failure(let error):
                        print("Failed to obtain weekly statistics:", error.localizedDescription)
                    }
                }
            }
            
            MoodManagerService.shared.fetchMoodStats(period: "month") { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let stats):
                        self.moodSegmentsMonth = stats.mood_percentages.map {
                            MoodSegment(mood: $0.key.lowercased(), fraction: $0.value / 100.0)
                        }
                    case .failure(let error):
                        print("Failed to obtain monthly statistics.:", error.localizedDescription)
                    }
                }
            }
        }
    }
    
    private func computeWeekAndMonth() {
        moodSegmentsWeek = computeSegments(for: 7)
        moodSegmentsMonth = computeSegments(for: 30)
    }
    
    private func computeSegments(for rangeDays: Int) -> [MoodSegment] {
        let systemDate = Date()
        guard let startDate = Calendar.current.date(byAdding: .day, value: -rangeDays, to: systemDate) else {
            return []
        }
        
        let dataInRange = calendarData.filter { entry in
            guard let entryDate = Calendar.current.date(from: DateComponents(year: entry.0, month: entry.1, day: entry.2)) else { return false }
            return entryDate >= startDate && entryDate <= systemDate
        }
        
        let grouped = Dictionary(grouping: dataInRange, by: { $0.3 }).mapValues { $0.count }
        let total = Double(dataInRange.count)
        
        if total == 0 { return [] }
        
        let sum = grouped.values.reduce(0, +)
        let normalizationFactor = Double(sum) / total
        
        return grouped.map {
            MoodSegment(mood: $0.key, fraction: Double($0.value) / Double(sum))
        }.sorted { $0.mood < $1.mood }
    }
}

struct MoodMonthHeader: View {
    @Binding var selectedDate: Date
    let calendar = Calendar.current
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月"
        return formatter
    }()

    var body: some View {
        HStack(alignment: .center) {
            Text(dateFormatter.string(from: selectedDate))
                .font(Font.typography(.bodyLargeEmphasis))
                .multilineTextAlignment(.center)
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            HStack(alignment: .center, spacing: ViewSpacing.medium) {
                Button(action: {
                    selectedDate = calendar.date(byAdding: .month, value: -1, to: selectedDate) ?? selectedDate
                }) {
                    Image("left-arrow")
                        .frame(width: 24, height: 24)
                }
                Button(action: {
                    selectedDate = calendar.date(byAdding: .month, value: 1, to: selectedDate) ?? selectedDate
                }) {
                    Image("right-arrow")
                        .frame(width: 24, height: 24)
                }
            }
            .foregroundColor(.grey500)
        }
    }
}

struct MoodCalendarGrid: View {
    @Binding var selectedDate: Date
    @Binding var selectedDay: Int?

    let calendarData: [(year: Int, month: Int, day: Int, emotion: String)]
    let allDiaries: [DiaryEntry]
    @Binding var highlightedDates: Set<Int>
    @Binding var visibleMoodDates: Set<Int>
    let moodColors: [String: Color]
    let calendar = Calendar.current

    @EnvironmentObject var router: RouterModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            calendarWeekdayHeader()
            Rectangle()
                .fill(Color.surfacePrimaryGrey)
                .frame(height: 2)
                .padding(.top, ViewSpacing.medium)
            calendarDayGrid()
        }
    }

    private func calendarWeekdayHeader() -> some View {
        HStack {
            ForEach(["weekday_sun", "weekday_mon", "weekday_tue", "weekday_wed", "weekday_thu", "weekday_fri", "weekday_sat"], id: \.self) { dayKey in
                Text(LocalizedStringKey(dayKey))
                    .font(Font.typography(.bodyMediumEmphasis))
                    .frame(maxWidth: .infinity)
            }
        }
    }

    private func calendarDayGrid() -> some View {
        let systemDate = Date()
        let systemYear = calendar.component(.year, from: systemDate)
        let systemMonth = calendar.component(.month, from: systemDate)
        let systemDay = calendar.component(.day, from: systemDate)
        let displayedYear = calendar.component(.year, from: selectedDate)
        let displayedMonth = calendar.component(.month, from: selectedDate)
        let daysArray = getMonthDays(for: selectedDate)

        return LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: ViewSpacing.base) {
            ForEach(Array(daysArray.enumerated()), id: \.offset) { _, day in
                if let dayValue = day {
                    calendarDayCell(
                        dayValue: dayValue,
                        systemYear: systemYear,
                        systemMonth: systemMonth,
                        systemDay: systemDay,
                        displayedYear: displayedYear,
                        displayedMonth: displayedMonth
                    )
                } else {
                    Text("")
                        .frame(width: 48, height: 48)
                }
            }
        }
    }

    private func calendarDayCell(dayValue: Int, systemYear: Int, systemMonth: Int, systemDay: Int, displayedYear: Int, displayedMonth: Int) -> some View {
        let isToday = (displayedYear == systemYear && displayedMonth == systemMonth && dayValue == systemDay)
        let isPast = {
            if displayedYear < systemYear { return true }
            if displayedYear > systemYear { return false }
            if displayedMonth < systemMonth { return true }
            if displayedMonth > systemMonth { return false }
            return dayValue <= systemDay
        }()
        let moodEntry = calendarData.first {
            $0.year == displayedYear && $0.month == displayedMonth && $0.day == dayValue
        }
        let moodColor = moodEntry.flatMap { moodColors[$0.emotion.lowercased()] }

        return ZStack {
            if let color = moodColor {
                Circle()
                    .fill(color)
            }
            Text("\(dayValue)")
                .font(Font.typography(.bodyMedium))
                .foregroundColor(isPast ? .textPrimary : .textLight)
            if isToday {
                Rectangle()
                    .fill(Color.surfaceBrandPrimary)
                    .frame(width: 16, height: 4)
                    .offset(y: ViewSpacing.xsmall + ViewSpacing.large)
            }
        }
        .frame(width: 48, height: 48)
        .onTapGesture {
            if isPast {
                let dayDiaries = allDiaries.filter { diary in
                    let comps = calendar.dateComponents([.year, .month, .day], from: diary.dateTime)
                    return comps.year == displayedYear &&
                        comps.month == displayedMonth &&
                        comps.day == dayValue
                }
                if !dayDiaries.isEmpty {
                    router.navigateTo(.textJournalView(diaries: dayDiaries))
                }
            }
        }
    }

    private func getMonthDays(for date: Date) -> [Int?] {
        let components = calendar.dateComponents([.year, .month], from: date)
        guard let firstDayOfMonth = calendar.date(from: components),
              let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth) else {
            return []
        }
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth) - 1
        return Array(repeating: nil, count: firstWeekday) + Array(range)
    }
}

#Preview {
    MoodCalendarView()
        .environmentObject(RouterModel())
}
