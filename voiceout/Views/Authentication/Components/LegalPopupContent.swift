//
//  LegalPopupContent.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 5/20/24.
//

import SwiftUI

struct LegalPopupContent: View {
    var fileName: String
    var contentTitle: String

    var body: some View {
        ScrollView {
            VStack {
                Text(LocalizedStringKey(contentTitle))
                    .padding(.bottom, ViewSpacing.xlarge)
                    .font(.typography(.bodyLarge))
                Text(readFile(fileName: fileName))
                    .font(.typography(.bodySmall))
            }
            .foregroundColor(.textPrimary)
            .padding(ViewSpacing.large)
            .padding(.top, ViewSpacing.xxlarge)
        }
    }
}

struct LegalPopupContent_Previews: PreviewProvider {
    static var previews: some View {
        LegalPopupContent(fileName: "注册协议", contentTitle: "registration_protocol_popup_title")
    }
}
