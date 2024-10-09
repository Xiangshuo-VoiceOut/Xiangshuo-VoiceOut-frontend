//
//  CertificateInfoView.swift
//  voiceout
//
//  Created by J. Wu on 7/23/24.
//

 import SwiftUI

 struct CertificateInfoView: View {
     @EnvironmentObject var registrationVM: TherapistRegistrationVM

    var body: some View {
        VStack {
            ForEach(Array(registrationVM.certificateInfos.enumerated()), id: \.offset) { index, viewModel in
                CertificateInfoSection(
                    viewModel: viewModel,
                    showDeleteButton: registrationVM.certificateInfos.count > 1 && index < registrationVM.certificateInfos.count - 1,
                    onDelete: {
                        registrationVM.removeCertificateInfo(at: index)
                        registrationVM.validateCertificateInfoComplete()
                    },
                    onValidateRequiredFileds: {
                        registrationVM.validateRestCertificateFieldsRequired(at: index)
                    },
                    onValidateCertificateExpireDate: {
                        registrationVM.validateCertificateExpireDate(at: index)
                    },
                    onValidateFieldsComplete: {
                        registrationVM.validateCertificateInfoComplete()
                    }
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
 }

struct CertificateInfoSection: View {
    @ObservedObject var viewModel: CertificateInfoData
    var showDeleteButton: Bool = false
    var onDelete: () -> Void
    var onValidateRequiredFileds: () -> Void
    var onValidateCertificateExpireDate: () -> Void
    var onValidateFieldsComplete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: ViewSpacing.small) {
           Dropdown(
                selectionOption: $viewModel.selectedCertificateType,
                label: "certificate_type",
                placeholder: String(localized: "certificate_type_placeholder"),
                options: DropdownOption.certificates,
                backgroundColor: .white,
                isRequiredField: true
            )
            .overlay(
                GeometryReader { geometry in
                    if showDeleteButton {
                        Button(
                            action: onDelete
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
            .onChange(of: viewModel.selectedCertificateType) {
                onValidateRequiredFileds()
                onValidateFieldsComplete()
            }

            TextInputView(
                text: $viewModel.id,
                label: "ID",
                isSecuredField: false,
                placeholder: "ID_placeholder",
                validationState: ValidationState.neutral,
                theme: .white,
                isRequiredField: viewModel.isRestFieldRequired
            )
            .autocapitalization(.none)
            .onChange(of: viewModel.id) {
                onValidateFieldsComplete()
            }

            TextInputView(
                text: $viewModel.expireDate,
                label: "certificate_expiration_date",
                isSecuredField: false,
                placeholder: "date_placeholder",
                validationState: viewModel.isValidExpireDate ? .neutral : .error,
                validationMessage: viewModel.expireDateValidationMsg,
                theme: .white,
                isRequiredField: viewModel.isRestFieldRequired
            )
            .autocapitalization(.none)
            .onChange(of: viewModel.expireDate) {
                if !viewModel.expireDate.isEmpty { viewModel.expireDate = viewModel.expireDate.formattedDateMMDDYYYY
                    onValidateCertificateExpireDate()
                }
                onValidateFieldsComplete()
            }

            Dropdown(
                selectionOption: $viewModel.certificateLocation,
                label: "location",
                placeholder: String(localized: "certificate_location"),
                options: [DropdownOption(option: "中国")] + DropdownOption.states,
                backgroundColor: .white,
                isRequiredField: viewModel.isRestFieldRequired,
                dividerIndex: 0
            )
            .onChange(of: viewModel.certificateLocation) {
                onValidateFieldsComplete()
            }

            HStack(spacing: 0) {
                Text("upload_certificate_image")
                if viewModel.isRestFieldRequired {
                    Text("*")
                }
            }
            .font(.typography(.bodyMedium))
            .foregroundColor(.textPrimary)
            .padding(.top, ViewSpacing.base)

            ImagePickerView(selectedImage: $viewModel.certificateImage)
                .padding(.bottom, ViewSpacing.xlarge)
                .onChange(of: viewModel.certificateImage) {
                    onValidateFieldsComplete()
                }
        }
    }
}

#Preview {
    CertificateInfoView()
        .environmentObject(TherapistRegistrationVM(textInputVM: TextInputVM(), timeInputVM: TimeInputViewModel()))
}
