//
//  PopupView.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 5/6/24.
//

import SwiftUI

struct PopupViewModifier: ViewModifier {
    @ObservedObject var popupViewModel: PopupViewModel

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {
                if case let .present(config) = popupViewModel.action {
                    PopupView(
                        content: config.content,
                        didClose: close,
                        hideCloseButton: config.hideCloseButton
                    )
                }
            }
            .ignoresSafeArea()
    }

    func close() {
        withAnimation(.spring()) {
            popupViewModel.dismiss()
        }
    }
}

struct PopupView: View {
    var content: AnyView
    var didClose: () -> Void
    var hideCloseButton: Bool?

    var body: some View {
        content
            .overlay(alignment: .topTrailing) {
                if hideCloseButton != true {
                    Button(action: didClose) {
                        Image("close")
                            .foregroundColor(Color(.grey500))
                    }
                    .padding(.top, ViewSpacing.large)
                    .padding(.trailing, ViewSpacing.large)
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.surfacePrimary)
            .cornerRadius(.medium, corners: [.topLeft, .topRight])
            .transition(.move(edge: .bottom))
            .ignoresSafeArea()
    }
}

struct PopupView_Previews: PreviewProvider {
    static var previews: some View {
        PopupView(content: AnyView(Text("content"))) {}
    }
}
