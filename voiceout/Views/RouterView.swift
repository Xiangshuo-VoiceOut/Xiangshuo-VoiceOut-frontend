//
//  RouterView.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 5/26/24.
//

import SwiftUI

struct RouterView<Content: View>: View {
    @StateObject var router: RouterModel = RouterModel()
    private let content: Content
        
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
        
    var body: some View {
        NavigationStack(path: $router.path) {
            content
                .navigationDestination(for: Route.self) { route in
                    router.view(for: route)
                }
        }
        .environmentObject(router)
    }
}
