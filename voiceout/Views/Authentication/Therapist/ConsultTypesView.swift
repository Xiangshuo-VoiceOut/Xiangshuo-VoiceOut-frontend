//
//  ConsultTypesView.swift
//  voiceout
//
//  Created by J. Wu on 7/23/24.
//

 import SwiftUI

 struct ConsultTypesView: View {
    @StateObject var registrationVM: TherapistRegistrationVM
    @State private var maxCharacterLimit = 24
    @State private var remainingCharacters = 24

    init() {
        _registrationVM = StateObject(wrappedValue: TherapistRegistrationVM())
    }

    var body: some View {
        VStack(alignment: .leading, spacing: ViewSpacing.small) {
            Text("target_client")
                .font(.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
            FlowLayout {
                ForEach(Badge.targetGroup) { badge in
                    BadgeView(text: badge.name)
                        .padding(.trailing, ViewSpacing.medium)
                        .padding(.bottom, ViewSpacing.medium)
                }
            }

            Text("target_field")
                .font(.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
            FlowLayout {
                ForEach(Badge.areaOfExpertise) { badge in
                    BadgeView(text: badge.name)
                        .padding(.trailing, ViewSpacing.medium)
                        .padding(.bottom, ViewSpacing.medium)
                }
            }

            Text("target_style")
                .font(.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
            FlowLayout {
                ForEach(Badge.specializedStyles) { badge in
                    BadgeView(text: badge.name)
                        .padding(.trailing, ViewSpacing.medium)
                        .padding(.bottom, ViewSpacing.medium)
                }
            }

            TextInputView(
                text: $registrationVM.fee,
                label: "fee",
                isSecuredField: false,
                placeholder: "fee_placeholder",
                validationState: ValidationState.neutral,
                theme: .white
            )
            .autocapitalization(.none)

            TextInputView(
                text: $registrationVM.title,
                label: "title",
                isSecuredField: false,
                placeholder: "title_placeholder",
                validationState: ValidationState.neutral,
                theme: .white
            )
            .autocapitalization(.none)
            .onChange(of: registrationVM.title) {
                if registrationVM.title.count > maxCharacterLimit {
                    registrationVM.title = String(registrationVM.title.prefix(maxCharacterLimit))
                    remainingCharacters = 0
                } else {
                    remainingCharacters = maxCharacterLimit - registrationVM.title.count
                }
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
 }
