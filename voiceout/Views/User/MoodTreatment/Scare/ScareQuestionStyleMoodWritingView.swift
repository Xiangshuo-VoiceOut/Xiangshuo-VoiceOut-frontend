//
//  ScareQuestionStyleMoodWritingView.swift
//  voiceout
//
//  Created by Yujia Yangon 9/17/25.
//

import SwiftUI

struct ScareQuestionStyleMoodWritingView: View {
    let question: MoodTreatmentQuestion
    let onSelect: (MoodTreatmentAnswerOption) -> Void

    @State private var selectedKeywords: [String] = []
    @State private var isPlayingMusic: Bool = true

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                Color.surfaceBrandTertiaryGreen.ignoresSafeArea()

                VStack(spacing: 0) {
                    ZStack(alignment: .top) {
//                        HStack {
//                            MusicButtonView()
//                            Spacer()
//                        }
//                        .padding(.leading, ViewSpacing.medium)
                    }

                    Text("开始描述你的情绪。你感到害怕吗？还是其他感受？")
                        .font(.typography(.bodyMedium))
                        .foregroundColor(.grey500)
                        .frame(alignment: .topLeading)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 2*ViewSpacing.xlarge)
                        .padding(.bottom, ViewSpacing.betweenSmallAndBase+ViewSpacing.base+ViewSpacing.xlarge)

                    ZStack {
                        let keywordOptions = question.options.filter { $0.exclusive != true }
                        let positions: [CGSize] = [
                            .init(width: -100, height: -80),
                            .init(width:  100, height: -80),
                            .init(width:    0, height: -10),
                            .init(width: -100, height:  60),
                            .init(width:  100, height:  60),
                            .init(width:    0, height: 120),
                            .init(width: -100, height: 190),
                            .init(width:  100, height: 190),
                            .init(width:    0, height: 250),
                        ]

                        ForEach(Array(keywordOptions.prefix(positions.count).enumerated()), id: \.element.key) { index, opt in
                            KeywordBeeButton(keyword: opt.text, selectedKeywords: $selectedKeywords)
                                .offset(x: positions[index].width, y: positions[index].height)
                        }
                    }
                    .frame(height: 220)
                    .padding(.bottom, ViewSpacing.large)

                    VStack{
                        VStack(alignment: .leading, spacing: ViewSpacing.betweenSmallAndBase) {
                            Text("我的关键词：")
                                .font(.typography(.bodyMedium))
                                .foregroundColor(.grey500)
                                .padding(.leading,ViewSpacing.medium)
                                .padding(.top,ViewSpacing.medium)
                            
                            if selectedKeywords.isEmpty {
                            } else {
                                LazyVGrid(
                                    columns: [
                                        GridItem(.fixed(88), spacing: ViewSpacing.xxsmall),
                                        GridItem(.fixed(88), spacing: ViewSpacing.xxsmall),
                                        GridItem(.fixed(88), spacing: ViewSpacing.xxsmall)
                                    ],
                                    spacing: ViewSpacing.small
                                ) {
                                    ForEach(selectedKeywords, id: \.self) { keyword in
                                        KeywordBeeStaticView(keyword: keyword)
                                    }
                                }
                                .padding(.leading,-ViewSpacing.small-ViewSpacing.betweenSmallAndBase-ViewSpacing.xlarge)

                            }
                        }
                        .frame(width: 326, height: 160, alignment: .topLeading)
                        .background(Color.surfacePrimary)
                        .overlay(
                            RoundedRectangle(cornerRadius: CornerRadius.small.value)
                                .stroke(Color(red: 0.6, green: 0.83, blue: 0.95), lineWidth: 4)
                        )
                    }
                    .padding(.top,ViewSpacing.betweenSmallAndBase+ViewSpacing.xlarge+120)
                        
                    Spacer()

