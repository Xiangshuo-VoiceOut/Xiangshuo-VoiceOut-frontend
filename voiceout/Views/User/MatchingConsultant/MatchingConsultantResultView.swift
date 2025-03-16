//
//  MatchingConsultantResultView.swift
//  voiceout
//
//  Created by Yujia Yang on 2/2/25.
//

import SwiftUI

struct MatchingConsultantResultView: View {
    @State private var radarData: [RadarData] = []
    @State private var maxValue: Double = 1.0
    @State private var surveyResultId: String
    @EnvironmentObject var router: RouterModel
    @State private var showExitPopup = false

    init(surveyResultId: String) {
        self.surveyResultId = surveyResultId
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.surfacePrimaryGrey2.edgesIgnoringSafeArea(.all)

            VStack(spacing: ViewSpacing.large) {
                HStack(alignment: .center) {
                    Image("cloud2")
                        .frame(width: 166, height: 96)
                    
                    Spacer()
                    
                    Text("感谢您完成问卷，根据调查结果显示，以下是你的测试报告")
                        .font(.typography(.bodyMedium))
                        .foregroundColor(.grey300)
                        .padding(ViewSpacing.medium)
                        .background(Color.surfacePrimary)
                        .cornerRadius(CornerRadius.medium.value)
                }
                .padding(.top, ViewSpacing.medium)
                
                if radarData.isEmpty {
                    Text("加载中...")
                        .font(.typography(.bodyMedium))
                        .foregroundColor(.grey300)
                } else {
                    
                    Spacer()
                    
                    RadarChartView(data: radarData, maxValue: maxValue)
                    
                    Spacer()
                }
                
                ScrollView {
                    VStack(alignment: .leading, spacing: ViewSpacing.medium) {
                        HStack(alignment: .top) {
                            Text("解析")
                                .font(.typography(.bodyMediumEmphasis))
                                .foregroundColor(.textPrimary)
                            
                            Spacer()
                            
                            HStack(alignment: .center, spacing: 0) {
                                Text("查看更多")
                                    .font(.typography(.bodyMedium))
                                    .multilineTextAlignment(.trailing)
                                    .foregroundColor(.grey500)
                                    .frame(alignment: .trailing)
                                
                                Image("right-arrow")
                                    .frame(width: 16, height: 16)
                                    .foregroundColor(.grey500)
                            }
                            .frame(maxHeight: .infinity, alignment: .center)
                        }
                        .frame(maxWidth: .infinity, alignment: .top)
                        
                        VStack(alignment: .leading, spacing: ViewSpacing.medium) {
                            ForEach(sampleDetails) { detail in
                                VStack(alignment: .leading, spacing: ViewSpacing.xsmall) {
                                    HStack(alignment: .center, spacing: 135) {
                                        Text(detail.title)
                                            .font(.typography(.bodySmall))
                                            .foregroundColor(.textPrimary)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    HStack(alignment: .top, spacing: ViewSpacing.xsmall) {
                                        Text(detail.description)
                                            .font(.typography(.bodyXSmall))
                                            .kerning(0.24)
                                            .foregroundColor(.textSecondary)
                                            .frame(maxWidth: .infinity, alignment: .topLeading)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                }
                                .frame(alignment: .topLeading)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    }
                    .padding(ViewSpacing.medium)
                    .background(Color.surfacePrimary)
                    .cornerRadius(CornerRadius.medium.value)
                }
                
                ButtonView(
                    text: "确定",
                    action: {
                        router.navigateTo(.matchingLoading)
                    },
                    variant: .solid,
                    theme: .action,
                    fontSize: .medium,
                    borderRadius: .full,
                    maxWidth: 358
                )
                .padding(.bottom, ViewSpacing.medium)
            }
            .padding(.horizontal, ViewSpacing.medium)
        }
        .onAppear {
            fetchRadarData()
        }
    }

    private func fetchRadarData() {

        MatchingConsultantService.submitFinalSurveyResults(surveyResultId: surveyResultId, currentSectionId: 35) { radarData in
            guard let radarData = radarData else {
                return
            }
            DispatchQueue.main.async {
                self.radarData = radarData
                self.maxValue = radarData.map { $0.value }.max() ?? 1.0
            }
        }
    }
}

struct RelationshipDetails: Identifiable {
    let id = UUID()
    let title: String
    let description: String
}

let sampleDetails = [
    RelationshipDetails(title: "亲密关系", description: "亲密关系问题包括沟通不畅、信任缺失、情感疏离和冲突频发等。这些问题可能导致关系破裂，需要双方共同努力解决和维护。"),
    RelationshipDetails(title: "人际关系", description: "人际关系问题包括沟通不畅、信任缺失、误解和冲突。这些问题可能导致关系紧张和疏远，需通过有效沟通和理解来改善和维持良好的人际关系。"),
    RelationshipDetails(title: "情感障碍", description: "情感障碍包括抑郁、焦虑、情绪失调等问题。这些障碍会影响一个人的日常生活和人际关系，通常需要专业的心理治疗和支持来帮助管理和改善情绪健康。")
]

#Preview {
    MatchingConsultantResultView(surveyResultId: "sample_survey_result_id")
}
