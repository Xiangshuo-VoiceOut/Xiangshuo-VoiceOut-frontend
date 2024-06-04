//
//  HeaderView.swift
//  voiceout
//
//  Created by J. Wu on 6/9/24.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        HStack{
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(width: LogoSize.medium)
                .clipShape(Circle())
                .padding(.trailing, ViewSpacing.small)
            
            
            VStack(alignment: .leading) {
                Spacer().frame(height: ViewSpacing.medium)
                
                Text("slogan")
                    .font(.typography(.bodyMedium))
                    .foregroundColor(Color(.textSecondary))
            }
        }
        .padding(.vertical, ViewSpacing.large)
        .frame(maxWidth: .infinity, alignment:.center)
    }
}

#Preview {
    HeaderView()
}
