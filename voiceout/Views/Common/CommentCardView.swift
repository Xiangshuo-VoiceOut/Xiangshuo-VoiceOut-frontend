//
//  ContentView.swift
//  Comment Card
//
//  Created by Yujia Yang on 7/5/24.
//

import SwiftUI
struct StarRatingView1: View {
    var rating: Int
    let maximumRating = 5
    //let borderColorStar = Color(red: 0.98, green: 0.99, blue: 1)

    var body: some View {
        HStack {
            ForEach(1...maximumRating, id: \.self) { index in
                if index <= rating {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .overlay(
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(borderColorStar, lineWidth: 1)
                        )
                } else {
                    Image(systemName: "star")
                        .foregroundColor(.yellow)
                        .overlay(
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(borderColorStar, lineWidth: 1)
                        )
                }
            }
        }
    }
}

struct CommentCardView: View {
    @StateObject var viewModel = CommentCardViewModel()
    var body: some View {
        //即刻可约
        VStack(alignment: .trailing, spacing: ViewSpacing.large) {
            if let user = viewModel.user {
                //4451
                VStack(alignment: .leading, spacing: ViewSpacing.medium) {
                    //4450
                    VStack(alignment: .leading, spacing: ViewSpacing.medium) {
                        //4447
                        HStack(alignment: .center) {
                            //4453
                            HStack(alignment: .center, spacing: ViewSpacing.small) {
                                //Ellipse356
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
                            .padding(0)
                            .cornerRadius(CornerRadius.xxxsmall.value)
                            
                            Spacer()
                            
                            //4234
                            StarRatingView1(rating: user.comments.first?.rating ?? 0)
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
                    //comment
                    Text(user.comments.first?.comment ?? "")
                        .font(Font.typography(.bodyMediumEmphasis))
                        .foregroundColor(.textPrimary)
                        .frame(width: 323, alignment: .topLeading)
                    
                }
                .padding(0)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .cornerRadius(CornerRadius.xxxsmall.value)
                
                //4449
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
                    //viewModel.loadTestData()
                    viewModel.fetchUser()
        }
        .padding(ViewSpacing.medium)
        .frame(width: 358, alignment: .bottomTrailing)
        .background(Color.surfacePrimary)
        .cornerRadius(CornerRadius.medium.value)
        .shadow(color: Color(red: 0.35, green: 0.46, blue: 0.65).opacity(0.04), radius: 10, x: 2, y: 12)
        
        
    }
}



#Preview {
    CommentCardView()
}
