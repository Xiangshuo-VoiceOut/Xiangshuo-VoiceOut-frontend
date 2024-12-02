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
    @State private var isFollowing: Bool = false
    @State private var showAlert: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.grey75
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    NameTagView(
                        name: "董丽华",
                        consultingPrice: "$200/次",
                        personalTitle: "专攻青少年焦虑情绪问题",
                        imageUrl: "https://s3-alpha-sig.figma.com/img/349a/f982/5c5db48e5ba3bd06c62e4c9c892f02af?Expires=1732492800&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=llNknhfxTEXJcscv6wMhAKRFA65gzgqx60yEE7rZkA77~haSuwlioGXy-wvVaEaAbertZMdth7H2nxYPUPYoPvnja32O5nqNITp567r8frlC2XvQD299G3pdjZdo63LCHVmUvFXnp3jCLT82-zJXTWU5eSBrnRkFMwRm7VlHQSH7cwLlQZWFlyb96WgBAQ4xNKmFU1cEoaEr56wwXTp-2LfBE1NszbkznJ5dpYchUTL9uA2AE7RPC3YmuT4xqgGjNKg0xoSTv00OLe8z1qdqzFl9DzaMFR1WB7hvM9b0ZMOv8bweCGyIL8j~BaBtR0X9jO-nlGxAM92CEaORjNoW5A__",
                        showEditButton: false,
                        followButtonAction: {
                            showAlert = true
                        },
                        isFollowing: isFollowing
                    )
                    .padding(.horizontal,ViewSpacing.medium)
                    .padding(.top, 96)
                    .padding(.bottom, ViewSpacing.medium)

                    SegmentedButtonView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.horizontal,ViewSpacing.medium)
                        .padding(.bottom, ViewSpacing.medium)

                }
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

                if showAlert {
                    ZStack {
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)

                        VStack(alignment: .center, spacing: ViewSpacing.large) {
                            Text("确认不再关注？")
                                .font(Font.typography(.bodyLargeEmphasis))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.textPrimary)

                            VStack(spacing: ViewSpacing.medium) {
                                Button(action: {
                                    isFollowing = true
                                    showAlert = false
                                }) {
                                    Text("继续关注")
                                        .font(Font.typography(.bodyMedium))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, minHeight: 44)
                                        .padding(.horizontal, ViewSpacing.medium)
                                        .background(Color.surfaceBrandPrimary)
                                        .cornerRadius(CornerRadius.large.value)
                                }

                                Button(action: {
                                    isFollowing = false
                                    showAlert = false
                                }) {
                                    Text("取消关注")
                                        .font(Font.typography(.bodyMedium))
                                        .foregroundColor(.textBrandPrimary)
                                        .frame(maxWidth: .infinity, minHeight: 44)
                                        .padding(.horizontal, ViewSpacing.medium)
                                        .background(Color.surfacePrimary)
                                        .cornerRadius(CornerRadius.large.value)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: CornerRadius.full.value)
                                                .stroke(Color.borderBrandPrimary, lineWidth: 1)
                                        )
                                }
                            }
                        }
                        .padding(ViewSpacing.large)
                        .frame(width: 271, height: 217)
                        .background(Color.surfacePrimary)
                        .cornerRadius(CornerRadius.medium.value)
                    }
                }
            }
        }
    }
}

struct ProfilePageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePageView()
            .environmentObject(RouterModel())
    }
}
