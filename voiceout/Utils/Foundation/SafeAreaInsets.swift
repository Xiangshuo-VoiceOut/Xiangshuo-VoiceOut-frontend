//
//  SafeAreaInsets.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 10/8/24.
//

import SwiftUI

private struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            return windowScene.windows.first(where: { $0.isKeyWindow })?.safeAreaInsets.insets ??
                EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        }
        return EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
    }
}

extension EnvironmentValues {
    var safeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}

private extension UIEdgeInsets {
    var insets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}
