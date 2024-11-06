//
//  ProfilePageView.swift
//  voiceout
//
//  Created by Jiaqi Chen on 10/27/24.
//

import Foundation
import SwiftUI

struct ProfilePageView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            NameTagView(
                name: "董丽华",
                consultingPrice: "$200/次",
                personalTitle: "专攻青少年焦虑情绪问题",
                profileImage: Image(systemName: "person.circle") // Placeholder image
            )
            PersonalView(
                age: "32",
                gender: "女",
                location: "NY",
                language: "普通话"
            )
            EducationView()
            QualificationView()
            CareerView()
            ConsultServiceView()
            WordToVisitorView()
        }
        .padding()
    }
}

struct ProfilePageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePageView()
    }
}
