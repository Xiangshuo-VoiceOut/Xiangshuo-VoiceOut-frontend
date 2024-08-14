//
//  BasicInfo.swift
//  voiceout
//
//  Created by J. Wu on 7/23/24.
//

import SwiftUI

struct BasicInfo: View {
    @StateObject private var registrationVM: TherapistRegistrationVM
    init() {
        _registrationVM = StateObject(wrappedValue: TherapistRegistrationVM())
    }
    var body: some View {
        
            VStack(alignment: .leading, spacing: ViewSpacing.small) {
                Text("name")
                    .font(.typography(.bodyMedium))
                    .foregroundColor(.textPrimary)
                TextInputView(
                    text: $registrationVM.name,
                    isSecuredField: false,
                    placeholder: "input_name_placeholder",
                    validationState: ValidationState.neutral,
                    validationMessage: registrationVM.nameMsg,
                    theme: .white
                )
                .autocapitalization(.none)
                .padding(.bottom)
                
                Text("gender")
                    .font(.typography(.bodyMedium))
                    .foregroundColor(.textPrimary)
                Dropdown(selectionOption: $registrationVM.selectedGender, placeholder: String(localized: "gender_placeholder"), options: DropdownOption.genders, backgroundColor: .white)
                                .padding(.bottom, ViewSpacing.large)
                                .zIndex(6)
                
                Text("location")
                    .font(.typography(.bodyMedium))
                    .foregroundColor(.textPrimary)
                Dropdown(selectionOption: $registrationVM.selectedState, placeholder: String(localized: "state_placeholder"), options: registrationVM.allStates, backgroundColor: .white)
                                .padding(.bottom, ViewSpacing.large)
                                .zIndex(5)
                
                Text("phone_number")
                    .font(.typography(.bodyMedium))
                    .foregroundColor(.textPrimary)
                TextInputView(
                    text: $registrationVM.phoneNumber,
                    isSecuredField: false,
                    placeholder: "phone_number_placeholder",
                    validationState: ValidationState.neutral,
                    theme: .white
                )
                .autocapitalization(.none)
                .padding(.bottom)
                .onChange(of: registrationVM.phoneNumber) {phoneNumber in
                    if !phoneNumber.isEmpty {
                        registrationVM.phoneNumber = phoneNumber.formatPhoneNumber()
                    }
                }
                
                Text("birthdate")
                    .font(.typography(.bodyMedium))
                    .foregroundColor(.textPrimary)
                TextInputView(
                    text: $registrationVM.birthdate,
                    isSecuredField: false,
                    placeholder: "birthdate_placeholder",
                    validationState: ValidationState.neutral,
                    theme: .white
                )
                .autocapitalization(.none)
                .padding(.bottom)
                .onChange(of: registrationVM.birthdate) {newValue in
                    registrationVM.birthdate = formatDateString(newValue)
                }
                
                Text("upload_profile")
                    .font(.typography(.bodyMedium))
                    .foregroundColor(.textPrimary)
                ImagePickerView()
            }
        }
    
}

#Preview {
    BasicInfo()
}
