//
//  CertificateInfo.swift
//  voiceout
//
//  Created by J. Wu on 7/23/24.
//

import SwiftUI

struct CertificateInfo: View {
    @StateObject private var registrationVM: TherapistRegistrationVM
    
    init() {
        _registrationVM = StateObject(wrappedValue: TherapistRegistrationVM())
    }
    
    var body: some View {
        VStack{
            ForEach(Array(registrationVM.certificateInfos.enumerated()), id: \.offset) { index, viewModel in
                certificateInfoSection(viewModel: viewModel, index: index)
            }
            
            AddButton(action: registrationVM.addCertificateInfo, text: "add_new_certificate")
                .padding(.top, ViewSpacing.small)
            
        }
        
    }
    
    @ViewBuilder
    private func certificateInfoSection(@ObservedObject viewModel: CertificateInfoData, index: Int) -> some View {

        
//        let binding = Binding{
//            registrationVM.certificateInfos[index]
//        } set: {
//            registrationVM.certificateInfos[index] = $0
//        }
        
        VStack(alignment:.leading, spacing: ViewSpacing.small) {
            HStack {
                Text("certificate_type")
                    .font(.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
                
                if registrationVM.certificateInfos.count > 1 && index < registrationVM.certificateInfos.count - 1 {
                    Spacer()
                    Button(action: {registrationVM.removeCertificateInfo(at: index)
                    }) {
                        Image("delete")
                        Text("remove")
                            .foregroundColor(.textLight)
                            .font(.typography(.bodyMedium))
                    }
                }
            }
            
            Dropdown(selectionOption: $viewModel.type, placeholder: String(localized: "certificate_type_placeholder"), options: DropdownOption.certificates, backgroundColor: .white)
                            .padding(.bottom, ViewSpacing.large)
                            .zIndex(6)
            
            Text("ID")
                .font(.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
            TextInputView(
                text: $viewModel.id,
                isSecuredField: false,
                placeholder: "ID_placeholder",
                validationState: ValidationState.neutral,
                theme: .white
            )
            .autocapitalization(.none)
            .padding(.bottom)
            
            Text("certificate_expiration_date")
                .font(.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
            TextInputView(
                text: $viewModel.expiryDate,
                isSecuredField: false,
                placeholder: "date_placeholder",
                validationState: ValidationState.neutral,
                theme: .white
            )
            .autocapitalization(.none)
            .padding(.bottom)
        
            
            Text("location_state")
                .font(.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
            
            Dropdown(selectionOption: $viewModel.certificateLocation, placeholder: String(localized: "certificate_location"), options: registrationVM.allStates, backgroundColor: .white)
                .padding(.bottom, ViewSpacing.large)
                .zIndex(6)
            Text("upload_certificate_image")
                .font(.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
            
            ImagePickerView()
                .padding(.bottom, ViewSpacing.xxlarge)
        }
        
    }
}

#Preview {
    CertificateInfo()
}
