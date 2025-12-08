//
//  MoodTreatmentLauncherView.swift
//  voiceout
//
//  Created by Yujia Yang on 4/15/25.
//

import SwiftUI

struct MoodTreatmentLauncherView: View {
    @State private var latestMood: String? = nil
    @State private var loading: Bool = true
    @EnvironmentObject var router: RouterModel

    var body: some View {
        Group {
            if loading {
                ProgressView("Loading…")
                    .onAppear {
                        fetchLatestMood()
                    }
            } else if let mood = latestMood {
                moodHomepageView(for: mood)
            } else {
                EmptyView()
            }
        }
    }

    @ViewBuilder
    private func moodHomepageView(for mood: String) -> some View {
        switch mood.lowercased() {
        case "happy":
            MoodTreatmentHappyHomepageView()
        case "angry":
            MoodTreatmentAngryHomepageView()
        case "sad":
            MoodTreatmentSadHomepageView()
        case "guilt":
            MoodTreatmentGuiltHomepageView()
        case "shame":
            AnxietyHomepageView()
        case "scare":
            MoodTreatmentScareHomepageView()
        case "envy":
            MoodTreatmentEnvyHomepageView()
        case "calm":
            MoodTreatmentHappyHomepageView()
        default:
            Text("No this type of mood：\(mood)")
        }
    }

    private func fetchLatestMood() {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: Date())
        let endDate = Date()

        MoodManagerService.shared.fetchDiaryEntries(
            startDate: startDate,
            endDate: endDate,
            page: 1,
            limit: 100
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    let entries = response.data.entries.sorted(by: { $0.timestamp > $1.timestamp })

                    if entries.isEmpty {
                        router.navigateTo(.moodManagerLoading)
                        return
                    }

                    if let mood = entries.first?.moodType {
                        self.latestMood = mood.lowercased()
                    } else {
                        self.latestMood = nil
                    }

                case .failure(_):
                    self.latestMood = nil
                }

                self.loading = false
            }
        }
    }
}
