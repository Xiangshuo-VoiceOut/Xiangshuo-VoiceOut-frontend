//
//  FinishView.swift
//  voiceout
//
//  Created by J. Wu on 7/8/24.
//

import SwiftUI
import Combine

struct FinishView: View {
    @EnvironmentObject var router: RouterModel
    @State var title: String
    @State var countdown: Int = 3
    @State private var timer: AnyCancellable?

    var body: some View {
        ZStack {
            BackgroundView()

            StickyHeaderView(
                trailingComponent: AnyView(
                    Button(action: {
                        router.navigateTo(.userLogin)
                    }) {
                        Text("login")
                            .font(.typography(.bodyMedium))
                            .foregroundColor(.black.opacity(0.69))
                    }
                )
            )

            GeometryReader { geometry in
                HeaderView()
                    .position(
                        x: geometry.size.width / 2,
                        y: geometry.size.height * 0.2
                    )
            }

            VStack {
                Text(title)
                    .font(.typography(.headerMedium))
                    .foregroundColor(Color.textPrimary)
                    .padding(.bottom, ViewSpacing.small)
                Text("navigate_to_login")
                    .font(.typography(.bodyLarge))
                    .foregroundColor(Color.textPrimary)
                    .padding(.bottom, ViewSpacing.small)
                Text("\(countdown)S")
                    .font(.typography(.headerSmall))
                    .foregroundColor(Color.textPrimary)
                    .padding(.bottom)
            }
        }
        .onAppear {
            startCountdown()
        }
    }

    private func startCountdown() {
        timer = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink {_ in
                if countdown > 0 {
                    countdown -= 1
                } else {
                    timer?.cancel()
                    router.navigateTo(.userLogin)
                }

            }
    }
}

#Preview {
    FinishView(title: "注册成功")
        .environmentObject(RouterModel())
}
