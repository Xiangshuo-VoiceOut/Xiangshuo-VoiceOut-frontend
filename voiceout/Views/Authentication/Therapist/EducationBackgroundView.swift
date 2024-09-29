//
//  EducationBackgroundView.swift
//  voiceout
//
//  Created by J. Wu on 7/23/24.
//

import SwiftUI

struct EducationBackgroundView: View {
    @StateObject private var registrationVM: TherapistRegistrationVM

    init() {
        _registrationVM = StateObject(wrappedValue: TherapistRegistrationVM())
    }

    var body: some View {
        VStack {
            ForEach(Array(registrationVM.schoolInfos.enumerated()), id: \.offset) { index, schoolInfoData in
                schoolInfoSection(viewModel: schoolInfoData, index: index)
            }

            ButtonView(
                text: "add_new_degree",
                action: registrationVM.addSchoolInfo,
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

    @ViewBuilder
    private func schoolInfoSection(
        @ObservedObject viewModel: SchoolInfoData,
        index: Int
    ) -> some View {
        VStack(spacing: ViewSpacing.small) {
            Dropdown(
                selectionOption: $viewModel.degree,
                label: "degree",
                placeholder: String(localized: "degree_placeholder"),
                options: DropdownOption.degrees,
                backgroundColor: .white
            )
            .overlay(
                GeometryReader { geometry in
                    if registrationVM.schoolInfos.count > 1 && index < registrationVM.schoolInfos.count - 1 {
                        Button(
                            action: {
                                registrationVM.removeSchoolInfo(at: index)
                            }
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

            TextInputView(
                text: $viewModel.college,
                label: "graduate_college",
                isSecuredField: false,
                placeholder: "college_placeholder",
                validationState: ValidationState.neutral,
                theme: .white
            )
            .autocapitalization(.none)

            TextInputView(
                text: $viewModel.graduationDate,
                label: "graduate_date",
                isSecuredField: false,
                placeholder: "month_placeholder",
                validationState: ValidationState.neutral,
                theme: .white
            )
            .autocapitalization(.none)

            TextInputView(
                text: $viewModel.major,
                label: "major",
                isSecuredField: false,
                placeholder: "major_placeholder",
                validationState: ValidationState.neutral,
                theme: .white
            )
            .autocapitalization(.none)
            .padding(.bottom, ViewSpacing.xlarge)
        }
    }
}

#Preview {
    EducationBackgroundView()
}
