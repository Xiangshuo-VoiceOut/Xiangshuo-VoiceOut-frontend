//
//  AnalyticsManager.swift
//  voiceout
//
//  Created by Ziyang Ye on 1/28/26.
//

import Foundation
import FirebaseAnalytics

final class AnalyticsManager {
    
    static let shared = AnalyticsManager()
    
    private init() {
        print("📊 [AnalyticsManager] Initialized")
    }
    
    func logClick(
        elementName: String,
        screenName: String,
        additionalParams: [String: Any]? = nil
    ) {
        var parameters: [String: Any] = [
            "interaction_type": "click",
            "element_name": elementName,
            "screen_name": screenName,
            "timestamp": Date().timeIntervalSince1970
        ]
        
        if let additional = additionalParams {
            parameters.merge(additional) { (_, new) in new }
        }
        
        Analytics.logEvent("ui_interaction", parameters: parameters)
        
        #if DEBUG
        print("📊 [Analytics] Click Event:")
        print("   Element: \(elementName)")
        print("   Screen: \(screenName)")
        if let additional = additionalParams {
            print("   Additional: \(additional)")
        }
        #endif
    }
    
    func logScreenView(screenName: String, screenClass: String? = nil) {
        var parameters: [String: Any] = [
            AnalyticsParameterScreenName: screenName
        ]
        
        if let screenClass = screenClass {
            parameters[AnalyticsParameterScreenClass] = screenClass
        }
        
        Analytics.logEvent(AnalyticsEventScreenView, parameters: parameters)
        
        #if DEBUG
        print("📊 [Analytics] Screen View: \(screenName)")
        #endif
    }
    
    func logEvent(eventName: String, parameters: [String: Any]? = nil) {
        Analytics.logEvent(eventName, parameters: parameters)
        
        #if DEBUG
        print("📊 [Analytics] Custom Event: \(eventName)")
        if let params = parameters {
            print("   Parameters: \(params)")
        }
        #endif
    }
    
    func setUserProperty(value: String?, forName name: String) {
        Analytics.setUserProperty(value, forName: name)
        
        #if DEBUG
        print("📊 [Analytics] User Property Set: \(name) = \(value ?? "nil")")
        #endif
    }
    
    func setUserId(_ userId: String?) {
        Analytics.setUserID(userId)
        
        #if DEBUG
        print("📊 [Analytics] User ID Set: \(userId ?? "nil")")
        #endif
    }
}

