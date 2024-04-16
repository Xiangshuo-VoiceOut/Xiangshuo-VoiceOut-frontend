//
//  InputView.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 3/20/24.
//

import SwiftUI

struct InputView: View {
    @Binding var text: String
    let icon: String
    let placeholder: String
    let isSecuredField: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Image(icon)
                TextField(LocalizedStringKey(placeholder), text: $text)
            }
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            .background(.white)
            .cornerRadius(100);
        }
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView(
            text: .constant(""),
            icon: "icon",
            placeholder: "placeholder"
        )
    }
}
