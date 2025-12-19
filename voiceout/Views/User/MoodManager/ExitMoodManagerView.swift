//
//  ExitMoodManagerView.swift
//  voiceout
//
//  Created by Yujia Yang on 4/2/25.
//

import SwiftUI

struct ExitMoodManagerView: View {
    var didClose: () -> Void
    var didConfirm: () -> Void
    
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: ViewSpacing.medium) {
                Text(LocalizedStringKey("exit_mood_manager_confirmation"))
                    .font(Font.typography(.bodyMedium))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .top)
                
                Color.clear
                    .frame(height: 32)
                
                HStack(alignment: .center, spacing: ViewSpacing.medium) {
                    ButtonView(
                        text: "cancel",
                        action: {
                            didClose()
                        },
                        variant: .outline,
                        theme: .base,
                        fontSize: .medium,
                        borderRadius: .full,
                        maxWidth: 300
                    )
                    .shadow(
                        color: Color(red: 0.35, green: 0.46, blue: 0.65).opacity(0.04),
                        radius: 10,
                        x: 2,
                        y: 12
                    )
                    
                    ButtonView(
                        text: "confirmation",
                        action: {
                            didConfirm()
                        },
                        variant: .solid,
                        theme: .action,
                        fontSize: .medium,
                        borderRadius: .full,
                        maxWidth: 300
                    )
                    .shadow(
                        color: Color(red: 0.35, green: 0.46, blue: 0.65).opacity(0.04),
                        radius: 10,
                        x: 2,
                        y: 12
                    )
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(ViewSpacing.large)
            .frame(width: 342, alignment: .center)
            .background(Color.surfacePrimary)
            .cornerRadius(CornerRadius.medium.value)
        }
    }
}

#Preview{
    ExitMoodManagerView(
        didClose: {},
        didConfirm: {}
    )
}
