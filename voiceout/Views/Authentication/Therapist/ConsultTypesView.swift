//
//  ConsultTypesView.swift
//  voiceout
//
//  Created by J. Wu on 7/23/24.
//

import SwiftUI
import CoreGraphics

 struct ConsultTypesView: View {
     @EnvironmentObject var registrationVM: TherapistRegistrationVM
     @State private var maxCharacterLimit = 24
     @State private var remainingCharacters = 24

    var body: some View {
        VStack(alignment: .leading, spacing: ViewSpacing.small) {
            Text("target_client")
                .font(.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
            FlowLayout {
                ForEach(Badge.targetGroup) { badge in
                    BadgeView(
                        isActive: registrationVM.targetClientTypes.contains(badge.name),
                        text: badge.name
                    )
                    .padding(.trailing, ViewSpacing.medium)
                    .padding(.bottom, ViewSpacing.medium)
                    .simultaneousGesture(
                        TapGesture()
                            .onEnded {
                                registrationVM.selectTargetClientTypes(with: badge.name)
                                registrationVM.validateConsultTypesComplete()
                            }
                    )
                }
            }

            Text("target_field")
                .font(.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
            FlowLayout {
                ForEach(Badge.areaOfExpertise) { badge in
                    BadgeView(
                        isActive: registrationVM.targetFieldTypes.contains(badge.name),
                        text: badge.name
                    )
                    .padding(.trailing, ViewSpacing.medium)
                    .padding(.bottom, ViewSpacing.medium)
                    .simultaneousGesture(
                        TapGesture()
                            .onEnded {
                                registrationVM.selectTargetFieldTypes(with: badge.name)
                                registrationVM.validateConsultTypesComplete()
                                }
                    )
                }
            }

            Text("target_style")
                .font(.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
            FlowLayout {
                ForEach(Badge.specializedStyles) { badge in
                    BadgeView(
                        isActive: registrationVM.targetStyleTypes.contains(badge.name),
                        text: badge.name
                    )
                    .padding(.trailing, ViewSpacing.medium)
                    .padding(.bottom, ViewSpacing.medium)
                    .simultaneousGesture(
                        TapGesture()
                            .onEnded {
                                registrationVM.selectTargetStyleTypes(with: badge.name)
                                registrationVM.validateConsultTypesComplete()
                            }
                    )
                }
            }

            TextInputView(
                text: $registrationVM.consultingRate,
                label: "fee",
                isSecuredField: false,
                placeholder: "fee_placeholder",
                validationState: registrationVM.isValidConsultingRate ? .neutral : .error,
                validationMessage: "invalid_consultation_rate",
                theme: .white
            )
            .autocapitalization(.none)
            .onChange(of: registrationVM.consultingRate) {
                if Double(registrationVM.consultingRate) != nil {
                    registrationVM.isValidConsultingRate = true
                } else {
                    registrationVM.isValidConsultingRate = false
                }
                registrationVM.validateConsultTypesComplete()
            }

            TextInputView(
                text: $registrationVM.personalTitle,
                label: "title",
                isSecuredField: false,
                placeholder: "title_placeholder",
                validationState: ValidationState.neutral,
                theme: .white
            )
            .autocapitalization(.none)
            .onChange(of: registrationVM.personalTitle) {
                if registrationVM.personalTitle.count > maxCharacterLimit {
                    registrationVM.personalTitle = String(registrationVM.personalTitle.prefix(maxCharacterLimit))
                    remainingCharacters = 0
                } else {
                    remainingCharacters = maxCharacterLimit - registrationVM.personalTitle.count
                }
                registrationVM.validateConsultTypesComplete()
            }

            HStack {
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
    ConsultTypesView()
         .environmentObject(TherapistRegistrationVM(textInputVM: TextInputVM(), timeInputVM: TimeInputViewModel()))

 }
