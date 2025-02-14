//
//  TherapistProfilePageService.swift
//  voiceout
//
//  Created by Yujia Yang on 2/13/25.
//

import Foundation
import Combine

class TherapistProfilePageService: ObservableObject {
    @Published var name: String = ""
    @Published var consultingPrice: String = ""
    @Published var personalTitle: String = ""
    @Published var imageUrl: String = ""
    @Published var clinicianId: String = ""
    @Published var isFollowing: Bool = false
    @Published var selectedSlot: Slot?
    @Published var selectedDate: Date?
    @Published var selectedTimeSlot: Slot?
    @Published var consultationPrice: String = ""
    @Published var days: [Day] = []
    @Published var timeSlots: [Slot] = []
    @Published var currentDate: Date = Date()

    private var cancellables = Set<AnyCancellable>()
    private let apiURL = APIConfigs.clinicianProfileURL + "667ab297a0ada2dceea38f7f"
    
    init() {
        fetchProfileData()
    }
    
    var isAppointmentReady: Bool {
        selectedSlot != nil
    }
    init(clinicianId: String) {
        self.clinicianId = clinicianId
        generateDaysForCurrentMonth()
        fetchAvailableDates()
    }
    
    func fetchProfileData() {
        guard let url = URL(string: apiURL) else {
            print("Invalid URL")
            //loadTestData()
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                //self.loadTestData()
                return
            }
            
            guard let data = data else {
                print("No data received")
                //self.loadTestData()
                return
            }
            
            if let responseText = String(data: data, encoding: .utf8) {
                print("API Response: \(responseText)")
            }
            
            do {
                let profile = try JSONDecoder().decode(ClinicianProfileResponse.self, from: data)
                DispatchQueue.main.async {
                    self.updateProfile(with: profile)
                }
            } catch {
                print("JSON decoding error: \(error)")
                //self.loadTestData()
            }
        }.resume()
    }
    
    private func updateProfile(with profile: ClinicianProfileResponse) {
        self.name = profile.name
        self.consultingPrice = "$\(profile.charge)/次"
        self.personalTitle = profile.title
        self.imageUrl = profile.profilePicture
        self.clinicianId = profile.id
        self.isFollowing = false
    }
    
    func generateDaysForCurrentMonth() {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: currentDate)!
        let startDate = calendar.startOfDay(for: calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!)
        let today = calendar.startOfDay(for: Date())
        
        days = range.map { day in
            let date = calendar.date(byAdding: .day, value: day - 1, to: startDate)!
            return Day(
                label: "\(day)",
                date: date,
                isPast: date < today,
                isAvailable: false,
                slots: []
            )
        }
    }
    
    func fetchAvailableDates() {
        guard let url = URL(string: APIConfigs.clinicianAvailabilityMonthURL) else { return }
        
        let parameters: [String: Any] = [
            "clinicianId": clinicianId,
            "year": Calendar.current.component(.year, from: currentDate),
            "month": Calendar.current.component(.month, from: currentDate)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            print("JSON serialization error:", error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("Network error:", error)
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("API Response:", responseString)
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(MonthAvailabilityResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.updateAvailableDates(from: response.availabilityStatus)
                }
            } catch {
                print("JSON decoding error:", error)
            }
        }.resume()
    }
    
    private func updateAvailableDates(from availability: [String: String]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        for index in days.indices {
            let day = days[index]
            if let status = availability[dateFormatter.string(from: day.date)], status == "Available" {
                days[index].isAvailable = true
            }
        }
    }
    
    func fetchTimeSlots(for date: Date) {
        guard let url = URL(string: APIConfigs.clinicianAvailableSlotsURL) else { return }
        
        let parameters: [String: Any] = [
            "clinicianId": clinicianId,
            "currentDate": formatDateForAPI(date)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            print("JSON serialization error:", error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("Network error:", error)
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("API Response:", responseString)
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .custom { decoder -> Date in
                    let container = try decoder.singleValueContainer()
                    let dateString = try container.decode(String.self)
                    
                    let formatter = ISO8601DateFormatter()
                    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                    formatter.timeZone = TimeZone(secondsFromGMT: 0)
                    
                    guard let date = formatter.date(from: dateString) else {
                        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date format")
                    }
                    
                    return date
                }
                
                
                let response = try decoder.decode(TimeSlotResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self?.timeSlots = response.data.slots.map { slot in
                        slot
                    }
                }
            } catch {
                print("JSON decoding error:", error)
            }
        }.resume()
    }
    
    private func formatDateForAPI(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    
    static func convertToLocalTime(utcDate: Date) -> Date {
        let timeZone = TimeZone.current
        let calendar = Calendar.current
        return calendar.date(byAdding: .second, value: timeZone.secondsFromGMT(for: utcDate), to: utcDate) ?? utcDate
    }
    
    
    func previousMonth() {
        if let newDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) {
            currentDate = newDate
            generateDaysForCurrentMonth()
            fetchAvailableDates()
        }
    }
    
    func nextMonth() {
        if let newDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate) {
            currentDate = newDate
            generateDaysForCurrentMonth()
            fetchAvailableDates()
        }
    }
    
    var currentYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年"
        return formatter.string(from: currentDate)
    }
    
    var currentMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M月"
        return formatter.string(from: currentDate)
    }
    
    var currentYearValue: Int {
        Calendar.current.component(.year, from: currentDate)
    }
    
    var currentMonthValue: Int {
        Calendar.current.component(.month, from: currentDate)
    }
    
    
    var weekdays: [String] {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_Hans_CN")
        return formatter.veryShortStandaloneWeekdaySymbols
    }
}
