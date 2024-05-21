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
                        didClose: {
                            close()
                        }
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
    
    var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.white)
            .cornerRadius(.medium, corners: [.topLeft, .topRight])
            .overlay(alignment: .topTrailing) {
                Button (action: didClose) {
                    Image("close")
                        .foregroundColor(Color(.grey500))
                }
                .padding(.top, ViewSpacing.large)
                .padding(.trailing, ViewSpacing.large)
            }
            .ignoresSafeArea()
            .transition(.move(edge: .bottom))
    }
}


struct PopupView_Previews: PreviewProvider {
    static var previews: some View {
        PopupView(content: AnyView(Text("content")), didClose: {})
    }
}
