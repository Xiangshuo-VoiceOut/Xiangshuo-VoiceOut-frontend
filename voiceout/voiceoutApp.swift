//
//  voiceoutApp.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 3/16/24.
//

import SwiftUI

@main
struct VoiceoutApp: App {
    @StateObject private var router = RouterModel()
    @StateObject private var userManager = UserManager()
    var body: some Scene {
        WindowGroup {
            RouterView {
//                ContentView()
                MainHomepageView()
            }
            .environmentObject(router)
            .environmentObject(userManager)
        }
    }
}
