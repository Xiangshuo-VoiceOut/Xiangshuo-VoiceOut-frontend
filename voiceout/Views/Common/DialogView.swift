//
//  DialogView.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 5/18/24.
//

import SwiftUI

struct DialogViewModifier: ViewModifier {
    @ObservedObject var dialogViewModel: DialogViewModel

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {
                if case let .present(config) = dialogViewModel.action {
                    DialogView(
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
            dialogViewModel.dismiss()
        }
    }
}

struct DialogView: View {
    var content: AnyView
    var didClose: () -> Void
    @State private var opacity: Bool = false

    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.5)
                .onTapGesture {
                    didClose()
                    withAnimation(.easeOut(duration: 0.2)) {
                        opacity = false
                    }
                }

            content
            .background(Color.surfacePrimary)
            .cornerRadius(.medium, corners: .allCorners)
            .padding(ViewSpacing.xlarge)
            .opacity(opacity ? 1 : 0)
            .onAppear {
                withAnimation(.easeIn(duration: 0.2)) {
                    opacity = true
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct DialogView_Previews: PreviewProvider {
    static var previews: some View {
        DialogView(content: AnyView(Text("content")), didClose: {})
    }
}
