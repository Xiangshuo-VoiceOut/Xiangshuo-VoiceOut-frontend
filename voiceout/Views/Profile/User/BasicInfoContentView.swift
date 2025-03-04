//
//  BasicInfoContentView.swift
//  voiceout
//
//  Created by Yujia Yang on 11/21/24.
//

import SwiftUI

struct BasicInfoContentView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: ViewSpacing.small) {
                PersonalView(
                    age: "32",
                    gender: "女",
                    location: "NY",
                    language: "普通话",
                    showEditButton: false
                )

                EducationView(showEditButton: false)

                QualificationView(
                    showEditButton: false,
                    qualifications: [
                        "Psychiatrist, NY",
                        "国家二级心理咨询师, CN"
                    ]
                )

                CareerView(showEditButton: false)

                ConsultServiceView(showEditButton: false)

                WordToVisitorView(showEditButton: false)
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
    }
}

#Preview{
    BasicInfoContentView()
}
