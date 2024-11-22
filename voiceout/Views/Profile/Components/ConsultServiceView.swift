//
//  ConsultServiceView.swift
//  voiceout
//
//  Created by Jiaqi Chen on 10/22/24.
//

import SwiftUI

struct KeyValuePairView: View {
    let key: String
    let value: String

    var body: some View {
        HStack(alignment: .top) {
            Text("\(key)：")
                .font(Font.typography(.bodySmall))
                .foregroundColor(.textPrimary)
            Text(value)
                .font(Font.typography(.bodySmall))
                .foregroundColor(.textSecondary)
            Spacer()
        }
    }
}

struct ConsultServiceView: View {
    var showEditButton: Bool

    var body: some View {
        ProfileCardView(
            title: LocalizedStringKey("consultant_service"),
            showEditButton: showEditButton
        ) {
            VStack(alignment: .leading, spacing: ViewSpacing.medium) {
                KeyValuePairView(key: "擅长人群", value: "儿童、青少年、伴侣")
                KeyValuePairView(key: "咨询类型", value: "亲子关系、心理创伤")
                KeyValuePairView(key: "咨询风格", value: "温柔、灵活、轻松")
            }
        }
    }
}

struct ConsultServiceView_Previews: PreviewProvider {
    static var previews: some View {
        ConsultServiceView(showEditButton: true)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