                    if let confirmOption = question.options.first(where: { $0.exclusive == true }) {
                        Button(action: {
                            AnalyticsManager.shared.logClick(
                                elementName: "confirm_button",
                                screenName: "ScareQuestionStyleMoodWriting",
                                additionalParams: [
                                    "question_id": question.id,
                                    "selected_keywords_count": selectedKeywords.count
                                ]
                            )
                            
                            onSelect(confirmOption)
                        }) {
                            Text(confirmOption.text)
                                .font(.typography(.bodyMedium))
                                .kerning(0.64)
                                .foregroundColor(.brandPrimary)
                                .frame(width: 114, height: 44)
                                .background(Color.surfacePrimary)
                                .cornerRadius(CornerRadius.full.value)
                        }
                        .opacity(selectedKeywords.isEmpty ? 0.4 : 1)
                        .disabled(selectedKeywords.isEmpty)
                        .padding(.bottom, ViewSpacing.xlarge)
                    }
                }
            }
        }
    }
}

struct KeywordBeeButton: View {
    let keyword: String
    @Binding var selectedKeywords: [String]

    var isSelected: Bool {
        selectedKeywords.contains(keyword)
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: CornerRadius.xsmall.value)
                .fill(isSelected ? Color.white : Color(red: 1, green: 0.92, blue: 0.6))
                .frame(width: 96, height: 32)

            Text(keyword)
                .font(.typography(.bodyMedium))
                .foregroundColor(.grey500)
                .offset(x: ViewSpacing.xsmall+ViewSpacing.betweenSmallAndBase)

            Image("bee")
                .frame(width: 51, height: 51)
                .offset(x: -ViewSpacing.xlarge-ViewSpacing.xsmall)
        }

        .onTapGesture {
            toggleKeyword()
        }
    }

    private func toggleKeyword() {
        if isSelected {
            selectedKeywords.removeAll { $0 == keyword }
        } else {
            selectedKeywords.append(keyword)
        }
    }
}

struct KeywordBeeStaticView: View {
    let keyword: String

    var body: some View {
        HStack(spacing: 0) {
            Text(keyword)
                .font(.typography(.bodyMedium))
                .foregroundColor(.grey500)
        }
        .padding(.horizontal,ViewSpacing.medium)
        .padding(.vertical, ViewSpacing.xxxsmall)
        .background(Color(red: 1, green: 0.92, blue: 0.6))
        .cornerRadius(CornerRadius.xsmall.value)
    }
}

struct WrapView<Data: RandomAccessCollection, Content: View>: View where Data.Element: Hashable {
    let data: Data
    let spacing: CGFloat
    let content: (Data.Element) -> Content

    @State private var totalHeight: CGFloat = .zero

    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
        }
        .frame(height: totalHeight)
    }

    private func generateContent(in geometry: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(self.data, id: \.self) { item in
                self.content(item)
                    .padding(.trailing, spacing)
                    .padding(.bottom, spacing)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (width + d.width + spacing) > geometry.size.width {
                            width = 0
                            height -= d.height + spacing
                        }
                        let result = width
                        width += d.width + spacing
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { _ in height })
            }
        }
        .background(
            GeometryReader { geo -> Color in
                DispatchQueue.main.async {
                    self.totalHeight = geo.size.height
                }
                return Color.clear
            }
        )
    }
}

#Preview {
    ScareQuestionStyleMoodWritingView(
        question: MoodTreatmentQuestion(
            id: 1,
            totalQuestions: 45,
            uiStyle: .scareStyleMoodWriting,
            texts: ["开始描述你的情绪。你感到害怕吗？还是其他感受？"],
            animation: nil,
            options: [
                .init(key: "A", text: "害怕", next: nil, exclusive: false),
                .init(key: "B", text: "焦虑", next: nil, exclusive: false),
                .init(key: "C", text: "无助", next: nil, exclusive: false),
                .init(key: "D", text: "孤单", next: nil, exclusive: false),
                .init(key: "E", text: "不确定", next: nil, exclusive: false),
                .init(key: "F", text: "紧张", next: nil, exclusive: false),
                .init(key: "G", text: "伤心", next: nil, exclusive: false),
                .init(key: "H", text: "开心", next: nil, exclusive: false),
                .init(key: "I", text: "平静", next: nil, exclusive: false),
                .init(key: "J", text: "我选好了", next: 2, exclusive: true),
            ],
            introTexts: nil,
            showSlider: nil,
            endingStyle: nil,
            routine: "scare"
        ),
        onSelect: { selected in
        }
    )
}
