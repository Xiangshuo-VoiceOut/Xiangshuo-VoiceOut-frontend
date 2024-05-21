//
//  PopupViewModel.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 5/6/24.
//

import SwiftUI

final class PopupViewModel: ObservableObject {
    typealias Config = Action.PopupConfig
    
    enum Action {
        struct PopupConfig {
            var content: AnyView
        }
        
        case na
        case present(config: PopupConfig)
        case dismiss
    }
    
    @Published private(set) var action: Action = .na
    
    func present(with config: Config) {
        guard !action.isPresented else { return }
        self.action = .present(config: config)
    }
    
    func dismiss() {
        self.action = .dismiss
    }
}

extension PopupViewModel.Action {
    var isPresented: Bool {
        guard case .present(_) = self else { return false }
        return true
    }
}
