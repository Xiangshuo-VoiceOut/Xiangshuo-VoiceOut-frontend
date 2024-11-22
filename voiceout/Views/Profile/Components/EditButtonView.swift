//
//  EditButtonView.swift
//  voiceout
//
//  Created by Yujia Yang on 11/15/24.
//

import Foundation
import SwiftUI

struct EditButtonView: View {
    var action: () -> Void = {}

    var body: some View {
        Button(action: {
            action()
        }) {
            Image("edit")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(.borderLight)
        }
    }
}

#Preview {
    EditButtonView()
}
