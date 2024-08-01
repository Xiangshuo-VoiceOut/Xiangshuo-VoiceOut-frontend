//
//  TherapistScheduleViewModel.swift
//  voiceout
//
//  Created by Yujia Yang on 7/28/24.
//

import SwiftUI
import Combine

class TherapistScheduleViewModel: ObservableObject {
    @Published var days: [Day] = []
    @Published var selectedDate: Date?
    @Published var currentDate: Date = Date()
    @Published var timeSlots: [Slot] = []

    private var cancellables = Set<AnyCancellable>()

    init() {
        loadTestData()
        // fetchAvailabilities()
    }

    func fetchAvailabilities() {
            guard let url = URL(string: "http://localhost:3000/api/profile/me") else { return }

            URLSession.shared.dataTaskPublisher(for: url)
                .map { $0.data }
                .decode(type: [Availability].self, decoder: JSONDecoder())
                .replaceError(with: [])
                .receive(on: DispatchQueue.main)
                .sink { [weak self] availabilities in
                    self?.generateDays(from: availabilities)
                }
                .store(in: &cancellables)
    }

    func generateDays(from availabilities: [Availability]) {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: currentDate)!
        let numDays = range.count
        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!
        
        days = (1...numDays).map { day -> Day in
            let date = calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth)!
            let isPast = date < Date()
            let availability = availabilities.first(where: { calendar.isDate($0.date, inSameDayAs: date) })
            let isAvailable = availability?.isValid ?? false
            let slots = availability?.slots ?? []
            return Day(date: date, display: String(day), isPast: isPast, isAvailable: isAvailable, slots: slots)
        }
    }

    func loadTestData() {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: currentDate)!
        let numDays = range.count
        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!
        let testAvailabilities = (1...numDays).map { day -> Availability in
            let date = calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth)!
            let isAvailable = (12...19).contains(day) // test available date
            let slots = (1...5).map { slotIndex -> Slot in
                let startTime = calendar.date(byAdding: .hour, value: slotIndex + 8, to: date)!
                let endTime = calendar.date(byAdding: .hour, value: slotIndex + 9, to: date)!
                return Slot(id: UUID(), startTime: startTime, endTime: endTime, isAvailable: slotIndex % 2 == 0)
            }
            return Availability(
                id: UUID().uuidString,
                clinicianID: "clinician_\(day)",
                date: date,
                isValid: isAvailable,
                period: [],
                slots: slots
            )
        }
        generateDays(from: testAvailabilities)
    }

    var currentMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL"
        formatter.locale = Locale(identifier: "zh_Hans_CN")
        return formatter.string(from: currentDate)
    }
    
    var currentYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        formatter.locale = Locale(identifier: "zh_Hans_CN")
        return formatter.string(from: currentDate)
    }

    var weekdays: [String] {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_Hans_CN")
        return formatter.veryShortStandaloneWeekdaySymbols
    }

    func previousMonth() {
        guard let newDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) else { return }
        currentDate = newDate
        loadTestData()
        //fetchAvailabilities()
    }

    func nextMonth() {
        guard let newDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate) else { return }
        currentDate = newDate
        loadTestData()
        // fetchAvailabilities()
    }

    func selectDate(_ date: Date) {
        selectedDate = date
        if let availability = days.first(where: { $0.date == date }) {
            timeSlots = availability.slots
        } else {
            timeSlots = []
        }
    }
        var selectedMonthFormatted: String {
            guard let selectedDate = selectedDate else { return "" }
            let formatter = DateFormatter()
            formatter.dateFormat = "LLLL"
            formatter.locale = Locale(identifier: "zh_Hans_CN")
            return formatter.string(from: selectedDate)
        }

        var selectedDayFormatted: String {
            guard let selectedDate = selectedDate else { return "" }
            let formatter = DateFormatter()
            formatter.dateFormat = "d'th'"
            formatter.locale = Locale(identifier: "zh_Hans_CN")
            return formatter.string(from: selectedDate)
        }

        func formatTime(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: date)
        }
}
