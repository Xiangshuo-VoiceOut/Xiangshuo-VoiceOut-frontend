//
//  TherapistRegistrationVM.swift
//  voiceout
//
//  Created by J. Wu on 7/23/24.
//

import Foundation
import SwiftUI

class SchoolInfoData: ObservableObject {
    @Published var selectedDegree: DropdownOption?
    @Published var selectedCollege: String = ""
    @Published var graduationTime: String = ""
    @Published var isValidGraduationTime: Bool = true
    @Published var graduationTimeValidationMsg: String = ""
    @Published var major: String = ""
}

class CertificateInfoData: ObservableObject {
    @Published var selectedCertificateType: DropdownOption?
    @Published var isRestFieldRequired: Bool = true
    @Published var id: String = ""
    @Published var expireDate: String = ""
    @Published var isValidExpireDate: Bool = true
    @Published var expireDateValidationMsg: String = ""
    @Published var certificateLocation: DropdownOption?
    @Published var certificateImage: UIImage?
}

class TherapistRegistrationVM: ObservableObject {
    @Published var isNextStepEnabled: Bool = false
    @Published var currentStep: Int = 0
    @Published var totalSteps = 6

    // step 1:basic info
    @Published var name: String = ""
    @Published var selectedGender: DropdownOption?
    @Published var selectedState: DropdownOption?
    @Published var selectedProfileImage: UIImage?

    // step 2: education background
    @Published var schoolInfos: [SchoolInfoData] = [SchoolInfoData()]

    // step 3: certificate info
    @Published var certificateInfos: [CertificateInfoData] = [CertificateInfoData()]

    // step 4: consult types
    @Published var targetClientTypes: Set<String> = []
    @Published var targetFieldTypes: Set<String> = []
    @Published var targetStyleTypes: Set<String> = []
    @Published var consultingRate: String = ""
    @Published var personalTitle: String = ""

    // step 5: bank info
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var ssn: String = ""
    @Published var isValidSSN: Bool = true
    @Published var ssnValidationMsg: String = ""
    @Published var confirmSSN: String = ""
    @Published var confirmSSNValidationMsg: String = ""
    @Published var isMatchedSSN: Bool = true
    @Published var birthdate: String = ""
    @Published var isValidBirthdate: Bool = true
    @Published var birthdateValidationMsg: String = ""
    @Published var confirmBirthdate: String = ""
    @Published var confirmBirthdateValidationMsg: String = ""
    @Published var isMatchedBirthdate: Bool = true
    @Published var routingNumber: String = ""
    @Published var isValidRoutingNumber: Bool = true
    @Published var routingNumberValidationMsg: String = ""
    @Published var confirmRoutingNumber: String = ""
    @Published var confirmRoutingNumberValidationMsg: String = ""
    @Published var isMachedRoutingNumber: Bool = true
    @Published var checkingNumber: String = ""
    @Published var isValidCheckingNumber: Bool = true
    @Published var checkingNumberValidationMsg: String = ""
    @Published var confirmCheckingNumber: String = ""
    @Published var confirmCheckingNumberValidationMsg: String = ""
    @Published var isMachedCheckingNumber: Bool = true
    @Published var bankName: String = ""

    // step 6: schedule
    @Published var selectedTimeZone: DropdownOption? = DropdownOption.timezones[0]
    @Published var isSameTimeSchedule: Bool = true
    @Published var selectedDayIndices: Set<Int> = [0, 1, 2, 3, 4, 5, 6]

    private var textInputVM: TextInputVM
    private var timeInputVM: TimeInputViewModel

    init(textInputVM: TextInputVM, timeInputVM: TimeInputViewModel) {
        self.textInputVM = textInputVM
        self.timeInputVM = timeInputVM
    }

    func goToNextStep() {
        if currentStep < totalSteps - 1 {
            currentStep += 1
            isNextStepEnabled = false
        } else {
            // completeRegistration()
        }
    }

