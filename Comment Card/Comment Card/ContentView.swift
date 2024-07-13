//
//  ContentView.swift
//  Comment Card
//
//  Created by Yujia Yang on 7/5/24.
//

import SwiftUI

struct StarRatingView: View {
    var rating: Int
    let maximumRating = 5
    let borderColor = Color(red: 0.98, green: 0.99, blue: 1)

    var body: some View {
        HStack {
            ForEach(1...maximumRating, id: \.self) { index in
                if index <= rating {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .overlay(
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(borderColor, lineWidth: 1)
                        )
                } else {
                    Image(systemName: "star")
                        .foregroundColor(.yellow)
                        .overlay(
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(borderColor, lineWidth: 1)
                        )
                }
            }
        }
    }
}




struct ContentView: View {
    @StateObject var viewModel = CommentCardViewModel()
    var body: some View {
        //即刻可约
        VStack(alignment: .trailing, spacing: 24) {
            if let user = viewModel.user {
                //4451
                VStack(alignment: .leading, spacing: 16) {
                    //4450
                    VStack(alignment: .leading, spacing: 16) {
                        //4447
                        HStack(alignment: .center) {
                            // Space Between
                            //4453
                            HStack(alignment: .center, spacing: 8) {
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
                                //text:快乐的小云朵
                                // Body XL
                                Text(user.nickname)
                                    .font(Font.custom("Alibaba PuHuiTi 3.0", size: 18))
                                    .foregroundColor(Color(red: 0.58, green: 0.64, blue: 0.93))
                                    .frame(width: 108, alignment: .topLeading)
                            }
                            .padding(0)
                            .cornerRadius(1)
                            Spacer()
                            // Alternative Views and Spacers
                            
                            //4234
                            StarRatingView(rating: user.comments.first?.rating ?? 0)
                                .padding(0)
                                .cornerRadius(1)
                                
                        }
                        .padding(0)
                        .frame(width: 326, alignment: .center)
                        .cornerRadius(1)
                    }
                    .padding(0)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .cornerRadius(1)
                    
                    //comment
                    // Body
                    Text(user.comments.first?.comment ?? "")
                        .font(Font.custom("Alibaba PuHuiTi 3.0", size: 16))
                        .foregroundColor(Color(red: 0.26, green: 0.19, blue: 0.15))
                        .frame(width: 323, alignment: .topLeading)
                    
                }
                .padding(0)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .cornerRadius(1)
                
                //4449
                HStack(alignment: .center) {
                    // Space Between
                    //date
                    // Small
                    Text(user.date)
                        .font(Font.custom("Alibaba PuHuiTi 3.0", size: 14))
                        .foregroundColor(Color(red: 0.7, green: 0.64, blue: 0.61))
                    
                    Spacer()
                    // Alternative Views and Spacers
                    //location
                    // Small
                    Text(user.state)
                        .font(Font.custom("Alibaba PuHuiTi 3.0", size: 14))
                        .foregroundColor(Color(red: 0.47, green: 0.4, blue: 0.36))
                }
                .padding(0)
                .frame(maxWidth: .infinity, alignment: .center)
                .cornerRadius(1)
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
                    //viewModel.fetchUser()
        }
        .padding(16)
        .frame(width: 358, alignment: .bottomTrailing)
        .background(Color(red: 0.98, green: 0.99, blue: 1))
        .cornerRadius(16)
        .shadow(color: Color(red: 0.35, green: 0.46, blue: 0.65).opacity(0.04), radius: 10, x: 2, y: 12)
        
        
    }
}

#Preview {
    ContentView()
}
