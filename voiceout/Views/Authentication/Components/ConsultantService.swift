//
//  ConsultantService.swift
//  voiceout
//
//  Created by J. Wu on 7/23/24.
//

import SwiftUI

struct ConsultantService: View {
    @StateObject var registrationVM: TherapistRegistrationVM
    
    @State private var maxCharacterLimit = 24
    @State private var remainingCharacters = 24
    
    init() {
        _registrationVM = StateObject(wrappedValue: TherapistRegistrationVM())
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("target_client")
                .font(.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
            TagsView(tags: BadgeTag.targetGroup)
                .padding(.bottom)
                
            
            Text("target_field")
                .font(.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
            TagsView(tags: BadgeTag.targetFields)
                .padding(.bottom)
            
            Text("target_style")
                .font(.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
            TagsView(tags: BadgeTag.targetStyles)
                .padding(.bottom)
            
            Text("fee")
                .font(.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
            TextInputView(
                text: $registrationVM.fee,
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
                text: $registrationVM.title,
                isSecuredField: false,
                placeholder: "title_placeholder",
                validationState: ValidationState.neutral,
                theme: .white
            )
            .autocapitalization(.none)
            .padding(.bottom)
            .onChange(of: registrationVM.title) { newValue in
                if newValue.count > maxCharacterLimit {
                registrationVM.title = String(newValue.prefix(maxCharacterLimit))
                remainingCharacters = 0
            } else {
            remainingCharacters = maxCharacterLimit - newValue.count
                    }
            }
            HStack{
                Spacer()
                Text("\(remainingCharacters)/\(maxCharacterLimit)")
                    .padding(.top, -ViewSpacing.medium)
                    .font(.typography(.bodySmall))
                    .foregroundColor(.textSecondary)
                    .padding(.trailing)
            }
            
            
            
        }
    }
}

#Preview {
    ConsultantService()
}
