//
//  HeaderView.swift
//  voiceout
//
//  Created by J. Wu on 6/9/24.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        HStack(spacing: ViewSpacing.medium) {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: LogoSize.medium)
                .clipShape(Circle())
                .padding(.trailing, ViewSpacing.small)

            Text("slogan")
                .font(.typography(.bodyMedium))
                .foregroundColor(Color.textSecondary)
        }
    }
}

#Preview {
    HeaderView()
}
