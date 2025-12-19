//
//  LanguageManager.swift
//  voiceout
//
//  Created by Yujia Yang on 12/13/25.
//

import Foundation
import ObjectiveC.runtime

private var kLanguageBundleKey: UInt8 = 0

final class LocalizedBundle: Bundle {
    override func localizedString(forKey key: String,
                                  value: String?,
                                  table tableName: String?) -> String {
        if let langBundle = objc_getAssociatedObject(self, &kLanguageBundleKey) as? Bundle {
            return langBundle.localizedString(forKey: key, value: value, table: tableName)
        }
        return super.localizedString(forKey: key, value: value, table: tableName)
    }
}

extension Bundle {
    static func setLanguage(_ language: String) {
        if let path = Bundle.main.path(forResource: language, ofType: "lproj"),
           let langBundle = Bundle(path: path) {
            objc_setAssociatedObject(Bundle.main, &kLanguageBundleKey, langBundle, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        } else {
            objc_setAssociatedObject(Bundle.main, &kLanguageBundleKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }

        object_setClass(Bundle.main, LocalizedBundle.self)
    }
}
