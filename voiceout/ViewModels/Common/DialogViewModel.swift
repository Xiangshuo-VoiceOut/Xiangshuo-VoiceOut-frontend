//
//  DialogViewModel.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 5/18/24.
//

import SwiftUI

final class DialogViewModel: ObservableObject {
    typealias Config = Action.DialogConfig

    enum Action {
        // swiftlint:disable:next nesting
        struct DialogConfig {
            var content: AnyView
        }

        case na
        case present(config: DialogConfig)
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

extension DialogViewModel.Action {
    var isPresented: Bool {
        guard case .present = self else { return false }
        return true
    }
}
