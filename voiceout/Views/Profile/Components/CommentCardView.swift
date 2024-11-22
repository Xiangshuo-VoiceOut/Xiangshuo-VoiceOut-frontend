//
//  CommentCardView.swift
//
//  Created by Yujia Yang on 7/5/24.
//
import SwiftUI

struct CommentCardView: View {
    @StateObject var viewModel = CommentCardViewModel()
    var body: some View {
        VStack(alignment: .trailing, spacing: ViewSpacing.large) {
            if let user = viewModel.user {
                // 4451
                VStack(alignment: .leading, spacing: ViewSpacing.medium) {
                    // 4450
                    VStack(alignment: .leading, spacing: ViewSpacing.medium) {
                        // 4447
                        HStack(alignment: .center) {
                            // 4453
                            HStack(alignment: .center, spacing: ViewSpacing.small) {
                                // Ellipse356
                                AsyncImage(url: URL(string: user.profilePicture.id)) { phase in
                                    switch phase {
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 48, height: 48)
                                            .clipShape(Circle())

                                    default:
                                        Color.gray.frame(width: 48, height: 48)
                                        Text("Unable to load image").foregroundColor(.red)
                                    }
                                }
                                .frame(width: 48, height: 48)

                                Text(user.nickname)
                                    .font(Font.typography(.bodyLargeEmphasis))
                                    .foregroundColor(Color.textBrandSecondary)
                                    .frame(width: 108, alignment: .topLeading)
                            }
                            .cornerRadius(CornerRadius.xxxsmall.value)

                            Spacer()

                            // 4234
                            StarRatingViewInt(rating: user.comments.first?.rating ?? 0)
                                .padding(0)
                                .cornerRadius(CornerRadius.xxxsmall.value)

                        }
                        .frame(width: 326, alignment: .center)
                        .cornerRadius(CornerRadius.xxxsmall.value)
                    }
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .cornerRadius(CornerRadius.xxxsmall.value)
                    // comment
                    Text(user.comments.first?.comment ?? "")
                        .font(Font.typography(.bodyMedium))
                        .foregroundColor(.textPrimary)
                        .frame(width: 323, alignment: .topLeading)

                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .cornerRadius(CornerRadius.xxxsmall.value)

                // 4449
                HStack(alignment: .center, spacing: 0) {
                    Text(user.date)
                        .font(Font.typography(.bodySmall))
                        .foregroundColor(.textLight)

                    Spacer()

                    Text(user.state)
                        .font(Font.typography(.bodySmall))
                        .foregroundColor(.textLight)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .cornerRadius(CornerRadius.xxxsmall.value)
            } else if viewModel.isLoading {
                ProgressView()
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            } else {
                Text("Unable to load user data")
                    .foregroundColor(.red)
            }
        }
        .cardStyle()
        .frame(width: 358, height: 162)
        .onAppear {
            viewModel.loadTestData()
            // viewModel.fetchUser()
        }
    }
}

#Preview {
    CommentCardView()
}
