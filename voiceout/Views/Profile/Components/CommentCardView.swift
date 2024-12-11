//
//  CommentCardView.swift
//  voiceout
//
//  Created by Yujia Yang on 7/5/24.
//
import SwiftUI

struct CommentCardGeneralView: View {
    @StateObject var viewModel = CommentCardViewModel()
    var isConsultantMode: Bool = false 

    var body: some View {
        VStack(alignment: .leading, spacing: ViewSpacing.medium) {
            HStack(alignment: .top, spacing: ViewSpacing.base) {
                AsyncImage(url: URL(string: viewModel.userComments.first?.profilePicture ?? "")) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 48, height: 48)
                            .clipShape(Circle())
                    case .failure:
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 48, height: 48)
                    default:
                        ProgressView()
                            .frame(width: 48, height: 48)
                    }
                }
                VStack(alignment: .leading, spacing: ViewSpacing.small) {
                    if let nickName = viewModel.userComments.first?.nickName {
                        Text(nickName)
                            .font(Font.typography(.bodyLarge))
                            .foregroundColor(isConsultantMode ? .textBrandSecondary : .textSecondary)
                    }
                    if let feedback = viewModel.userComments.first?.feedback {
                        Text(feedback)
                            .font(Font.typography(.bodyMedium))
                            .foregroundColor(.textPrimary)
                    }
                }
            }

            HStack {
                Spacer()
                if let timestamp = viewModel.userComments.first?.createTimestamp {
                    Text(timestamp.formattedDateYYYYChinese)
                        .font(Font.typography(.bodySmall))
                        .foregroundColor(.textSecondary)
                }
            }
        }
        .padding(ViewSpacing.medium)
        .background(Color.surfacePrimary)
        .cornerRadius(CornerRadius.medium.value)
        .shadow(color: Color(red: 0.35, green: 0.46, blue: 0.65).opacity(0.04), radius: 10, x: 2, y: 12)
        .fixedSize(horizontal: false, vertical: true)
        .onAppear {
            viewModel.fetchUser()
        }
    }
}

struct CommentCardView: View {
    var body: some View {
        VStack {
            CommentCardGeneralView(isConsultantMode: false)

            CommentCardGeneralView(isConsultantMode: true)
        }
    }
}


#Preview {
    CommentCardView()
}

