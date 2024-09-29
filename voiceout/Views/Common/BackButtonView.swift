//
//  BackButtonView.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 7/1/24.
//

import SwiftUI

struct BackButtonView: View {
    @EnvironmentObject var router: RouterModel
    var navigateBackTo: Route?
    var action: (() -> Void)?

    var body: some View {
        Button(action: {
            if let action = action {
                action()
            } else if let route = navigateBackTo {
                router.navigateTo(route)
            } else {
                router.navigateBack()
            }
        }) {
            Image("left-arrow")
                .frame(width: 24, height: 24)
        }
    }
}

#Preview {
    BackButtonView(navigateBackTo: .userLogin)
}
