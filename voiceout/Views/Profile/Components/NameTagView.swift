//  NameTagView.swift
//  voiceout
//
//  Created by Jiaqi Chen on 10/15/24.
//

import Foundation
import SwiftUI

struct NameTagView: View {
    var name: String
    var consultingPrice: String
    var personalTitle: String
    var imageUrl: String
    var showEditButton: Bool
    var followButtonAction: (() -> Void)?
    var isFollowing: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: CornerRadius.medium.value)
                .fill(Color.surfacePrimary)

            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    VStack(alignment: .leading) {
                        AsyncImage(url: URL(string: imageUrl)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: 88, height: 88)
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 88, height: 88)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1))
                            case .failure:
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 88, height: 88)
                                    .clipShape(Circle())
                                    .foregroundColor(.gray)
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .offset(y: -ViewSpacing.xlarge)
                        .padding(.bottom, -ViewSpacing.xlarge)

                        Text(name)
                            .font(Font.typography(.headerSmall))
                            .foregroundColor(.textTitle)
                            .padding(.top, ViewSpacing.base) 
                    }
                    .padding(.bottom, ViewSpacing.medium)

                    Spacer()

                    VStack(alignment: .trailing) {
                        if showEditButton {
                            EditButtonView()
                        } else {
                            Button(action: {
                                followButtonAction?()
                            }) {
                                Text(isFollowing ? NSLocalizedString("followed", comment: "已关注") : NSLocalizedString("follow", comment: "关注"))
                                    .font(Font.typography(.bodySmall))
                                    .foregroundColor(isFollowing ? .textPrimary : .white)
                                    .frame(width: 101, height: 28)
                                    .background(isFollowing ? Color.surfacePrimaryGrey : Color.surfaceBrandPrimary)
                                    .cornerRadius(CornerRadius.full.value)
                            }
                        }

                        Text(consultingPrice)
                            .font(Font.typography(.bodySmall))
                            .foregroundColor(.textBrandSecondary)
                            .frame(height: 20, alignment: .topLeading)
                            .padding(.top, ViewSpacing.large)

                        Text(personalTitle)
                            .padding(.top, ViewSpacing.xsmall)
                            .font(Font.typography(.bodyXSmallEmphasis))
                            .kerning(0.36)
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.textSecondary)
                            .frame(height: 16, alignment: .topTrailing)
                    }
                }
                .padding(.horizontal, ViewSpacing.large)
            }
        }
        .frame(width: 358, height: 124)
    }
}

struct NameTagView_Previews: PreviewProvider {
    static var previews: some View {
        NameTagView(
            name: "董丽华",
            consultingPrice: "$200/次",
            personalTitle: "专攻青少年焦虑情绪问题",
            imageUrl: "https://s3-alpha-sig.figma.com/img/349a/f982/5c5db48e5ba3bd06c62e4c9c892f02af?Expires=1732492800&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=llNknhfxTEXJcscv6wMhAKRFA65gzgqx60yEE7rZkA77~haSuwlioGXy-wvVaEaAbertZMdth7H2nxYPUPYoPvnja32O5nqNITp567r8frlC2XvQD299G3pdjZdo63LCHVmUvFXnp3jCLT82-zJXTWU5eSBrnRkFMwRm7VlHQSH7cwLlQZWFlyb96WgBAQ4xNKmFU1cEoaEr56wwXTp-2LfBE1NszbkznJ5dpYchUTL9uA2AE7RPC3YmuT4xqgGjNKg0xoSTv00OLe8z1qdqzFl9DzaMFR1WB7hvM9b0ZMOv8bweCGyIL8j~BaBtR0X9jO-nlGxAM92CEaORjNoW5A__",
            showEditButton: false,
            followButtonAction: {
            },
            isFollowing: false
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
