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
    @Environment(\.safeAreaInsets) private var safeAreaInsets

    var body: some View {
        ZStack {
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

            VStack {
                NameTagView(
                    name: "董丽华",
                    consultingPrice: "$200/次",
                    personalTitle: "专攻青少年焦虑情绪问题",
                    imageUrl: "https://s3-alpha-sig.figma.com/img/349a/f982/5c5db48e5ba3bd06c62e4c9c892f02af?Expires=1732492800&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=llNknhfxTEXJcscv6wMhAKRFA65gzgqx60yEE7rZkA77~haSuwlioGXy-wvVaEaAbertZMdth7H2nxYPUPYoPvnja32O5nqNITp567r8frlC2XvQD299G3pdjZdo63LCHVmUvFXnp3jCLT82-zJXTWU5eSBrnRkFMwRm7VlHQSH7cwLlQZWFlyb96WgBAQ4xNKmFU1cEoaEr56wwXTp-2LfBE1NszbkznJ5dpYchUTL9uA2AE7RPC3YmuT4xqgGjNKg0xoSTv00OLe8z1qdqzFl9DzaMFR1WB7hvM9b0ZMOv8bweCGyIL8j~BaBtR0X9jO-nlGxAM92CEaORjNoW5A__",
                    showEditButton: false
                )
                .padding(.top, ViewSpacing.medium)

                // Tab + scrollable views

                ScrollView {
                    VStack(spacing: ViewSpacing.medium) {
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
                }
            }
            .padding(.top, safeAreaInsets.top + ViewSpacing.xlarge)
            .padding(.horizontal, ViewSpacing.medium)
        }
    }
}

struct ProfilePageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePageView()
            .environmentObject(RouterModel())
    }
}
