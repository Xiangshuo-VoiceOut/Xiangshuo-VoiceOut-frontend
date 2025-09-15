//
//  ProgressViewModel.swift
//  voiceout
//
//  Created by Yujia Yang on 5/14/25.
//

import SwiftUI

class ProgressViewModel: ObservableObject {
    @Published var progressWidth: CGFloat = 0
    var fullWidth: CGFloat = UIScreen.main.bounds.width - 32
    
    func updateProgress(currentIndex: Int?, totalQuestions: Int?) {
        guard let total = totalQuestions, let index = currentIndex, total > 0 else {
            return
        }

        let newProgress = CGFloat(index - 1) / CGFloat(total - 1) * fullWidth

        DispatchQueue.main.async {
            withAnimation(.easeInOut(duration: 0.3)) {
                self.progressWidth = newProgress
            }
        }
    }

    func resetProgress() {
        DispatchQueue.main.async {
            withAnimation(.easeInOut(duration: 0.3)) {
                self.progressWidth = 0
            }
        }
    }
}
