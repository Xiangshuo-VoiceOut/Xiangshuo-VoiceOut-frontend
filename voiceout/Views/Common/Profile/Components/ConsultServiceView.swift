//
//  ConsultServiceView.swift
//  voiceout
//
//  Created by Jiaqi Chen on 10/22/24.
//

import Foundation
import SwiftUI

struct ConsultServiceView: View {
    var showEditButton: Bool

    var body: some View {
        TherapistProfilePageCardView(title: "咨询服务", showEditButton: showEditButton) {
            VStack(alignment: .leading, spacing: ViewSpacing.small) {
                Text("擅长人群：儿童、青少年、伴侣")
                    .font(Font.typography(.bodySmall))
                    .foregroundColor(.textSecondary)

                Text("咨询类型：亲子关系、心理创伤")
                    .font(Font.typography(.bodySmall))
                    .foregroundColor(.textSecondary)

                Text("咨询风格：温柔、灵活、轻松")
                    .font(Font.typography(.bodySmall))
                    .foregroundColor(.textSecondary)
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
