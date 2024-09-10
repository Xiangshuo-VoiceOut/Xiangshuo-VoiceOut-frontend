//
//  TherapistRegistrationVM.swift
//  voiceout
//
//  Created by J. Wu on 7/23/24.
//

import Foundation
import SwiftUI

class TherapistRegistrationVM: ObservableObject {
    @Published var isNextStepEnabled: Bool = false
    @Published var isBasicInfoComplete: Bool = false
    @Published var isSchoolInfoComplete: Bool = false
    @Published var isCertificateInfoComplete: Bool = false
    @Published var isConsultantServiceComplete: Bool = false
    @Published var isBankInformationComplete: Bool = false
    @Published var isTimeAvailabilityComplete: Bool = false
    @Published var currentStep: Int = 0
    @Published var finished: Bool = false
    @Published var selectedGender: DropdownOption?
    @Published var selectedState: DropdownOption?
    @Published var selectedDegree: DropdownOption?
    @Published var selectedCertificationType: DropdownOption?

    @Published var name: String = ""
    @Published var nameMsg = "name_match"
    @Published var phoneNumber: String = ""
    @Published var birthdate: String = ""
    @Published var college: String = ""
    @Published var major: String = ""
    @Published var schoolInfos: [SchoolInfoData] = [SchoolInfoData()]
    @Published var certificateInfos: [CertificateInfoData] = [CertificateInfoData()]
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var ssn: String = ""
    @Published var confirmSSN: String = ""
    @Published var paymentPageBDate: String = ""
    @Published var comfirmPaymentPageBDate: String = ""
    @Published var routingNumber: String = ""
    @Published var confirmRoutingNumber: String = ""
    @Published var checkingNum: String = ""
    @Published var confirmCheckingNum: String = ""
    @Published var bankName: String = ""
    @Published var fee: String = ""
    @Published var title: String = ""

    var allStates: [DropdownOption] {
        return StateData.allStates.map { DropdownOption(option: $0.code)}
    }

    func isCurrentStepComplet(step: Int) -> Bool {
        switch step {
        case 0:
            return isBasicInfoComplete
        case 1:
            return isSchoolInfoComplete
        case 2:
            return isCertificateInfoComplete
        case 3:
            return isConsultantServiceComplete
        case 4:
            return isBankInformationComplete
        case 5:
            return isTimeAvailabilityComplete
        default:
            return false
        }
    }

    init() {
        schoolInfos = [SchoolInfoData()]
        certificateInfos = [CertificateInfoData()]
    }

    func validateSchoolInfo(data: SchoolInfoData) -> Bool {
        return data.degree != nil &&
            !data.college.isEmpty &&
            !data.graduationDate.isEmpty &&
            !data.major.isEmpty
    }

    func addSchoolInfo() {
        schoolInfos.insert(SchoolInfoData(), at: 0)
    }

    func removeSchoolInfo(at index: Int) {
        if schoolInfos.count > 1 {
            schoolInfos.remove(at: index)
        }
    }

    func addCertificateInfo() {
        certificateInfos.insert(CertificateInfoData(), at: 0)
    }

    func removeCertificateInfo(at index: Int) {
        if certificateInfos.count > 1 {
            certificateInfos.remove(at: index)
        }
    }

}

class SchoolInfoData: ObservableObject {
    @Published var degree: DropdownOption?
    @Published var college: String = ""
    @Published var graduationDate: String = ""
    @Published var major: String = ""
}

class CertificateInfoData: ObservableObject {
    @Published var type: DropdownOption?
    @Published var id: String = ""
    @Published var expiryDate: String = ""
    @Published var certificateLocation: DropdownOption?
//    @Published var certificateImage: UIImage? = nil //Todo
}
