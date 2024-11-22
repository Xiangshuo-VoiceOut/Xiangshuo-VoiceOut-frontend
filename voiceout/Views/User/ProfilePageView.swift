//
//  ProfilePageView.swift
//  voiceout
//
//  Created by Jiaqi Chen on 10/27/24.
//

import Foundation
import SwiftUI

struct ProfilePageView: View {
    @EnvironmentObject var router: RouterModel

    var body: some View {
        VStack(spacing: 0) {
            StickyHeaderView(
                title: nil,
                leadingComponent: AnyView(
                    Button(action: {
                        router.navigateBack()
                    }) {
                        Image(systemName: "arrow.backward")
                            .foregroundColor(.black)
                            .frame(height: 24)
                    }
                ),
                trailingComponent: AnyView(
                    Button(action: {
                        print("Send button tapped")
                    }) {
                        Image("send")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.black)
                    }
                )
            )
            .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0)
            .background(Color.white)

            ScrollView {
                VStack(spacing: 16) {
                    NameTagView(
                        name: "董丽华",
                        consultingPrice: "$200/次",
                        personalTitle: "专攻青少年焦虑情绪问题",
                        imageUrl: "https://s3-alpha-sig.figma.com/img/349a/f982/5c5db48e5ba3bd06c62e4c9c892f02af?Expires=1732492800&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=llNknhfxTEXJcscv6wMhAKRFA65gzgqx60yEE7rZkA77~haSuwlioGXy-wvVaEaAbertZMdth7H2nxYPUPYoPvnja32O5nqNITp567r8frlC2XvQD299G3pdjZdo63LCHVmUvFXnp3jCLT82-zJXTWU5eSBrnRkFMwRm7VlHQSH7cwLlQZWFlyb96WgBAQ4xNKmFU1cEoaEr56wwXTp-2LfBE1NszbkznJ5dpYchUTL9uA2AE7RPC3YmuT4xqgGjNKg0xoSTv00OLe8z1qdqzFl9DzaMFR1WB7hvM9b0ZMOv8bweCGyIL8j~BaBtR0X9jO-nlGxAM92CEaORjNoW5A__",
                        showEditButton: false
                    )

                    segmentedControl

                    PersonalView(
                        age: "32",
                        gender: "女",
                        location: "NY",
                        language: "普通话",
                        showEditButton: false
                    )
                    .cardStyle()

                    EducationView(showEditButton: false)
                        .cardStyle()

                    QualificationView(
                        showEditButton: false,
                        qualifications: [
                            "Psychiatrist, NY",
                            "国家二级心理咨询师, CN"
                        ]
                    )
                    .cardStyle()

                    CareerView(showEditButton: false)
                        .cardStyle()

                    ConsultServiceView(showEditButton: false)
                        .cardStyle()

                    WordToVisitorView(showEditButton: false)
                        .cardStyle()
                }
                .padding(.horizontal, 16)
                .padding(.top, 8) 
            }
        }
        .edgesIgnoringSafeArea(.top)
    }

    private var segmentedControl: some View {
        HStack(spacing: 16) {
            Text("基本信息")
                .font(Font.typography(.bodyMediumEmphasis))
                .foregroundColor(.textPrimary)
                .frame(maxWidth: .infinity)

            Text("客户评价")
                .font(Font.typography(.bodyMedium))
                .foregroundColor(.textSecondary)
                .frame(maxWidth: .infinity)

            Text("咨询预约")
                .font(Font.typography(.bodyMedium))
                .foregroundColor(.textSecondary)
                .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 8)
        .background(Color.surfacePrimary)
    }
}

extension View {
    func cardStyle() -> some View {
        self
            .padding()
            .background(Color.surfacePrimary)
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

struct ProfilePageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePageView()
            .environmentObject(RouterModel())
    }
}
