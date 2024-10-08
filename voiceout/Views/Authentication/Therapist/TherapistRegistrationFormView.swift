//
//  RegistrationFormView.swift
//  voiceout
//
//  Created by J. Wu on 7/23/24.
//

import SwiftUI

struct RegistrationFormView: View {
    @EnvironmentObject var router: RouterModel
    @StateObject private var popupViewModel = PopupViewModel()
    @StateObject private var textInputVM: TextInputVM
    @StateObject private var timeInputVM: TimeInputViewModel
    @StateObject private var registrationVM: TherapistRegistrationVM
    @Environment(\.safeAreaInsets) private var safeAreaInsets

    var titles = ["basic_info", "degree_info", "certificate_info", "consultant_service", "payment_information", "consultant_time"]

    init() {
        let textInputModel = TextInputVM()
        let timeInputModel = TimeInputViewModel()
        _textInputVM = StateObject(wrappedValue: textInputModel)
        _timeInputVM = StateObject(wrappedValue: timeInputModel)
        _registrationVM =  StateObject(wrappedValue: TherapistRegistrationVM(textInputVM: textInputModel, timeInputVM: timeInputModel))
    }

    var body: some View {
        ZStack {
            BackgroundView(backgroundType: .surfacePrimaryGrey)

            StickyHeaderView(
                title: titles[registrationVM.currentStep],
                leadingComponent: AnyView(
                    BackButtonView(action: registrationVM.goToPreviousStep)
                )
            )

            VStack(spacing: 0) {
                StepProgressView(
                    totalSteps: $registrationVM.totalSteps,
                    currentStep: $registrationVM.currentStep
                )
                .padding(.top, safeAreaInsets.top + 83)
                .padding(.bottom, ViewSpacing.xlarge)

                GeometryReader { geometry in
                    ScrollView(showsIndicators: false) {
                        VStack {
                            formContent(for: registrationVM.currentStep)
                                .environmentObject(registrationVM)
                                .environmentObject(textInputVM)
                                .environmentObject(timeInputVM)

                            Spacer()

                            ButtonView(
                                text: registrationVM.currentStep < registrationVM.totalSteps - 1 ? "next_step" : "confirmation",
                                action: registrationVM.goToNextStep,
                                theme: registrationVM.isNextStepEnabled ? .action : .base,
                                spacing: .large
                            )
                            .padding(.bottom, ViewSpacing.medium)
                            .padding(.top, ViewSpacing.xlarge)
                            .disabled(!registrationVM.isNextStepEnabled)
                        }
                        .frame(minHeight: geometry.size.height)
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            .padding(.horizontal, ViewSpacing.large)
            .popup(with: .popupViewModel(popupViewModel))
        }
        .environmentObject(popupViewModel)
    }

    @ViewBuilder
    private func formContent(for step: Int) -> some View {
        switch step {
        case 0:
            BasicInfoView()
        case 1:
            EducationBackgroundView()
        case 2:
            CertificateInfoView()
        case 3:
            ConsultTypesView()
        case 4:
            BankInformationView()
        case 5:
            AvailableTimesView()
        default:
            BasicInfoView()
        }
    }
}

#Preview {
    RegistrationFormView()
}
