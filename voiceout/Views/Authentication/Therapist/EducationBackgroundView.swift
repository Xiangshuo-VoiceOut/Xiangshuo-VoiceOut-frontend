//
//  EducationBackgroundView.swift
//  voiceout
//
//  Created by J. Wu on 7/23/24.
//

import SwiftUI

struct EducationBackgroundView: View {
    @EnvironmentObject var registrationVM: TherapistRegistrationVM

    var body: some View {
        VStack {
            ForEach(Array(registrationVM.schoolInfos.enumerated()), id: \.offset) { index, schoolInfoData in
                SchoolInfoSection(
                    viewModel: schoolInfoData,
                    showDeleteButton: registrationVM.schoolInfos.count > 1 && index < registrationVM.schoolInfos.count - 1,
                    onDelete: {
                        registrationVM.removeSchoolInfo(at: index)
                        registrationVM.validateSchoolInfoComplete()
                    },
                    onValidateGraduationDate: {
                        registrationVM.validateGraduationTime(at: index)
                    },
                    onValidateFieldsComplete: {
                        registrationVM.validateSchoolInfoComplete()
                    }
                )
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
}

struct SchoolInfoSection: View {
    @ObservedObject var viewModel: SchoolInfoData
    var showDeleteButton: Bool = false
    var onDelete: () -> Void
    var onValidateGraduationDate: () -> Void
    var onValidateFieldsComplete: () -> Void

    var body: some View {
        VStack(spacing: ViewSpacing.small) {
            Dropdown(
                selectionOption: $viewModel.selectedDegree,
                label: "degree",
                placeholder: String(localized: "degree_placeholder"),
                options: DropdownOption.degrees,
                backgroundColor: .white,
                isRequiredField: true
            )
            .overlay(
                GeometryReader { geometry in
                    if showDeleteButton {
                        Button(
                            action: onDelete
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
            .onChange(of: viewModel.selectedDegree) {
                onValidateFieldsComplete()
            }

            TextInputView(
                text: $viewModel.selectedCollege,
                label: "graduate_college",
                isSecuredField: false,
                placeholder: "college_placeholder",
                validationState: .neutral,
                theme: .white,
                isRequiredField: true
            )
            .autocapitalization(.none)
            .onChange(of: viewModel.selectedDegree) {
                onValidateFieldsComplete()
            }

            TextInputView(
                text: $viewModel.graduationTime,
                label: "graduate_date",
                isSecuredField: false,
                placeholder: "month_placeholder",
                validationState: viewModel.isValidGraduationTime ? .neutral : .error,
                validationMessage: viewModel.graduationTimeValidationMsg,
                theme: .white,
                isRequiredField: true
            )
            .autocapitalization(.none)
            .onChange(of: viewModel.graduationTime) {
                if !viewModel.graduationTime.isEmpty { viewModel.graduationTime = viewModel.graduationTime.formattedDateMMYYYY
                    onValidateGraduationDate()
                }
                onValidateFieldsComplete()
            }

            TextInputView(
                text: $viewModel.major,
                label: "major",
                isSecuredField: false,
                placeholder: "major_placeholder",
                validationState: .neutral,
                theme: .white,
                isRequiredField: true
            )
            .autocapitalization(.none)
            .padding(.bottom, ViewSpacing.xlarge)
            .onChange(of: viewModel.major) {
                onValidateFieldsComplete()
            }
        }
    }
}

#Preview {
    EducationBackgroundView()
        .environmentObject(TherapistRegistrationVM(textInputVM: TextInputVM(), timeInputVM: TimeInputViewModel()))
}
