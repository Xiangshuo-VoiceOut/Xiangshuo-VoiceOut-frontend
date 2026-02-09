//
//  AppDelegate.swift
//  voiceout
//
//  Created by Ziyang Ye on 1/28/26.
//

import UIKit
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        print("🔥 [Firebase] Successfully configured")
        return true
    }
}

