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
            ForEach(Array(registrationVM.schoolInfos.enumerated()), id: \.offset) { index, schoolInfoData in
                schoolInfoSection(viewModel: schoolInfoData, index: index)
            }
            
            AddButton(action: registrationVM.addSchoolInfo, text: "add_new_degree")
                
            
        }
    }
    
    @ViewBuilder
    private func schoolInfoSection(@ObservedObject viewModel: SchoolInfoData, index: Int) -> some View {
        
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
            Dropdown(selectionOption: $viewModel.degree, placeholder: String(localized: "degree_placeholder"), options: DropdownOption.degrees, backgroundColor: .white)
                            .padding(.bottom, ViewSpacing.large)
                            .zIndex(5)
            
            Text("graduate_college")
                .font(.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
            TextInputView(
                text: $viewModel.college,
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
                text: $viewModel.graduationDate,
                isSecuredField: false,
                placeholder: "month_placeholder",
                validationState: ValidationState.neutral,
                theme: .white
            )
            .autocapitalization(.none)
            .padding(.bottom)
            
            Text("major")
                .font(.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
            TextInputView(
                text: $viewModel.major,
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
