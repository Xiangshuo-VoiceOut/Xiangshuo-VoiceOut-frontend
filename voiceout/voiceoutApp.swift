//
//  voiceoutApp.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 3/16/24.
//

import SwiftUI

@main
struct VoiceoutApp: App {
    var body: some Scene {
        WindowGroup {
            RouterView {
//                ContentView()
                MainHomepageView()
            }
        }
    }
}
