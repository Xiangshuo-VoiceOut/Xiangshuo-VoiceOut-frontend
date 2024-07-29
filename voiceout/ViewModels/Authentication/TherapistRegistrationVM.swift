//
//  TherapistRegistrationVM.swift
//  voiceout
//
//  Created by J. Wu on 7/23/24.
//

import Foundation

class TherapistRegistrationVM: ObservableObject{
    @Published var isNextStepEnabled: Bool = false
    @Published var isBasicInfoComplete: Bool = false
    @Published var isSchoolInfoComplete: Bool = false
    @Published var isCertificateInfoComplete: Bool = false
    @Published var isConsultantServiceComplete: Bool = false
    @Published var currentStep: Int = 0
    @Published var finished: Bool = false
    @Published var selectedGender: DropdownOption? = nil
    @Published var selectedState: DropdownOption? = nil
    @Published var selectedDegree: DropdownOption? = nil
    @Published var selectedCertificationType: DropdownOption? = nil
    
    @Published var name: String = ""
    @Published var nameMsg = "name_match"
    @Published var phoneNumber: String = ""
    @Published var birthdate: String = ""
    @Published var college: String = ""
    @Published var major: String = ""
    @Published var schoolInfos: [SchoolInfoData] = []
    @Published var certificateInfos:[CertificateInfoData] = []
    
//    var isNextStepEnabled: Bool {
//            switch currentStep {
//            case 0:
//                return isBasicInfoComplete
//            case 1:
//                return isSchoolInfoComplete
//            case 2:
//                return isCertificateInfoComplete
//            case 3:
//                return isConsultantServiceComplete
//            default:
//                return false
//            }
//        }
    
    init(){
        schoolInfos = [SchoolInfoData()]
        certificateInfos = [CertificateInfoData()]
    }
    
    func addSchoolInfo(){
        schoolInfos.insert(SchoolInfoData(), at: 0)
    }
    
    func removeSchoolInfo(at index: Int){
        if schoolInfos.count > 1{
            schoolInfos.remove(at: index)
        }
    }
    
    func addCertificateInfo(){
        certificateInfos.insert(CertificateInfoData(), at: 0)
    }
    
    func removeCertificateInfo(at index: Int) {
        if certificateInfos.count > 1{
            certificateInfos.remove(at: index)
        }
    }
    
}

struct SchoolInfoData{
    var degree: String = ""
    var college: String = ""
    var graduationDate: String = ""
    var major: String = ""
}

struct CertificateInfoData{
    var type: String = ""
    var id: String = ""
    var expiryDate: String = ""
    var certificateLocation: String = ""
    var certificateImage: String = ""
}
