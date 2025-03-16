//
//  voiceoutApp.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 3/16/24.
//

import SwiftUI

@main
struct VoiceOutApp: App {
    @StateObject private var router = RouterModel()
    @StateObject var progressViewModel = ProgressViewModel()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                MatchingConsultantLandingView()
                    .environmentObject(router)
                    .environmentObject(progressViewModel)
                    .navigationDestination(for: Route.self) { route in
                        router.view(for: route)
                    }
            }
        }
    }
}
