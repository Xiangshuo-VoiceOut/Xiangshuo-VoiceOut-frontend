//
//  BankInformation.swift
//  voiceout
//
//  Created by J. Wu on 8/12/24.
//

import SwiftUI

struct BankInformation: View {
    
    @StateObject private var registrationVM: TherapistRegistrationVM
    init() {
        _registrationVM = StateObject(wrappedValue: TherapistRegistrationVM())
    }
    
    var body: some View {
        VStack(alignment:.leading){
            
            Text("First Name")
                .font(.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
            TextInputView(
                text: $registrationVM.firstName,
                isSecuredField: false,
                placeholder: "First Name",
                validationState: ValidationState.neutral,
                theme: .white
            )
            .autocapitalization(.none)
            .padding(.bottom)
            
            Text("Last Name")
                .font(.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
            TextInputView(
                text: $registrationVM.lastName,
                isSecuredField: false,
                placeholder: "Last Name",
                validationState: ValidationState.neutral,
                theme: .white
            )
            .autocapitalization(.none)
            .padding(.bottom)
            
            Text("SSN")
                .font(.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
            TextInputView(
                text: $registrationVM.ssn,
                isSecuredField: false,
                placeholder: "000-00-0000",
                validationState: ValidationState.neutral,
                theme: .white
            )
            .autocapitalization(.none)
            .padding(.bottom)
            .onChange(of: registrationVM.ssn) { ssn in
                registrationVM.ssn = formatSSN(ssn)
                
            }
            
            Text("Confirm SSN")
                .font(.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
            TextInputView(
                text: $registrationVM.confirmSSN,
                isSecuredField: false,
                placeholder: "000-00-0000",
                validationState: ValidationState.neutral,
                theme: .white
            )
            .autocapitalization(.none)
            .padding(.bottom)
            .onChange(of: registrationVM.confirmSSN) { ssn in
                registrationVM.confirmSSN = formatSSN(ssn)
            }
            
            Text("Date of Birth")
                .font(.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
            TextInputView(
                text: $registrationVM.paymentPageBDate,
                isSecuredField: false,
                placeholder: "date_placeholder",
                validationState: ValidationState.neutral,
                theme: .white
            )
            .autocapitalization(.none)
            .padding(.bottom)
            .onChange(of: registrationVM.paymentPageBDate) { value in
                registrationVM.paymentPageBDate = formatDateString(value)
                
            }
            
            Text("Confirm Date of Birth")
                .font(.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
            TextInputView(
                text: $registrationVM.comfirmPaymentPageBDate,
                isSecuredField: false,
                placeholder: "date_placeholder",
                validationState: ValidationState.neutral,
                theme: .white
            )
            .autocapitalization(.none)
            .padding(.bottom, ViewSpacing.xlarge)
            .onChange(of: registrationVM.comfirmPaymentPageBDate) { value in
                registrationVM.comfirmPaymentPageBDate = formatDateString(value)
                
            }
            
            Text("Direct deposit Information")
                .padding(.bottom, ViewSpacing.xlarge)
            
            Text("Routing Number")
                .font(.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
            TextInputView(
                text: $registrationVM.routingNumber,
                isSecuredField: false,
                placeholder: "Routing Number",
                validationState: ValidationState.neutral,
                theme: .white
            )
            .autocapitalization(.none)
            .padding(.bottom)
            
            Text("Confirm Routing Number")
                .font(.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
            TextInputView(
                text: $registrationVM.confirmRoutingNumber,
                isSecuredField: false,
                placeholder: "Confirm Routing Number",
                validationState: ValidationState.neutral,
                theme: .white
            )
            .autocapitalization(.none)
            .padding(.bottom)
            
            Text("Checking Account Number")
                .font(.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
            TextInputView(
                text: $registrationVM.checkingNum,
                isSecuredField: false,
                placeholder: "Checking Account Number",
                validationState: ValidationState.neutral,
                theme: .white
            )
            .autocapitalization(.none)
            .padding(.bottom)
            
            Text("Confirm Checking Account Number")
                .font(.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
            TextInputView(
                text: $registrationVM.confirmCheckingNum,
                isSecuredField: false,
                placeholder: "Confirm Checking Account Number",
                validationState: ValidationState.neutral,
                theme: .white
            )
            .autocapitalization(.none)
            .padding(.bottom)
            
            Text("Bank Name")
                .font(.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
            TextInputView(
                text: $registrationVM.bankName,
                isSecuredField: false,
                placeholder: "Bank Name",
                validationState: ValidationState.neutral,
                theme: .white
            )
            .autocapitalization(.none)
            .padding(.bottom, ViewSpacing.xxlarge)
            
            VStack(alignment: .leading){
                Text("Paperless 1099 consent")
                    .font(.typography(.bodyMediumEmphasis))
                    .padding(.bottom, ViewSpacing.medium)
                Text("before_click_next_step")
                    .font(.typography(.bodySmall))
                    .foregroundColor(.textSecondary)
            }
            .padding(.all, ViewSpacing.medium)
            .background(
                Rectangle()
                    .fill(Color.surfacePrimary)
                    .cornerRadius(CornerRadius.small.value)
            )
        }
        .padding(.bottom, -ViewSpacing.xxlarge)
        
    }
}

#Preview {
    BankInformation()
}
