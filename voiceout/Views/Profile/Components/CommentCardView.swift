//
//  CommentCardView.swift
//
//  Created by Yujia Yang on 7/5/24.
//
import SwiftUI

struct CommentCardView: View {
    @StateObject var viewModel = CommentCardViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: ViewSpacing.medium) { 
            HStack(alignment: .top, spacing: ViewSpacing.base) {
                AsyncImage(url: URL(string: viewModel.user?.profilePicture.id ?? "")) { phase in
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
                VStack(alignment: .leading, spacing: ViewSpacing.small) {
                    Text(viewModel.user?.nickname ?? "")
                        .font(Font.typography(.bodyLarge))
                        .foregroundColor(Color.textPrimary)

                    Text(viewModel.user?.comments.first?.comment ?? "")
                        .font(Font.typography(.bodyMedium))
                        .foregroundColor(.textPrimary)
                }
            }
            HStack {
                Spacer()
                Text(viewModel.user?.date ?? "")
                    .font(Font.typography(.bodySmall))
                    .foregroundColor(.textLight)
            }
        }
        .padding(ViewSpacing.medium)
        .background(Color.surfacePrimary)
        .cornerRadius(CornerRadius.medium.value)
        .shadow(color: Color(red: 0.35, green: 0.46, blue: 0.65).opacity(0.04), radius: 10, x: 2, y: 12)
        .fixedSize(horizontal: false, vertical: true)
        .onAppear {
            viewModel.loadTestData()
        }
    }
}

#Preview {
    CommentCardView()
}
