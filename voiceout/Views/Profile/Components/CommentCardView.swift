//
//  ContentView.swift
//  Comment Card
//
//  Created by Yujia Yang on 7/5/24.
//
import SwiftUI

struct CommentCardView: View {
    @StateObject var viewModel = CommentCardViewModel()

    var body: some View {
        NavigationView {
            CardView(content: {
                VStack(alignment: .trailing, spacing: ViewSpacing.large) {
                    if let user = viewModel.user {
                        VStack(alignment: .leading, spacing: ViewSpacing.medium) {
                            VStack(alignment: .leading, spacing: ViewSpacing.medium) {
                                HStack(alignment: .center) {
                                    HStack(alignment: .center, spacing: ViewSpacing.small) {
                                        AsyncImage(url: URL(string: user.profilePicture)) { phase in
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
                                    .padding(0)
                                    .cornerRadius(CornerRadius.xxxsmall.value)

                                    Spacer()

                                    StarRatingViewInt(rating: .constant(user.comments.first?.rating ?? 0))
                                        .padding(0)
                                        .cornerRadius(CornerRadius.xxxsmall.value)

                                }
                                .padding(0)
                                .frame(width: 326, alignment: .center)
                                .cornerRadius(CornerRadius.xxxsmall.value)
                            }
                            .padding(0)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .cornerRadius(CornerRadius.xxxsmall.value)
                            Text(user.comments.first?.comment ?? "")
                                .font(Font.typography(.bodyMedium))
                                .foregroundColor(.textPrimary)
                                .frame(width: 323, alignment: .topLeading)

                        }
                        .padding(0)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .cornerRadius(CornerRadius.xxxsmall.value)

                        HStack(alignment: .center) {
                            Text(user.date)
                                .font(Font.typography(.bodySmall))
                                .foregroundColor(.textLight)

                            Spacer()

                            Text(user.state)
                                .font(Font.typography(.bodySmall))
                                .foregroundColor(.textLight)
                        }
                        .padding(0)
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
                .onAppear {
                    viewModel.loadTestData()
                    // viewModel.fetchUser()
                }
            }, modifiers: CardModifiers(
                padding: EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16),
                backgroundColor: Color.grey50,
                cornerRadius: CornerRadius.medium.value,
                shadow1Color: Color(red: 0.36, green: 0.36, blue: 0.47).opacity(0.03),
                shadow1Radius: 8.95,
                shadow1X: 5,
                shadow1Y: 3,
                shadow2Color: Color(red: 0.15, green: 0.15, blue: 0.25).opacity(0.08),
                shadow2Radius: 5.75,
                shadow2X: 2,
                shadow2Y: 4
                ))
                .frame(width: 358, height: 162)
            }
        }
    }

#Preview {
    CommentCardView()
}
