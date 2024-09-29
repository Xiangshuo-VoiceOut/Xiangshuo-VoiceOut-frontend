//
//  CertificateInfoView.swift
//  voiceout
//
//  Created by J. Wu on 7/23/24.
//

 import SwiftUI

 struct CertificateInfoView: View {
    @StateObject private var registrationVM: TherapistRegistrationVM

    init() {
        _registrationVM = StateObject(wrappedValue: TherapistRegistrationVM())
    }

    var body: some View {
        VStack {
            ForEach(Array(registrationVM.certificateInfos.enumerated()), id: \.offset) { index, viewModel in
                certificateInfoSection(
                    viewModel: viewModel,
                    index: index
                )
            }

            ButtonView(
                text: "add_new_degree",
                action: registrationVM.addCertificateInfo,
                variant: .outline,
                borderRadius: .small,
                maxWidth: .infinity,
                suffixIcon: AnyView(
                    Image("add")
                        .foregroundColor(Color.brandPrimary)
                        .frame(width: 16, height: 16)
                )
            )
            .padding(.horizontal, ViewSpacing.xxxsmall)
        }
    }

    @ViewBuilder
    private func certificateInfoSection(
        @ObservedObject viewModel: CertificateInfoData,
        index: Int
    ) -> some View {
//        let binding = Binding{
//            registrationVM.certificateInfos[index]
//        } set: {
//            registrationVM.certificateInfos[index] = $0
//        }

        VStack(alignment: .leading, spacing: ViewSpacing.small) {
           Dropdown(
                selectionOption: $viewModel.type,
                label: "certificate_type",
                placeholder: String(localized: "certificate_type_placeholder"),
                options: DropdownOption.certificates,
                backgroundColor: .white
            )
            .overlay(
                GeometryReader { geometry in
                    if registrationVM.certificateInfos.count > 1 && index < registrationVM.certificateInfos.count - 1 {
                        Button(
                            action: {
                                registrationVM.removeCertificateInfo(at: index)
                            }
                        ) {
                            Image("delete")
                                .foregroundColor(.grey300)
                            Text("remove")
                                .foregroundColor(.textLight)
                                .font(.typography(.bodyMedium))
                        }
                        .position(x: geometry.size.width - 50, y: geometry.size.height * 0.2)
                    }
                }
            )

            TextInputView(
                text: $viewModel.id,
                label: "ID",
                isSecuredField: false,
                placeholder: "ID_placeholder",
                validationState: ValidationState.neutral,
                theme: .white
            )
            .autocapitalization(.none)

            TextInputView(
                text: $viewModel.expiryDate,
                label: "certificate_expiration_date",
                isSecuredField: false,
                placeholder: "date_placeholder",
                validationState: ValidationState.neutral,
                theme: .white
            )
            .autocapitalization(.none)

            Dropdown(
                selectionOption: $viewModel.certificateLocation,
                label: "location_state",
                placeholder: String(localized: "certificate_location"),
                options: registrationVM.allStates,
                backgroundColor: .white
            )

            Text("upload_certificate_image")
                .font(.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
            ImagePickerView()
                .padding(.bottom, ViewSpacing.xlarge)
        }

    }
 }

 #Preview {
    CertificateInfoView()
 }
