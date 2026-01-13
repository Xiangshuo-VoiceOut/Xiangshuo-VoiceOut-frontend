//
//  UserManager.swift
//  voiceout
//
//  Created by Yujia Yang on 12/12/25.
//

import Foundation
import UIKit

private enum APIConfig {
//    static let baseURL = "http://127.0.0.1:3000"
     static let baseURL = "http://3.132.55.92:5000"
}

@MainActor
final class UserManager: ObservableObject {
    @Published var userUUID: String = ""
    @Published var displayID: String = ""
    @Published var userID: String = ""
    @Published var idDisplayMode: IDDisplayMode = .displayID //现在主页显示的是前端根据uuid生成的三位数displayID
    //@Published var idDisplayMode: IDDisplayMode = .userID //若之后想使用后端随机生成的三位数userID，可以删掉上一行使用这行


    private let defaults = UserDefaults.standard
    private let service = UserIDService(baseURL: APIConfig.baseURL)
    private enum Keys {
        static let userUUID = "user_uuid"
        static let displayID = "display_id"
        static let userID = "user_id"
    }
    
    var displayIDForUI: String {
        switch idDisplayMode {
        case .displayID:
            return displayID
        case .userID:
            return userID.isEmpty ? displayID : userID
        }
    }

    init() {
        let uuid = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        self.userUUID = uuid

        let savedUUID = defaults.string(forKey: Keys.userUUID)
        if savedUUID != uuid {
            defaults.set(uuid, forKey: Keys.userUUID)
            defaults.removeObject(forKey: Keys.displayID)
            defaults.removeObject(forKey: Keys.userID)
        }

        if let savedDisplay = defaults.string(forKey: Keys.displayID),
           !savedDisplay.isEmpty {
            self.displayID = savedDisplay
        } else {
            let generated = Self.generate3Digit(from: uuid)
            self.displayID = generated
            defaults.set(generated, forKey: Keys.displayID)
        }

        if let savedUserID = defaults.string(forKey: Keys.userID),
           !savedUserID.isEmpty {
            self.userID = savedUserID
        }
    }

    func resolveUserIDOnAppLaunch() async {
        do {
            let response = try await service.resolve(userUUID: userUUID, displayID: displayID)

            self.userID = response.user_id
            defaults.set(response.user_id, forKey: Keys.userID)
            print("resolve ok. userID:", response.user_id, "isNew:", response.is_new)
        } catch {
            print("resolve failed:", error)
        }
    }

    private static func generate3Digit(from input: String) -> String {
        var hash: UInt32 = 0
        for s in input.unicodeScalars {
            hash = hash &* 31 &+ UInt32(s.value)
        }
        return String(format: "%03d", Int(hash % 1000))
    }

    func resetLocalCacheForDebug() {
        defaults.removeObject(forKey: Keys.userUUID)
        defaults.removeObject(forKey: Keys.displayID)
        defaults.removeObject(forKey: Keys.userID)

        self.userID = ""
        self.displayID = ""
    }
}
