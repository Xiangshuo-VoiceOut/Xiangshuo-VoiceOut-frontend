//
//  SchoolInfo.swift
//  voiceout
//
//  Created by J. Wu on 7/23/24.
//

import SwiftUI

struct SchoolInfo: View {
    @StateObject private var registrationVM: TherapistRegistrationVM
    init() {
        _registrationVM = StateObject(wrappedValue: TherapistRegistrationVM())
    }
    var body: some View {
        
        VStack{
            ForEach(Array(registrationVM.schoolInfos.enumerated()), id: \.offset) { index, _ in
                schoolInfoSection(index: index)
            }
            
            AddButton(action: registrationVM.addSchoolInfo, text: "add_new_degree")
                
            
        }
    }
    
    @ViewBuilder
    private func schoolInfoSection(index: Int) -> some View {
        let binding = Binding{
            registrationVM.schoolInfos[index]
        } set: {
            registrationVM.schoolInfos[index] = $0
        }
        
        
        VStack(alignment: .leading, spacing: ViewSpacing.small) {
            
            HStack{
                Text("degree")
                    .font(.typography(.bodyMedium))
                    .foregroundColor(.textPrimary)
                    
                if registrationVM.schoolInfos.count > 1 && index < registrationVM.schoolInfos.count - 1 {
                    Spacer()
                    Button(action: {
                            registrationVM.removeSchoolInfo(at: index)
                        }
                    ) {
                        Image("delete")
                        Text("remove")
                            .foregroundColor(.textLight)
                            .font(.typography(.bodyMedium))
                    }
                }
                
            }
            Dropdown(selectionOption: $registrationVM.selectedDegree, placeholder: String(localized: "degree_placeholder"), options: DropdownOption.degrees, backgroundColor: .white)
                            .padding(.bottom, ViewSpacing.large)
                            .zIndex(5)
            
            Text("graduate_college")
                .font(.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
            TextInputView(
                text: $registrationVM.college,
                isSecuredField: false,
                placeholder: "college_placeholder",
                validationState: ValidationState.neutral,
                theme: .white
            )
            .autocapitalization(.none)
            .padding(.bottom)
            
            Text("graduate_date")
                .font(.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
            TextInputView(
                text: $registrationVM.college,
                isSecuredField: false,
                placeholder: "date_placeholder",
                validationState: ValidationState.neutral,
                theme: .white
            )
            .autocapitalization(.none)
            .padding(.bottom)
            
            Text("major")
                .font(.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
            TextInputView(
                text: $registrationVM.major,
                isSecuredField: false,
                placeholder: "major_placeholder",
                validationState: ValidationState.neutral,
                theme: .white
            )
            .autocapitalization(.none)
            .padding(.bottom, ViewSpacing.xxlarge)
            
            
        }
        
    }
}

#Preview {
    SchoolInfo()
}
