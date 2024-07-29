//
//  RegistrationFormView.swift
//  voiceout
//
//  Created by J. Wu on 7/23/24.
//

import SwiftUI

struct RegistrationFormView: View {
//    @AppStorage("currentStep") private var currentStep: Int = 0
    @State private var currentStep: Int = 3
    @State private var totalSteps = 4
    @StateObject var registrationVM = TherapistRegistrationVM()
    var titles = ["basic_info", "degree_info", "certificate_info", "consultant_service"]
    
    var body: some View {
        NavigationView{
            ZStack{
                BackgroundView()
                
                VStack{
                    StepProgressView(totalSteps: $totalSteps, currentStep: $currentStep)
                        .padding(.horizontal, ViewSpacing.large)
                        .padding(.vertical, ViewSpacing.large)
                    
                    ScrollView{
                        formContent(for: currentStep)
                            .padding()
                            .padding(.bottom, ViewSpacing.xlarge)
                            
                        
                        
                        ButtonView(text: currentStep < totalSteps-1 ? "next_step" : "finished", action: {
                            if currentStep < totalSteps - 1{
                                currentStep += 1
                            } else{
                                //                        completeRegistration()
                            }
                        },
                                   theme: registrationVM.isNextStepEnabled || registrationVM.finished ? .action : .base,
                                   spacing: .large
                        )
                        .padding()
                        .disabled(!registrationVM.isNextStepEnabled)
                    }
                }
            }
            .navigationTitle(currentStep < titles.count ? NSLocalizedString(titles[currentStep], comment: "") : "")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    @ViewBuilder
    private func formContent(for step: Int) -> some View {
        switch step{
        case 0:
            BasicInfo()
        case 1:
            SchoolInfo()
        case 2:
            CertificateInfo()
        case 3:
            ConsultantService()
        default:
            BasicInfo()
        }
    }
}

#Preview {
    RegistrationFormView()
}
