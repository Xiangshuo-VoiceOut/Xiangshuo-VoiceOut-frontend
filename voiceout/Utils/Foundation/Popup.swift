//
//  Popup.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 5/6/24.
//

import SwiftUI

enum ViewModelTypes {
    case DialogViewModel(DialogViewModel)
    case PopupViewModel(PopupViewModel)
}

extension View {
    func popup(with viewModel: ViewModelTypes) -> some View {
        switch viewModel {
        case .DialogViewModel(let dialogViewModel):
            return AnyView(self.modifier(DialogViewModifier(dialogViewModel: dialogViewModel)))
        case .PopupViewModel(let popupViewModel):
            return AnyView(self.modifier(PopupViewModifier(popupViewModel: popupViewModel)))
        }
    }
}
