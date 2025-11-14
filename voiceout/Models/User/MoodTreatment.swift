//
//  MoodTreatment.swift
//  voiceout
//
//  Created by Yujia Yang on 5/14/25.
//

import Foundation

enum QuestionType: String, Decodable {///题型
    case singleChoice
    case multiChoice
    case fillInBlank
    case animationOnly
    case slider
    case openText
    case custom
}

enum QuestionUIStyle: String, Decodable { ///ui页面
    ///Angry
    case styleA///single
    case styleB///云朵+黑文字+绿文字
    case styleC///animation
    case styleD///slider
    case styleE///multiple
    case styleF ///fillInBlank
    case styleG ///openText
    case styleNote ///note
    case styleBottle///bottle
    case styleAngryEnding /// end
    case styleAngryTiming/// end
    
    ///Envy
    case styleH///single
    case styleI///multi
    case styleJ///ai
    case styleScrollDown///下拉选项
    case styleMirror///mirror pieces
    case styleTyping///打字题
    case styleEnvyEnding///结束
    case styleEnvyFinalEnding///最终结束页面，文案随机
    
    ///Scare
    case scareStyleA///single
    case scareStyleB///multiple
    case scareStyleC///slider
    case scareStyleD///云朵+黑文字+绿文字
    case scareStyleLocation///Location
    case scareStyleBreathe///Breathe
    case scareStyleEnding///end
    case scareStyleMoodWriting///moodwriting
    case scareStyleBottle///bottle
    case scareStyleBubble1///bubble1
    case scareStyleBubble2///bubble2
    case scareStyleTyping///typing

    ///Guilt
    case guiltStyleA///single
    case guiltStyleB///multiple
    
    ///伤心+内疚共用
    case sliderStyle
    
    ///Custom
    case unknown
    
    init(from decoder: Decoder) throws {
        let raw = try decoder.singleValueContainer().decode(String.self)
        switch raw {
        ///Angry
        case "styleA":             self = .styleA
        case "styleB":             self = .styleB
        case "styleC":             self = .styleC
        case "styleD":             self = .styleD
        case "styleE":             self = .styleE
        case "styleF":             self = .styleF
        case "styleG":             self = .styleG
        case "styleNote":          self = .styleNote
        case "styleBottle":        self = .styleBottle
        case "styleAngryEnding":   self = .styleAngryEnding
        case "AngryQuestionStyleTimingView": self = .styleAngryTiming
            
        ///Envy
        case "styleH":             self = .styleH
        case "styleI":             self = .styleI
        case "styleJ":             self = .styleJ
        case "styleScrollDown":    self = .styleScrollDown
        case "styleMirror":        self = .styleMirror
        case "styleTyping":        self = .styleTyping
        case "styleEnvyEnding":    self = .styleEnvyEnding
        case "styleEnvyFinalEnding": self = .styleEnvyFinalEnding
            
        ///Scare
        case "scareStyleA":             self = .scareStyleA
        case "scareStyleB":             self = .scareStyleB
        case "scareStyleC":             self = .scareStyleC
        case "scareStyleD":             self = .scareStyleD
        case "scareStyleLocation":      self = .scareStyleLocation
        case "scareStyleBreathe":       self = .scareStyleBreathe
        case "scareStyleEnding":       self = .scareStyleEnding
        case "scareStyleMoodWriting":       self = .scareStyleMoodWriting
        case "scareStyleBottle":       self = .scareStyleBottle
        case "scareStyleBubble1":       self = .scareStyleBubble1
        case "scareStyleBubble2":       self = .scareStyleBubble2
        case "scareStyleTyping":       self = .scareStyleTyping
                
        ///Guilt
        case "guiltStyleA":             self = .guiltStyleA
        case "guiltStyleB":             self = .guiltStyleB
        
        ///伤心+内疚共用
        case "sliderStyle": self = .sliderStyle

        default:
            self = .unknown
        }
    }
    
    var rawValue: String {
        switch self {
        case .styleA:               return "styleA"
        case .styleB:               return "styleB"
        case .styleC:               return "styleC"
        case .styleD:               return "styleD"
        case .styleE:               return "styleE"
        case .styleF:               return "styleF"
        case .styleG:               return "styleG"
        case .styleNote:            return "styleNote"
        case .styleBottle:          return "styleBottle"
        case .styleAngryEnding:     return "styleAngryEnding"
        case .styleAngryTiming:     return "styleAngryTiming"
            
        case .styleH:               return "styleH"
        case .styleI:               return "styleI"
        case .styleJ:               return "styleJ"
        case .styleScrollDown:      return "styleScrollDown"
        case .styleMirror:          return "styleMirror"
        case .styleTyping:          return "styleTyping"
        case .styleEnvyEnding:      return "styleEnvyEnding"
        case .styleEnvyFinalEnding: return "styleEnvyFinalEnding"
        
        case .scareStyleA:            return "scareStyleA"
        case .scareStyleB:            return "scareStyleB"
        case .scareStyleC:            return "scareStyleC"
        case .scareStyleD:            return "scareStyleD"
        case .scareStyleLocation:     return "scareStyleLocation"
        case .scareStyleBreathe:      return "scareStyleBreathe"
        case .scareStyleEnding:      return "scareStyleEnding"
        case .scareStyleMoodWriting:      return "scareStyleMoodWriting"
        case .scareStyleBottle:      return "scareStyleBottle"
        case .scareStyleBubble1:      return "scareStyleBubble1"
        case .scareStyleBubble2:      return "scareStyleBubble2"
        case .scareStyleTyping:      return "scareStyleTyping"
            
        case .guiltStyleA:            return "guiltStyleA"
        case .guiltStyleB:            return "guiltStyleB"
            
        case .sliderStyle: return "sliderStyle"

        case .unknown:
            return ""
        }
    }
}

struct MoodTreatmentAnswerOption: Identifiable, Decodable, Hashable {///答案
    let id = UUID()
    let key: String
    let text: String
    let next: Int?
    let exclusive: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case key, text, next, exclusive
    }
}

struct MoodTreatmentQuestion: Identifiable, Decodable, Hashable { ///问题的字段
    let id: Int
    let totalQuestions: Int?
    let type: QuestionType
    let uiStyle: QuestionUIStyle
    let texts: [String]?
    let animation: String?
    let options: [MoodTreatmentAnswerOption]
    let introTexts: [String]?
    var showBackButton: Bool = false
    //var showSlider: Bool = false
    let showSlider: Bool?
    var buttonTitle: String = ""
    let endingStyle: String?
    var customViewName: String? = nil ///特殊题型直接返回前端View的名字
    let routine: String?
    var viewIdentifier: String {
        if type == .custom, let name = customViewName {
            return name
        }
        return uiStyle.rawValue
    }
    
    private enum CodingKeys: String, CodingKey {
        case id            = "_id"
        case totalQuestions
        case type
        case uiStyle
        case customViewName
        case texts
        case introTexts
        case animation
        case options
        case showSlider
        case endingStyle
        case routine
        case buttonTitle
    }
}

