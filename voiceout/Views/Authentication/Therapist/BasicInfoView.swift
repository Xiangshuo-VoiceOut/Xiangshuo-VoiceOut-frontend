//
//  BasicInfoView.swift
//  voiceout
//
//  Created by J. Wu on 7/23/24.
//

import SwiftUI

struct BasicInfoView: View {
    @StateObject private var registrationVM: TherapistRegistrationVM

    init() {
        _registrationVM = StateObject(wrappedValue: TherapistRegistrationVM())
    }

    var body: some View {
        VStack(alignment: .leading, spacing: ViewSpacing.small) {
            TextInputView(
                text: $registrationVM.name,
                label: "name",
                isSecuredField: false,
                placeholder: "input_name_placeholder",
                validationState: ValidationState.neutral,
                validationMessage: registrationVM.nameMsg,
                theme: .white
            )
            .autocapitalization(.none)

            Dropdown(
                selectionOption: $registrationVM.selectedGender,
                label: "gender",
                placeholder: String(localized: "gender_placeholder"),
                options: DropdownOption.genders,
                backgroundColor: .white
            )

            Dropdown(
                selectionOption: $registrationVM.selectedState,
                label: "location",
                placeholder: String(localized: "state_placeholder"),
                options: registrationVM.allStates,
                backgroundColor: .white
            )

            TextInputView(
                text: $registrationVM.phoneNumber,
                label: "phone_number",
                isSecuredField: false,
                placeholder: "phone_number_placeholder",
                validationState: ValidationState.neutral,
                theme: .white
            )
            .autocapitalization(.none)
            .onChange(of: registrationVM.phoneNumber) {
                if !registrationVM.phoneNumber.isEmpty {
                    registrationVM.phoneNumber = registrationVM.phoneNumber.formatPhoneNumber()
                }
            }

            TextInputView(
                text: $registrationVM.birthdate,
                label: "birthdate",
                isSecuredField: false,
                placeholder: "birthdate_placeholder",
                validationState: ValidationState.neutral,
                theme: .white
            )
            .autocapitalization(.none)
            .onChange(of: registrationVM.birthdate) {
                registrationVM.birthdate = registrationVM.birthdate.formattedDate
            }

            Text("upload_profile")
                .font(.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
            ImagePickerView()
        }
    }
}

#Preview {
    BasicInfoView()
}
