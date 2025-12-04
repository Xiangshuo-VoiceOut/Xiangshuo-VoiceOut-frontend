//
//  LottieAnimationView.swift
//  voiceout
//
//  Created by Yujia Yang on 5/18/25.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    let animationName: String
    let loopMode: LottieLoopMode
    let autoPlay: Bool
    let onFinished: (() -> Void)?
    let speed: CGFloat

    init(
        animationName: String,
        loopMode: LottieLoopMode = .loop,
        autoPlay: Bool = true,
        onFinished: (() -> Void)? = nil,
        speed: CGFloat = 1.0
    ) {
        self.animationName = animationName
        self.loopMode = loopMode
        self.autoPlay = autoPlay
        self.onFinished = onFinished
        self.speed = speed
    }

    class Coordinator {
        var animationView: LottieAnimationView?
        var onFinished: (() -> Void)?
    }

    func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator()
        coordinator.onFinished = onFinished
        return coordinator
    }

    func makeUIView(context: Context) -> UIView {
        let container = UIView(frame: .zero)

        let animationView = LottieAnimationView(name: animationName)
        animationView.loopMode = loopMode
        animationView.animationSpeed = speed
        animationView.contentMode = .scaleAspectFit
        animationView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            animationView.topAnchor.constraint(equalTo: container.topAnchor),
            animationView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])

        context.coordinator.animationView = animationView

        if autoPlay {
            animationView.play { finished in
                if finished {
                    context.coordinator.onFinished?()
                }
            }
        } else {
            animationView.pause()
            animationView.currentProgress = 0
        }

        return container
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        guard let animationView = context.coordinator.animationView else { return }
        animationView.animationSpeed = speed
//        if autoPlay && !animationView.isAnimationPlaying {
//            animationView.play { finished in
//                if finished {
//                    context.coordinator.onFinished?()
//                }
//            }
//        }
    }
}
