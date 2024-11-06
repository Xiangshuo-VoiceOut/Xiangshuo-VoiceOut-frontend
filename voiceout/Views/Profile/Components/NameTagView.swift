//
//  CardView.swift
//  voiceout
//
//  Created by Jiaqi Chen on 10/15/24.
//

import Foundation
import SwiftUI


//  TODO: 1. Personal pic Redesign - align with Figma
//  TODO: 2. Edit feature - pencil button action and variable passing
struct NameTagView: View {
    var name: String
    var consultingPrice: String
    var personalTitle: String
    var profileImage: Image
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                // placeholder for image
                profileImage
                    .resizable()
                    .frame(width: 88, height: 88)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                
                Spacer()
                
                Button(action: {
                    // placeholder for edit page
                }) {
                    Image(systemName: "pencil")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.borderLight)
                }
            }
            .padding(.horizontal)
            
            HStack {
                // Name on the left
                Text(name)
                    .font(.system(size: 32, weight: .bold))

                Spacer()

                // Price and title on the right
                VStack(alignment: .trailing) {
                    Text(consultingPrice)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.orange)

                    Text(personalTitle)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .padding(.top, 1.0)
                }
            }
            .padding(.horizontal)
        }
        .padding()
//        .frame(width: 358, height: 124)
        .background(RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                        .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2))
        .padding()
    }
}

struct NameTagView_Previews: PreviewProvider {
    static var previews: some View {
        NameTagView(
            name: "董丽华",
            consultingPrice: "$200/次",
            personalTitle: "专攻青少年焦虑情绪问题",
            profileImage: Image(systemName: "person.circle") // Placeholder image
        )
    }
}
