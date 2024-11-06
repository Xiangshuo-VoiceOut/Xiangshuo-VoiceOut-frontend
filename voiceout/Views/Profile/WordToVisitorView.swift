//
//  WordToVisitorView.swift
//  voiceout
//
//  Created by Jiaqi Chen on 10/22/24.
//

import Foundation
import SwiftUI

struct WordToVisitorView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("想对来访者说的话")
                    .foregroundColor(.textBrandPrimary)
                    .font(.system(size: 18, weight: .bold))
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
            
            Text("""
            作为您的心理咨询师，...
            """)
            .foregroundColor(.textSecondary)
            .font(.system(size: 14))
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .gray.opacity(0.2), radius: 2)
    }
}

struct WordToVisitorView_Previews: PreviewProvider {
    static var previews: some View {
        WordToVisitorView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
