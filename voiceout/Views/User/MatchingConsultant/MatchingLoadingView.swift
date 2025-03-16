//
//  MatchingLoadingView.swift
//  voiceout
//
//  Created by Yujia Yang on 2/2/25.
//

import SwiftUI

struct Step {
    let title: String
}

struct VerticalStepProgressView: View {
    var steps: [Step]
    @Binding var currentStep: Int

    var body: some View {
        VStack(spacing: 0) {
            ForEach(steps.indices, id: \.self) { index in
                VStack(spacing: 0) {
                    ZStack {
                        Circle()
                            .fill(index < currentStep ? Color.brandPrimary : Color.clear)
                            .frame(width: 24, height: 24)
                        
                        if index < currentStep {
                            Image("check-small")
                                .frame(width: 16, height: 16)
                                .transition(.opacity)
                        } else {
                            Circle()
                                .stroke(Color.brandPrimary, lineWidth: 1)
                                .frame(width: 24, height: 24)
                                .opacity(0)
                        }
                    }
                    .animation(.easeInOut(duration: 0.5), value: currentStep)
                    
                    if index < steps.count - 1 {
                        Rectangle()
                            .frame(width: 2, height: 26)
                            .foregroundColor(Color.borderBrandPrimary)
                            .scaleEffect(y: index < currentStep ? 1 : 0, anchor: .top)
                            .opacity(index < currentStep ? 1 : 0)
                            .animation(.easeInOut(duration: 1), value: currentStep)
                    }
                }
            }
        }
    }
}

struct MatchingLoadingView: View {
    @State private var showExitPopup = false
    @EnvironmentObject var router: RouterModel
    @State private var currentStep: Int = 0


    let steps: [Step] = [
        Step(title: "问题分析完成"),
        Step(title: "寻找匹配的咨询师完成"),
        Step(title: "正在分析咨询师匹配合适度……"),
        Step(title: "等待返回最佳的匹配结果……")
    ]

    var body: some View {
        ZStack(alignment: .top) {
            Color.surfacePrimaryGrey2
                .edgesIgnoringSafeArea(.all)

            VStack {
                VStack(spacing: ViewSpacing.large) {
                    HStack(alignment: .center) {
                        Image("cloud2")
                            .frame(width: 166.21063, height: 96.20775)

                        Spacer()

                        Text("请稍等，正在为您匹配合适的咨询师！")
                            .font(.typography(.bodyMedium))
                            .foregroundColor(.grey300)
                            .padding(ViewSpacing.medium)
                            .background(Color.surfacePrimary)
                            .cornerRadius(CornerRadius.medium.value)
                    }
                    .padding(.top, 4 * ViewSpacing.medium)
                }
                .padding(.horizontal, ViewSpacing.medium)
                .onAppear {
                    animateSteps()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 11) {
                        router.navigateTo(.matchingTherapistView)
                    }
                }

                Spacer()

                HStack(alignment: .center, spacing: ViewSpacing.medium) {
                    VerticalStepProgressView(steps: steps, currentStep: $currentStep)
                        .frame(width: 25)

                    VStack(alignment: .leading, spacing: ViewSpacing.large) {
                        ForEach(steps.indices, id: \.self) { index in
                            Text(steps[index].title)
                                .font(.typography(.bodyMedium))
                                .foregroundColor(index < currentStep ? .textPrimary : .grey500)
                                .opacity(index < currentStep ? 1 : 0)
                                .animation(.easeInOut(duration: 0.5), value: currentStep)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(ViewSpacing.xlarge)
                .background(Color.grey50)
                .cornerRadius(CornerRadius.medium.value)
                .padding(.horizontal, ViewSpacing.xlarge)
                .padding(.bottom, 8 * ViewSpacing.betweenSmallAndBase)
            }
        }
    }

    private func animateSteps() {
        for i in 0..<steps.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i * 3)) {
                withAnimation {
                    currentStep = i + 1
                }
            }
        }
    }
}

#Preview {
    MatchingLoadingView()
        .environmentObject(RouterModel())
}
