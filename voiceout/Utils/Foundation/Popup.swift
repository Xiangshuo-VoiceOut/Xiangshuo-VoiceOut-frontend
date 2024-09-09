//
//  Popup.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 5/6/24.
//

import SwiftUI

enum ViewModelTypes {
    case dialogViewModel(DialogViewModel)
    case popupViewModel(PopupViewModel)
}

extension View {
    func popup(with viewModel: ViewModelTypes) -> some View {
        switch viewModel {
        case .dialogViewModel(let dialogViewModel):
            return AnyView(self.modifier(DialogViewModifier(dialogViewModel: dialogViewModel)))
        case .popupViewModel(let popupViewModel):
            return AnyView(self.modifier(PopupViewModifier(popupViewModel: popupViewModel)))
        }
    }
}
