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
        HStack(alignment: .bottom, spacing: 0) {
            Text(name)
                .font(.typography(.headerSmall))
                .foregroundColor(.textTitle)

            Spacer()

            VStack(alignment: .trailing, spacing: ViewSpacing.xsmall) {
                if showEditButton {
                    EditButtonView()
                } else {
                    ButtonView(
                        text: isFollowing ? "followed" : "follow",
                        action: {
                            followButtonAction?()
                        },
                        theme: isFollowing ? .base : .action,
                        spacing: .xsmall,
                        maxWidth: 101
                    )
                }

                Spacer()

                Text(consultingPrice)
                    .font(.typography(.bodySmall))
                    .foregroundColor(.textBrandSecondary)

                Text(personalTitle)
                    .font(.typography(.bodyXSmall))
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(.textSecondary)
            }
        }
        .padding(.horizontal, ViewSpacing.large)
        .padding(.vertical, ViewSpacing.medium)
        .background(Color.surfacePrimary)
        .cornerRadius(.medium, corners: .allCorners)
        .frame(height: 124)
        .overlay {
            AsyncImage(url: URL(string: imageUrl)) { phase in
                switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1))
                    case .failure:
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
            }
            .frame(width: 88, height: 88)
            .clipShape(Circle())
            .offset(x: -140, y: -55)
        }
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
