//
//  TherapistViewModel.swift
//  Therapist Card
//
//  Created by Yujia Yang on 7/8/24.
//

import Foundation

class ClinicianViewModel: ObservableObject {
    @Published var clinician: Clinician?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func loadTestData() {
        let testClinician = Clinician(
            _id: "1",
            profilePicture: ObjectId(id: "https://s3-alpha-sig.figma.com/img/48c5/5d85/e8fedc280ffc87fabedcd0787f575fc5?Expires=1721606400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=Iz3vQQ3~kxeAX6kehwj~GxXYms6tRiAO2RQVjwDYDojr04c1UR7NLvfq1APHuqWGtt~m~M23mJdM1DRGseEJvriVUrrLEhCfjDcLdd4xqO~ogeKG5jlR~95cO4XBm2Um5pVC3kP9TpmArGDIr4C8KAul3D7GDyQQjlBi1fPfDslKdHYBJgDcD~Cq78769xbQpwaZ1Jr7LgDAWpMnvKuDVnFHp9DZWWl0WIepR0~GYxnT4Dgi40KG3q2iFzGw2CkNM~HtPEB9APiRjotEOg-SzeLKIsDRN9nL2RWR~YY4Q2Svh6bIazdxKwfd0g9hKkRhODy6qSS1DocwVBmuyZachw"),
            isAvailable: true,
            name: "董先生",
            yearOfExperience: 3,
            certificationType: "国家一级心理咨询师",
            consultField: [Tag(tag: "人际关系"), Tag(tag: "焦虑抑郁"), Tag(tag: "LGBT")],
            avgRating: 4.8,
            charge: 200
        )
        self.clinician = testClinician
        self.errorMessage = nil
    }
    
    
    
    
    
    func fetchClinician() {
        isLoading = true
        guard let url = URL(string: "http://localhost:3000/api/profile/me") else {
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
            }
            
            guard let data = data, error == nil else {
                self.errorMessage = error?.localizedDescription ?? "Unknown error"
                return
            }
            
            do {
                let clinicians = try JSONDecoder().decode([Clinician].self, from: data)
                if let clinician = clinicians.first {
                    self.clinician = clinician
                    self.errorMessage = nil
                } else {
                    self.errorMessage = "No therapist data found"
                }
            } catch {
                self.errorMessage = error.localizedDescription
                print("Error decoding clinicians: \(error.localizedDescription)")
            }
        }.resume()
    }

       }

