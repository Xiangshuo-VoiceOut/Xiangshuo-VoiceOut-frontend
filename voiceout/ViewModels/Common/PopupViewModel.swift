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
        // swiftlint:disable:next nesting
        struct PopupConfig {
            var content: AnyView
            var hideCloseButton: Bool?
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
        guard case .present = self else { return false }
        return true
    }
}
