//
//  MatchingConsultantService.swift
//  voiceout
//
//  Created by Yujia Yang on 2/9/25.
//

import SwiftUI

class MatchingConsultantService {
    static let baseURL = "http://localhost:4001/api/userSurveys"

    static func fetchFirstQuestion(userId: String, forceRestart: Bool = false, completion: @escaping (SurveyResponse?) -> Void) {
        guard let url = URL(string: "\(baseURL)/firstQuestion") else {
            return
        }
        
        let body: [String: Any] = forceRestart ? ["userId": userId, "restart": true] : ["userId": userId]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(SurveyResponse.self, from: data)
                
                DispatchQueue.main.async {
                    completion(decodedResponse)
                }
            } catch {
                completion(nil)
            }
        }.resume()
    }
    
    static func navigateToNextQuestion(_ nextQuestion: Question, router: RouterModel, surveyId: String, surveyResultId: String) {
        switch nextQuestion.optionsType {
        case "single":
            router.navigateTo(.singleChoice(question: nextQuestion, surveyId: surveyId, surveyResultId: surveyResultId))
        case "scale":
            router.navigateTo(.rating(question: nextQuestion, surveyId: surveyId, surveyResultId: surveyResultId))
        case "multiple":
            router.navigateTo(.multipleChoice(question: nextQuestion, surveyId: surveyId, surveyResultId: surveyResultId, nextQuestion: nil))
        case "multiple-editable":
            router.navigateTo(.multipleChoiceEditable(question: nextQuestion, surveyId: surveyId, surveyResultId: surveyResultId))
        default:
            print("❌ 未知题型: \(nextQuestion.optionsType)")
        }
    }
    
    static func fetchNextQuestion(requestBody: [String: Any], completion: @escaping (APIResponse?) -> Void) {
        let url = URL(string: "\(baseURL)/next-question")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            do {
                var apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)

                if var nextQuestionData = apiResponse.data, var nextQuestion = nextQuestionData.section {
                    let currentSectionId = requestBody["currentSectionId"] as? Int ?? 1

                    let totalQuestions = nextQuestionData.page?.totalQuestions ?? 35

                    let previousIndex = nextQuestionData.page?.sectionIndex ?? currentSectionId
                    let sectionIndex = min(previousIndex, totalQuestions)
                    nextQuestion.sectionIndex = sectionIndex

                    let isNextQuestionAvailable = sectionIndex < totalQuestions
                    nextQuestionData.isNext = isNextQuestionAvailable

                    if nextQuestion.optionsType == "scale" {
                        let selectedOptions = requestBody["selectedOptions"] as? [[String: Any]]
                        let userSelectedScore = selectedOptions?.first?["optionScore"] as? Int ?? 0
                        nextQuestion.options = nextQuestion.options.map { option in
                            var updatedOption = option
                            updatedOption.score = userSelectedScore
                            return updatedOption
                        }
                    }

                    nextQuestionData.section = nextQuestion
                    apiResponse.data = nextQuestionData

                }

                DispatchQueue.main.async {
                    completion(apiResponse)
                }
            } catch {
                completion(nil)
            }
        }.resume()
    }

    static func submitFinalSurveyResults(surveyResultId: String, currentSectionId: Int, completion: @escaping ([RadarData]?) -> Void) {
        let requestBody: [String: Any] = [
            "surveyResultId": surveyResultId,
            "currentSectionId": currentSectionId,
            "action": "submit",
            "selectedOptions": []
        ]

        guard let url = URL(string: "\(baseURL)/next-question") else {
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(nil)
                return
            }

            guard let data = data else {
                completion(nil)
                return
            }

            let rawResponse = String(data: data, encoding: .utf8) ?? "❌ 无法解析文本"

            do {
                let response = try JSONDecoder().decode(SurveyResultResponse.self, from: data)

                guard let categoryGroups = response.data?.answer?.categoryGroup else {
                    completion(nil)
                    return
                }

                let radarData = categoryGroups.map { RadarData(dimension: $0.category, value: Double($0.score)) }

                DispatchQueue.main.async {
                    completion(radarData)
                }
            } catch {
                completion(nil)
            }
        }.resume()
    }
    
    static func fetchRecommendedClinicians(userId: String, completion: @escaping ([Clinician]?) -> Void) {
        guard let url = URL(string: "http://localhost:4001/api/users/recommandations") else {
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let requestBody: [String: Any] = ["userId": userId]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil)
                return
            }

            guard let data = data else {
                completion(nil)
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode([RecommendedClinician].self, from: data)

                let clinicians = decodedResponse.compactMap { recommended -> Clinician? in
                    return recommended.toClinician()
                }

                DispatchQueue.main.async {
                    completion(clinicians)
                }
            } catch {
                completion(nil)
            }
        }.resume()
    }
}

