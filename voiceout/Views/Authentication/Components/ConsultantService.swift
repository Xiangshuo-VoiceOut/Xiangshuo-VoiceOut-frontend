//
//  ConsultantService.swift
//  voiceout
//
//  Created by J. Wu on 7/23/24.
//

import SwiftUI

struct ConsultantService: View {
    @StateObject var registrationVM: TherapistRegistrationVM
    
    init() {
        _registrationVM = StateObject(wrappedValue: TherapistRegistrationVM())
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("target_client")
                .font(.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
            TagsView(tags: Tag.targetGroup)
                .padding(.bottom)
                
            
            Text("target_field")
                .font(.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
            TagsView(tags: Tag.targetFields)
                .padding(.bottom)
            
            Text("target_style")
                .font(.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
            TagsView(tags: Tag.targetStyles)
                .padding(.bottom)
            
            Text("fee")
                .font(.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
            TextInputView(
                text: $registrationVM.phoneNumber,
                isSecuredField: false,
                placeholder: "fee_placeholder",
                validationState: ValidationState.neutral,
                theme: .white
            )
            .autocapitalization(.none)
            .padding(.bottom)
            
            Text("title")
                .font(.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
            TextInputView(
                text: $registrationVM.phoneNumber,
                isSecuredField: false,
                placeholder: "title_placeholder",
                validationState: ValidationState.neutral,
                theme: .white
            )
            .autocapitalization(.none)
            .padding(.bottom)
        }
    }
}

#Preview {
    ConsultantService()
}