    func goToPreviousStep() {
        if currentStep > 0 {
            currentStep -= 1

            switch currentStep {
            case 0:
                validateBasicInfoComplete()
            case 1:
                validateSchoolInfoComplete()
            case 2:
                validateCertificateInfoComplete()
            case 3:
                validateConsultTypesComplete()
            case 4:
                validateBankInfoComplete()
            case 5:
                validateAvailableTimesComplete()
            default:
                validateBasicInfoComplete()
            }
        }
    }

    func validateBasicInfoComplete() {
        let isCompleted = !name.isEmpty &&
            selectedGender != nil &&
            selectedState != nil &&
            !textInputVM.phoneNumber.isEmpty &&
            textInputVM.isValidPhoneNumber &&
            !textInputVM.date.isEmpty &&
            textInputVM.isDateValid &&
            selectedProfileImage != nil

        if isCompleted {
            isNextStepEnabled = true
        } else {
            isNextStepEnabled = false
        }
    }

    func validateSchoolInfoComplete() {
        let isCompleted = schoolInfos.allSatisfy { schoolInfo in
            schoolInfo.selectedDegree != nil &&
            !schoolInfo.selectedCollege.isEmpty &&
            !schoolInfo.graduationTime.isEmpty &&
            schoolInfo.isValidGraduationTime &&
            !schoolInfo.major.isEmpty
        }

        if isCompleted {
            isNextStepEnabled = true
        } else {
            isNextStepEnabled = false
        }
    }

    func validateCertificateInfoComplete() {
        let isCompleted = certificateInfos.allSatisfy { certificateinfo in
            certificateinfo.selectedCertificateType != nil &&
            ((certificateinfo.isRestFieldRequired &&
              !certificateinfo.id.isEmpty &&
              !certificateinfo.expireDate.isEmpty &&
              certificateinfo.isValidExpireDate &&
              certificateinfo.certificateLocation != nil &&
              certificateinfo.certificateImage != nil
            ) || !certificateinfo.isRestFieldRequired)
        }

        if isCompleted {
            isNextStepEnabled = true
        } else {
            isNextStepEnabled = false
        }
    }

    func validateConsultTypesComplete() {
        let isCompleted = !targetClientTypes.isEmpty &&
            !targetFieldTypes.isEmpty &&
            !targetStyleTypes.isEmpty &&
            !consultingRate.isEmpty &&
            !personalTitle.isEmpty

        if isCompleted {
            isNextStepEnabled = true
        } else {
            isNextStepEnabled = false
        }
    }

    func validateBankInfoComplete() {
        let isCompleted = !firstName.isEmpty &&
            !lastName.isEmpty &&
            !ssn.isEmpty &&
            isValidSSN &&
            !confirmSSN.isEmpty &&
            isMatchedSSN &&
            !birthdate.isEmpty &&
            isValidBirthdate &&
            !confirmBirthdate.isEmpty &&
            isMatchedBirthdate &&
            !routingNumber.isEmpty &&
            isValidRoutingNumber &&
            !confirmRoutingNumber.isEmpty &&
            isMachedRoutingNumber &&
            !checkingNumber.isEmpty &&
            isValidCheckingNumber &&
            !confirmCheckingNumber.isEmpty &&
            isMachedCheckingNumber &&
            !bankName.isEmpty

        if isCompleted {
            isNextStepEnabled = true
        } else {
            isNextStepEnabled = false
        }
    }

    func validateAvailableTimesComplete() {
        if selectedTimeZone != nil {
            isNextStepEnabled = true
        } else {
            isNextStepEnabled = false
        }
    }

    func addSchoolInfo() {
        schoolInfos.insert(SchoolInfoData(), at: 0)
        isNextStepEnabled = false
        validateSchoolInfoComplete()
    }

    func removeSchoolInfo(at index: Int) {
        if schoolInfos.count > 1 {
            schoolInfos.remove(at: index)
        }
    }

    func validateGraduationTime(at index: Int) {
        let schoolInfo = schoolInfos[index]
        if monthYearValidator(schoolInfo.graduationTime) {
            schoolInfo.isValidGraduationTime = true
            schoolInfo.graduationTimeValidationMsg = ""
        } else {
            schoolInfo.isValidGraduationTime = false
            schoolInfo.graduationTimeValidationMsg = "invalid_graudation_time"
        }
    }