struct APIResponse: Codable {
    let message: String?
    var data: NextQuestionData?
}

struct APIErrorResponse: Codable {
    let error: String?
}

struct NextQuestionData: Codable {
    var section: Question?
    let page: PageInfo?
    let totalScore: Int?
    var isNext: Bool?
    let isPrev: Bool?
}

struct SurveyResponse: Codable {
    let success: Bool
    let message: String
    let data: SurveyData
}

struct SurveyData: Codable {
    let surveyId: String
    let userId: String
    let surveyResultId: String
    let page: PageInfo
    let section: Question

    enum CodingKeys: String, CodingKey {
        case surveyId, userId, surveyResultId, page, section
    }
}

struct PageInfo: Codable {
    let hasPrev: Bool?
    let hasNext: Bool?
    let totalQuestions: Int?
    let sectionIndex: Int?
}

struct Question: Codable, Hashable {
    let sectionId: Int
    let sectionTitle: String
    let category: String
    let nextSection: Int?
    let optionsType: String
    var options: [Option]
    var totalQuestions: Int?
    var sectionIndex: Int?
    var answer: Answer?

    static func == (lhs: Question, rhs: Question) -> Bool {
        return lhs.sectionId == rhs.sectionId &&
            lhs.sectionTitle == rhs.sectionTitle &&
            lhs.category == rhs.category &&
            lhs.nextSection == rhs.nextSection &&
            lhs.optionsType == rhs.optionsType &&
            lhs.options == rhs.options &&
            lhs.totalQuestions == rhs.totalQuestions &&
            lhs.sectionIndex == rhs.sectionIndex &&
            lhs.answer == rhs.answer
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(sectionId)
        hasher.combine(sectionTitle)
        hasher.combine(category)
        hasher.combine(nextSection)
        hasher.combine(optionsType)
        hasher.combine(options)
        hasher.combine(totalQuestions)
        hasher.combine(sectionIndex)
        hasher.combine(answer)
    }
}

struct Answer: Codable, Equatable, Hashable {
    let sectionId: Int?
    let nextSectionId: Int?
    let options: [SelectedOption]?
    let other: String?
    
    init(sectionId: Int? = nil, nextSectionId: Int? = nil, options: [SelectedOption]? = nil, other: String? = nil) {
        self.sectionId = sectionId
        self.nextSectionId = nextSectionId
        self.options = options
        self.other = other
    }
}

struct SelectedOption: Codable, Equatable, Hashable {
    let nextSectionId: Int?
    let optionText: String
    let selectedOption: Int
    let score: Int
}

struct Option: Codable, Equatable, Hashable {
    let optionText: String
    let nextSection: Int?
    let _id: String
    var score: Int
    enum CodingKeys: String, CodingKey {
        case optionText, nextSection, _id, score
    }

    init(optionText: String, nextSection: Int?, score: Int?, _id: String) {
        self.optionText = optionText
        self.nextSection = nextSection
        self._id = _id
        self.score = score ?? 0
    }
}

struct CategoryScore: Codable {
    let category: String
    let score: Int
}

struct SurveyResultResponse: Codable {
    let message: String?
    let data: SurveyResultData?
    let error: String?
}

struct SurveyResultData: Codable {
    let totalScore: Int
    let answer: AnswerData?

    struct AnswerData: Codable {
        let categoryGroup: [CategoryScore]
    }
}

struct RecommendedClinician: Codable {
    let doctorId: String
    let score: String
    let info: ClinicianInfo

    func toClinician() -> Clinician {
        return Clinician(
            _id: doctorId,
            name: info.name,
            certification: [],
            charge: 200,
            consultField: info.parseConsultField(),
            yearOfExperience: 10,
            profilePicture: info.profilePicture,
            ratingCount: info.parseAvgRating()
        )
    }
}

struct ClinicianInfo: Codable {
    let name: String
    let avgRating: String?
    let profilePicture: String?
    let ConsultField: String?

    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case avgRating = "avgRating"
        case profilePicture = "ProfilePicture"
        case ConsultField = "ConsultField"
    }

    func parseConsultField() -> [Tag] {
        guard let data = ConsultField?.data(using: .utf8) else { return [] }
        return (try? JSONDecoder().decode([Tag].self, from: data)) ?? []
    }

    func parseAvgRating() -> Int {
        guard let avgRating = avgRating, let rating = Double(avgRating) else { return 0 }
        return Int(rating)
    }
}
