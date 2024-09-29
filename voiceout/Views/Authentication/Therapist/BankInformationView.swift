//
//  BankInformationView.swift
//  voiceout
//
//  Created by J. Wu on 8/12/24.
//

import SwiftUI

struct BankInformationView: View {
    @StateObject private var registrationVM: TherapistRegistrationVM

    init() {
        _registrationVM = StateObject(wrappedValue: TherapistRegistrationVM())
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: ViewSpacing.small) {
                TextInputView(
                    text: $registrationVM.firstName,
                    label: "First Name",
                    isSecuredField: false,
                    placeholder: "First Name",
                    validationState: ValidationState.neutral,
                    theme: .white
                )
                .autocapitalization(.none)

                TextInputView(
                    text: $registrationVM.lastName,
                    label: "Last Name",
                    isSecuredField: false,
                    placeholder: "Last Name",
                    validationState: ValidationState.neutral,
                    theme: .white
                )
                .autocapitalization(.none)

                TextInputView(
                    text: $registrationVM.ssn,
                    label: "SSN",
                    isSecuredField: false,
                    placeholder: "000-00-0000",
                    validationState: ValidationState.neutral,
                    theme: .white
                )
                .autocapitalization(.none)
                .onChange(of: registrationVM.ssn) {
                    registrationVM.ssn = registrationVM.ssn.formattedSSN

                }

                TextInputView(
                    text: $registrationVM.confirmSSN,
                    label: "Confirm SSN",
                    isSecuredField: false,
                    placeholder: "000-00-0000",
                    validationState: ValidationState.neutral,
                    theme: .white
                )
                .autocapitalization(.none)
                .onChange(of: registrationVM.confirmSSN) {
                    registrationVM.confirmSSN = registrationVM.confirmSSN.formattedSSN
                }

                TextInputView(
                    text: $registrationVM.paymentPageBDate,
                    label: "Date of Birth",
                    isSecuredField: false,
                    placeholder: "date_placeholder",
                    validationState: ValidationState.neutral,
                    theme: .white
                )
                .autocapitalization(.none)
                .onChange(of: registrationVM.paymentPageBDate) {
                    registrationVM.paymentPageBDate = registrationVM.paymentPageBDate.formattedDate

                }

                TextInputView(
                    text: $registrationVM.comfirmPaymentPageBDate,
                    label: "Confirm Date of Birth",
                    isSecuredField: false,
                    placeholder: "date_placeholder",
                    validationState: ValidationState.neutral,
                    theme: .white
                )
                .autocapitalization(.none)
                .padding(.bottom, ViewSpacing.large)
                .onChange(of: registrationVM.comfirmPaymentPageBDate) {
                    registrationVM.comfirmPaymentPageBDate = registrationVM.comfirmPaymentPageBDate.formattedDate
                }

                Text("Direct deposit Information")
                    .padding(.bottom, ViewSpacing.large)

                TextInputView(
                    text: $registrationVM.routingNumber,
                    label: "Routing Number",
                    isSecuredField: false,
                    placeholder: "Routing Number",
                    validationState: ValidationState.neutral,
                    theme: .white
                )
                .autocapitalization(.none)

                TextInputView(
                    text: $registrationVM.confirmRoutingNumber,
                    label: "Confirm Routing Number",
                    isSecuredField: false,
                    placeholder: "Confirm Routing Number",
                    validationState: ValidationState.neutral,
                    theme: .white
                )
                .autocapitalization(.none)

                TextInputView(
                    text: $registrationVM.checkingNum,
                    label: "Checking Account Number",
                    isSecuredField: false,
                    placeholder: "Checking Account Number",
                    validationState: ValidationState.neutral,
                    theme: .white
                )
                .autocapitalization(.none)

                TextInputView(
                    text: $registrationVM.confirmCheckingNum,
                    label: "Confirm Checking Account Number",
                    isSecuredField: false,
                    placeholder: "Confirm Checking Account Number",
                    validationState: ValidationState.neutral,
                    theme: .white
                )
                .autocapitalization(.none)

                TextInputView(
                    text: $registrationVM.bankName,
                    label: "Bank Name",
                    isSecuredField: false,
                    placeholder: "Bank Name",
                    validationState: ValidationState.neutral,
                    theme: .white
                )
                .padding(.bottom, ViewSpacing.medium)
                .autocapitalization(.none)

                VStack(alignment: .leading) {
                    Text("Paperless 1099 consent")
                        .font(.typography(.bodyMediumEmphasis))
                        .padding(.bottom, ViewSpacing.medium)
                    Text("By clicking \"下一步\", you consent to paperless delivery of your 1099 " +
                         "tax forms via our online portal. Once your account is approved, you may " +
                         "opt-out of paperless delivery of tax forms at any time by visiting your payments tab.")
                        .font(.typography(.bodySmall))
                        .foregroundColor(.textSecondary)
                }
                .padding(.all, ViewSpacing.medium)
                .background(
                    Rectangle()
                        .fill(Color.surfacePrimary)
                        .cornerRadius(CornerRadius.medium.value)
                )
            }
        }
    }
}

#Preview {
    BankInformationView()
}
