//
//  BankInformationView.swift
//  voiceout
//
//  Created by J. Wu on 8/12/24.
//

import SwiftUI

struct BankInformationView: View {
    @EnvironmentObject var registrationVM: TherapistRegistrationVM
    @EnvironmentObject var textInputVM: TextInputVM

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: ViewSpacing.small) {
                TextInputView(
                    text: $registrationVM.firstName,
                    label: "First Name",
                    isSecuredField: false,
                    placeholder: "First Name",
                    validationState: ValidationState.neutral,
                    theme: .white,
                    isRequiredField: true
                )
                .autocapitalization(.none)
                .onChange(of: registrationVM.firstName) {
                    registrationVM.validateBankInfoComplete()
                }

                TextInputView(
                    text: $registrationVM.lastName,
                    label: "Last Name",
                    isSecuredField: false,
                    placeholder: "Last Name",
                    validationState: ValidationState.neutral,
                    theme: .white,
                    isRequiredField: true
                )
                .autocapitalization(.none)
                .onChange(of: registrationVM.lastName) {
                    registrationVM.validateBankInfoComplete()
                }

                TextInputView(
                    text: $registrationVM.ssn,
                    label: "SSN",
                    isSecuredField: false,
                    placeholder: "000-00-0000",
                    validationState: registrationVM.isValidSSN ? .neutral : .error,
                    validationMessage: registrationVM.ssnValidationMsg,
                    theme: .white,
                    isRequiredField: true
                )
                .autocapitalization(.none)
                .onChange(of: registrationVM.ssn) {
                    registrationVM.ssn = registrationVM.ssn.formattedSSN
                    registrationVM.validateSSN()
                    registrationVM.validateBankInfoComplete()
                }

                TextInputView(
                    text: $registrationVM.confirmSSN,
                    label: "Confirm SSN",
                    isSecuredField: false,
                    placeholder: "000-00-0000",
                    validationState: registrationVM.isMatchedSSN ? .neutral : .error,
                    validationMessage: registrationVM.confirmSSNValidationMsg,
                    theme: .white,
                    isRequiredField: true
                )
                .autocapitalization(.none)
                .onChange(of: registrationVM.confirmSSN) {
                    registrationVM.confirmSSN = registrationVM.confirmSSN.formattedSSN
                    registrationVM.validateConfirmSSN()
                    registrationVM.validateBankInfoComplete()
                }

                TextInputView(
                    text: $registrationVM.birthdate,
                    label: "Date of Birth",
                    isSecuredField: false,
                    placeholder: "date_placeholder",
                    validationState: registrationVM.isValidBirthdate ? .neutral : .error,
                    validationMessage: registrationVM.birthdateValidationMsg,
                    theme: .white,
                    isRequiredField: true
                )
                .autocapitalization(.none)
                .onChange(of: registrationVM.birthdate) {
                    registrationVM.birthdate = registrationVM.birthdate.formattedDateMMDDYYYY
                    registrationVM.validateBirthdate()
                    registrationVM.validateBankInfoComplete()
                }

                TextInputView(
                    text: $registrationVM.confirmBirthdate,
                    label: "Confirm Date of Birth",
                    isSecuredField: false,
                    placeholder: "date_placeholder",
                    validationState: registrationVM.isMatchedBirthdate ? .neutral : .error,
                    validationMessage: registrationVM.confirmBirthdateValidationMsg,
                    theme: .white,
                    isRequiredField: true
                )
                .autocapitalization(.none)
                .padding(.bottom, ViewSpacing.large)
                .onChange(of: registrationVM.confirmBirthdate) {
                    registrationVM.confirmBirthdate = registrationVM.confirmBirthdate.formattedDateMMDDYYYY
                    registrationVM.validateConfirmBirthdate()
                    registrationVM.validateBankInfoComplete()
                }

                Text("Direct deposit Information")
                    .padding(.bottom, ViewSpacing.large)

                TextInputView(
                    text: $registrationVM.routingNumber,
                    label: "Routing Number",
                    isSecuredField: false,
                    placeholder: "Routing Number",
                    validationState: registrationVM.isValidRoutingNumber ? .neutral : .error,
                    validationMessage: registrationVM.routingNumberValidationMsg,
                    theme: .white,
                    isRequiredField: true
                )
                .autocapitalization(.none)
                .onChange(of: registrationVM.routingNumber) {
                    registrationVM.validateRoutingNumber()
                    registrationVM.validateBankInfoComplete()
                }

                TextInputView(
                    text: $registrationVM.confirmRoutingNumber,
                    label: "Confirm Routing Number",
                    isSecuredField: false,
                    placeholder: "Confirm Routing Number",
                    validationState: registrationVM.isMachedCheckingNumber ? .neutral : .error,
                    validationMessage: registrationVM.confirmRoutingNumberValidationMsg,
                    theme: .white,
                    isRequiredField: true
                )
                .autocapitalization(.none)
                .onChange(of: registrationVM.confirmRoutingNumber) {
                    registrationVM.validateConfirmRoutingNumber()
                    registrationVM.validateBankInfoComplete()
                }

                TextInputView(
                    text: $registrationVM.checkingNumber,
                    label: "Checking Account Number",
                    isSecuredField: false,
                    placeholder: "Checking Account Number",
                    validationState: registrationVM.isValidCheckingNumber ? .neutral : .error,
                    validationMessage: registrationVM.checkingNumberValidationMsg,
                    theme: .white,
                    isRequiredField: true
                )
                .autocapitalization(.none)
                .onChange(of: registrationVM.checkingNumber) {
                    registrationVM.validateCheckingNumber()
                    registrationVM.validateBankInfoComplete()
                }

                TextInputView(
                    text: $registrationVM.confirmCheckingNumber,
                    label: "Confirm Checking Account Number",
                    isSecuredField: false,
                    placeholder: "Confirm Checking Account Number",
                    validationState: registrationVM.isMachedCheckingNumber ? .neutral : .error,
                    validationMessage: registrationVM.confirmCheckingNumberValidationMsg,
                    theme: .white,
                    isRequiredField: true
                )
                .autocapitalization(.none)
                .onChange(of: registrationVM.confirmCheckingNumber) {
                    registrationVM.validateConfirmCheckingNumber()
                    registrationVM.validateBankInfoComplete()
                }

                TextInputView(
                    text: $registrationVM.bankName,
                    label: "Bank Name",
                    isSecuredField: false,
                    placeholder: "Bank Name",
                    validationState: ValidationState.neutral,
                    theme: .white,
                    isRequiredField: true
                )
                .padding(.bottom, ViewSpacing.medium)
                .autocapitalization(.none)
                .onChange(of: registrationVM.bankName) {
                    registrationVM.validateBankInfoComplete()
                }

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

struct BankInformationView_Previews: PreviewProvider {
    static var previews: some View {
        let textInputVM = TextInputVM()
        let therapistRegistrationVM = TherapistRegistrationVM(textInputVM: textInputVM, timeInputVM: TimeInputViewModel())

        BankInformationView()
            .environmentObject(therapistRegistrationVM)
            .environmentObject(textInputVM)
    }
}
