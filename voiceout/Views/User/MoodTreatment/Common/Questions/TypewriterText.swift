//
//  TypewriterText.swift
//  voiceout
//
//  Created by Yujia Yang on 9/9/25.
//

import SwiftUI

struct TypewriterText: View {
    public let fullText: String
    public let characterDelay: TimeInterval
    public var onComplete: (() -> Void)? = nil

    @State private var displayedCount: Int = 0
    @State private var timer: Timer?

    init(fullText: String,
         characterDelay: TimeInterval = 0.05,
         onComplete: (() -> Void)? = nil) {
        self.fullText = fullText
        self.characterDelay = characterDelay
        self.onComplete = onComplete
    }

    var body: some View {
        Text(String(fullText.prefix(displayedCount)))
            .onAppear {
                displayedCount = 0
                timer?.invalidate()
                timer = Timer.scheduledTimer(withTimeInterval: characterDelay,
                                             repeats: true) { t in
                    if displayedCount < fullText.count {
                        displayedCount += 1
                    } else {
                        t.invalidate()
                        onComplete?()
                    }
                }
                RunLoop.main.add(timer!, forMode: .common)
            }
            .onDisappear { timer?.invalidate() }
    }
}
