//
//  RegistrationFormView.swift
//  voiceout
//
//  Created by J. Wu on 7/23/24.
//

import SwiftUI

struct RegistrationFormView: View {
//    @AppStorage("currentStep") private var currentStep: Int = 0
    @State private var currentStep: Int = 0
    @State private var totalSteps = 6
    @StateObject var registrationVM = TherapistRegistrationVM()
    var titles = ["basic_info", "degree_info", "certificate_info", "consultant_service", "payment_information", "consultant_time"]

    var body: some View {
        ZStack {
            BackgroundView(backgroundType: .surfacePrimaryGrey)

            VStack(spacing: 0) {
                StepProgressView(
                    totalSteps: $totalSteps,
                    currentStep: $currentStep
                )
                .padding(.vertical, ViewSpacing.xxlarge)

                ScrollView {
                    formContent(for: currentStep)
                        .padding(.bottom, ViewSpacing.xxlarge)

                    ButtonView(
                        text: currentStep < totalSteps - 1 ?
                            "next_step" : "confirmation",
                        action: {
                            if currentStep < totalSteps - 1 {
                                currentStep += 1
                            } else {
                                // completeRegistration()
                            }
                        },
                        theme: registrationVM.isNextStepEnabled || registrationVM.finished ? .action : .base,
                                       spacing: .large
                    )
                    .padding(.bottom, ViewSpacing.medium)
//                       .disabled(!registrationVM.isNextStepEnabled)
                }
            }
            .padding(.horizontal, ViewSpacing.large)
        }
    }

    @ViewBuilder
    private func formContent(for step: Int) -> some View {
        switch step {
        case 0:
            BasicInfoView()
//        case 1:
//            SchoolInfo()
//        case 2:
//            CertificateInfo()
//        case 3:
//            ConsultantService()
//        case 4:
//            BankInformation()
//        case 5:
//            TimeAvailability()
        default:
            BasicInfoView()
        }
    }
}

#Preview {
    RegistrationFormView()
}