    func addCertificateInfo() {
        certificateInfos.insert(CertificateInfoData(), at: 0)
        isNextStepEnabled = false
        validateCertificateInfoComplete()
    }

    func removeCertificateInfo(at index: Int) {
        if certificateInfos.count > 1 {
            certificateInfos.remove(at: index)
        }
    }

    func validateCertificateExpireDate(at index: Int) {
        let certificateInfo = certificateInfos[index]
        if dateMonthYearValidator(certificateInfo.expireDate) {
            certificateInfo.isValidExpireDate = true
            certificateInfo.expireDateValidationMsg = ""
        } else {
            certificateInfo.isValidExpireDate = false
            certificateInfo.expireDateValidationMsg = "invalid_date"
        }
    }

    func validateRestCertificateFieldsRequired(at index: Int) {
        let certificateInfo = certificateInfos[index]
        if certificateInfo.selectedCertificateType?.option != "Pre-license/On license" {
            certificateInfo.isRestFieldRequired = true
        } else {
            certificateInfo.isRestFieldRequired = false
        }
    }

    func selectTargetClientTypes(with type: String) {
        if targetClientTypes.contains(type) {
            targetClientTypes.remove(type)
        } else {
            targetClientTypes.insert(type)
        }
    }

    func selectTargetFieldTypes(with type: String) {
        if targetFieldTypes.contains(type) {
            targetFieldTypes.remove(type)
        } else {
            targetFieldTypes.insert(type)
        }
    }

    func selectTargetStyleTypes(with type: String) {
        if targetStyleTypes.contains(type) {
            targetStyleTypes.remove(type)
        } else {
            targetStyleTypes.insert(type)
        }
    }

    func validateSSN() {
        if ssnValidator(ssn) {
            isValidSSN = true
            ssnValidationMsg = ""
        } else {
            isValidSSN = false
            ssnValidationMsg = "invalid_ssn"
        }
    }

    func validateConfirmSSN() {
        if ssn == confirmSSN {
            isMatchedSSN = true
            confirmSSNValidationMsg = ""
        } else {
            isMatchedSSN = false
            confirmSSNValidationMsg = "mismatch_input_error"
        }
    }

    func validateBirthdate() {
        if dateMonthYearValidator(birthdate) {
            isValidBirthdate = true
            birthdateValidationMsg = ""
        } else {
            isValidBirthdate = false
            birthdateValidationMsg = "invalid_date"
        }
    }

    func validateConfirmBirthdate() {
        if birthdate == confirmBirthdate {
            isMatchedBirthdate = true
            confirmBirthdateValidationMsg = ""
        } else {
            isMatchedBirthdate = false
            confirmBirthdateValidationMsg = "mismatch_date_input_error"
        }
    }

    func validateRoutingNumber() {
        if routingNumberValidator(routingNumber) {
            isValidRoutingNumber = true
            routingNumberValidationMsg = ""
        } else {
            isValidRoutingNumber = false
            routingNumberValidationMsg = "invalid_routing_number"
        }
    }

    func validateConfirmRoutingNumber() {
        if routingNumber == confirmRoutingNumber {
            isMachedRoutingNumber = true
            confirmRoutingNumberValidationMsg = ""
        } else {
            isMachedRoutingNumber = false
            confirmRoutingNumberValidationMsg = "mismatch_input_error"
        }
    }

    func validateCheckingNumber() {
        if checkingNumberValidator(checkingNumber) {
            isValidCheckingNumber = true
            checkingNumberValidationMsg = ""
        } else {
            isValidCheckingNumber = false
            checkingNumberValidationMsg = "invalid_checking_number"
        }
    }

    func validateConfirmCheckingNumber() {
        if routingNumber == confirmRoutingNumber {
            isMachedCheckingNumber = true
            confirmCheckingNumberValidationMsg = ""
        } else {
            isMachedCheckingNumber = false
            confirmCheckingNumberValidationMsg = "mismatch_input_error"
        }
    }
}
