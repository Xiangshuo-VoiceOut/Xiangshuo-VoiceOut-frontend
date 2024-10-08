//
//  BasicInfoView.swift
//  voiceout
//
//  Created by J. Wu on 7/23/24.
//

import SwiftUI

struct BasicInfoView: View {
    @EnvironmentObject var registrationVM: TherapistRegistrationVM
    @EnvironmentObject var textInputVM: TextInputVM

    var body: some View {
        VStack(alignment: .leading, spacing: ViewSpacing.small) {
            TextInputView(
                text: $registrationVM.name,
                label: "name",
                isSecuredField: false,
                placeholder: "input_name_placeholder",
                validationState: .neutral,
                validationMessage: "name_match",
                theme: .white,
                isRequiredField: true
            )
            .autocapitalization(.none)
            .onChange(of: registrationVM.name) {
                registrationVM.validateBasicInfoComplete()
            }

            Dropdown(
                selectionOption: $registrationVM.selectedGender,
                label: "gender",
                placeholder: String(localized: "gender_placeholder"),
                options: DropdownOption.genders,
                backgroundColor: .white,
                isRequiredField: true
            )
            .onChange(of: registrationVM.selectedGender) {
                registrationVM.validateBasicInfoComplete()
            }

            Dropdown(
                selectionOption: $registrationVM.selectedState,
                label: "location",
                placeholder: String(localized: "state_placeholder"),
                options: DropdownOption.states,
                backgroundColor: .white,
                isRequiredField: true
            )
            .onChange(of: registrationVM.selectedState) {
                registrationVM.validateBasicInfoComplete()
            }

            TextInputView(
                text: $textInputVM.phoneNumber,
                label: "phone_number",
                isSecuredField: false,
                placeholder: "phone_number_placeholder",
                validationState: textInputVM.isValidPhoneNumber ? .neutral : .error,
                validationMessage: textInputVM.phoneNumberValidationMsg,
                theme: .white,
                isRequiredField: true
            )
            .autocapitalization(.none)
            .onChange(of: textInputVM.phoneNumber) {
                textInputVM.phoneNumber = textInputVM.phoneNumber.formattedPhoneNumber
                textInputVM.validatePhoneNumber()
                registrationVM.validateBasicInfoComplete()
            }

            TextInputView(
                text: $textInputVM.date,
                label: "birthdate",
                isSecuredField: false,
                placeholder: "birthdate_placeholder",
                validationState: textInputVM.isDateValid ? .neutral : .error,
                validationMessage: textInputVM.dateValidationMsg,
                theme: .white,
                isRequiredField: true
            )
            .autocapitalization(.none)
            .onChange(of: textInputVM.date) {
                textInputVM.date = textInputVM.date.formattedDateMMDDYYYY
                textInputVM.validateDate()
                registrationVM.validateBasicInfoComplete()
            }

            HStack(spacing: 0) {
                Text("upload_profile")
                Text("*")
            }
            .font(.typography(.bodyMedium))
            .foregroundColor(.textPrimary)

            ImagePickerView(selectedImage: $registrationVM.selectedProfileImage)
                .onChange(of: registrationVM.selectedProfileImage) {
                    registrationVM.validateBasicInfoComplete()
                }

        }
    }
}

#Preview {
    BasicInfoView()
        .environmentObject(TherapistRegistrationVM(textInputVM: TextInputVM(), timeInputVM: TimeInputViewModel()))
        .environmentObject(TextInputVM())
}
