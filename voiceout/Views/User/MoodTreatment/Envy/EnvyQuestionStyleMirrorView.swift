//
//  EnvyQuestionStyleMirrorView.swift
//  voiceout
//
//  Created by Yujia Yang on 6/30/25.
//

import SwiftUI

private struct Shard: Identifiable {
    let id = UUID()
    let imageName: String
    let label: String
    let rotation: Angle
    let offset: CGPoint
    let size: CGSize
}

private struct ShardView: View {
    let shard: Shard
    let isSelected: Bool

    var body: some View {
        ZStack {
            if isSelected {
                Image(shard.imageName)
                    .renderingMode(.template)
                    .foregroundColor(Color(red: 0.86, green: 0.65, blue: 0.38))
                    .opacity(0.8)
                    .frame(width: shard.size.width, height: shard.size.height)
                    .scaleEffect(1.15)
                    .shadow(color: Color(red: 0.54, green: 0.28, blue: 0.32),
                            radius: 0, x: 2, y: 2)
            }
            Image(shard.imageName)
                .frame(width: shard.size.width, height: shard.size.height)
            Text(shard.label)
                .font(.typography(.bodyMedium))
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.center)
                .frame(width: shard.size.width * 0.6,
                       height: shard.size.height * 0.6)
        }
        .rotationEffect(shard.rotation)
        .offset(x: shard.offset.x, y: shard.offset.y)
    }
}

struct EnvyQuestionStyleMirrorView: View {
    let question: MoodTreatmentQuestion
    let requiredSelections: Int?
    let onSelect: (MoodTreatmentAnswerOption) -> Void

    @State private var selectedIndices: Set<Int> = []
    @State private var isPlayingMusic = true
    @State private var showShards = false

    private let questionTypingInterval: TimeInterval = 0.1

    private let layoutInfo: [(String, Angle, CGPoint, CGSize)] = [
        ("envy-mirror1", .degrees(0),    .init(x: -130, y: -90),  .init(width: 138.62, height: 98.22)),
        ("envy-mirror1", .degrees(-20),  .init(x: -15,  y: -120), .init(width: 118.29, height: 83.82)),
        ("envy-mirror6", .degrees(0),    .init(x: 110,  y: -100), .init(width: 118.29, height: 87.48)),
        ("envy-mirror4", .degrees(5),    .init(x: -50,  y: -30),  .init(width: 111.2,  height: 121.63)),
        ("envy-mirror2", .degrees(0),    .init(x: -130, y: 50),   .init(width: 135.76, height: 96.2)),
        ("envy-mirror3", .degrees(0),    .init(x: 15,   y: 50),   .init(width: 134.12, height: 95.04)),
        ("envy-mirror2", .degrees(15),   .init(x: 130,  y: 40),   .init(width: 118.29, height: 83.82)),
        ("envy-mirror6", .degrees(0),    .init(x: -110, y: 130),  .init(width: 118.29, height: 87.48)),
        ("envy-mirror5", .degrees(0),    .init(x: 10,   y: 140),  .init(width: 129.13, height: 91.5)),
        ("envy-mirror7", .degrees(0),    .init(x: 130,  y: 140),  .init(width: 101.4,  height: 71.85)),
    ]

    private var shards: [Shard] {
        let nonExcl = question.options.filter { $0.exclusive == false }
        return Array(zip(layoutInfo, nonExcl)).map { layout, opt in
            Shard(
                imageName: layout.0,
                label: opt.text,
                rotation: layout.1,
                offset: layout.2,
                size: layout.3
            )
        }
    }

    private var confirmOption: MoodTreatmentAnswerOption? {
        question.options.first { $0.exclusive == true }
    }

    private var needCount: Int {
        if let r = requiredSelections { return r }
        return question.type == .multiChoice ? 3 : 1
    }

    init(
        question: MoodTreatmentQuestion,
        requiredSelections: Int? = nil,
        onSelect: @escaping (MoodTreatmentAnswerOption) -> Void
    ) {
        self.question = question
        self.requiredSelections = requiredSelections
        self.onSelect = onSelect
    }

    var body: some View {
        GeometryReader { _ in
            ZStack(alignment: .topLeading) {
                Color.surfaceBrandTertiaryGreen.ignoresSafeArea()

                VStack(spacing: 0) {
                    ZStack(alignment: .top) {
                        HStack {
                            Spacer()
                            Image("cloud-chat")
                                .resizable()
                                .frame(width: 168, height: 120)
                                .padding(.bottom, ViewSpacing.large)
                            Spacer()
                        }
                        
                        HStack {
                            MusicButtonView()
                            Spacer()
                        }
                    }
                    .padding(.leading, ViewSpacing.medium)

                    ForEach(Array(question.texts?.enumerated() ?? [].enumerated()),
                            id: \.offset) { idx, line in
                        TypewriterText(fullText: line, characterDelay: questionTypingInterval) {
                            if idx == (question.texts?.count ?? 1) - 1 {
                                withAnimation { showShards = true }
                            }
                        }
                        .font(.typography(.bodyMedium))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.grey500)
                        .padding(.horizontal, 2*ViewSpacing.xlarge)
                    }

                    if showShards {
                        ZStack {
                            ForEach(shards.indices, id: \.self) { idx in
                                ShardView(
                                    shard: shards[idx],
                                    isSelected: selectedIndices.contains(idx)
                                )
                                .onTapGesture {
                                    if question.type == .singleChoice {
                                        selectedIndices = [idx]
                                    } else {
                                        if selectedIndices.contains(idx) {
                                            selectedIndices.remove(idx)
                                        } else {
                                            selectedIndices.insert(idx)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.top, ViewSpacing.medium+ViewSpacing.xxxxlarge)
                        .frame(maxWidth: .infinity)

                        if selectedIndices.count >= needCount,
                           let confirm = confirmOption {
                            Button(action: { onSelect(confirm) }) {
                                Text(confirm.text)
                                    .font(.typography(.bodyMedium))
                                    .foregroundColor(.textBrandPrimary)
                                    .padding(.horizontal, ViewSpacing.medium)
                                    .padding(.vertical, ViewSpacing.small)
                                    .background(Color.surfacePrimary)
                                    .cornerRadius(CornerRadius.full.value)
                            }
                            .padding(.top, ViewSpacing.large+ViewSpacing.xlarge+ViewSpacing.xxxxlarge)
                        }
                    }
                    Spacer()
                }
            }
        }
    }
}

struct EnvyQuestionStyleMirrorView_Previews: PreviewProvider {
    static let singleOptions: [MoodTreatmentAnswerOption] = [
        .init(key: "A",text: "工作/事业发展", next: nil, exclusive: false),
        .init(key: "B",text: "朋友/人际关系", next: nil, exclusive: false),
        .init(key: "c",text: "克服困难", next: nil, exclusive: false),
        .init(key: "D",text: "学业/专业技能提升", next: nil, exclusive: false),
        .init(key: "E",text: "情绪管理/心理成长", next: nil, exclusive: false),
        .init(key: "F",text: "独立生活能力", next: nil, exclusive: false),
        .init(key: "G",text: "兴趣爱好", next: nil, exclusive: false),
        .init(key: "H",text: "运动/健康习惯", next: nil, exclusive: false),
        .init(key: "I",text: "帮助过他人", next: nil, exclusive: false),
        .init(key: "J",text: "其他", next: nil, exclusive: false),
        .init(key: "K",text: "我选好了", next: nil, exclusive: true),
    ]
    static let anyMultiOptions: [MoodTreatmentAnswerOption] = [
        .init(key: "A",text: "锻炼", next: nil, exclusive: false),
        .init(key: "B",text: "阅读", next: nil, exclusive: false),
        .init(key: "C",text: "考证", next: nil, exclusive: false),
        .init(key: "D",text: "新的语言", next: nil, exclusive: false),
        .init(key: "E",text: "按时睡觉", next: nil, exclusive: false),
        .init(key: "F",text: "健康饮食", next: nil, exclusive: false),
        .init(key: "G",text: "时间管理", next: nil, exclusive: false),
        .init(key: "H",text: "改善关系", next: nil, exclusive: false),
        .init(key: "I",text: "我选好了", next: nil, exclusive: true),
    ]
    static let threeMultiOptions: [MoodTreatmentAnswerOption] = [
        .init(key: "A",text: "我生活在没有战乱的国家", next: nil, exclusive: false),
        .init(key: "B",text: "健康的身体", next: nil, exclusive: false),
        .init(key: "C",text: "支持的家人和朋友", next: nil, exclusive: false),
        .init(key: "D",text: "工作的机会", next: nil, exclusive: false),
        .init(key: "E",text: "大自然", next: nil, exclusive: false),
        .init(key: "F",text: "每天的三餐", next: nil, exclusive: false),
        .init(key: "G",text: "安全的住所", next: nil, exclusive: false),
        .init(key: "H",text: "小小的日常", next: nil, exclusive: false),
        .init(key: "I",text: "学习和成长的机会", next: nil, exclusive: false),
        .init(key: "J",text: "我选好了", next: nil, exclusive: true),
    ]

    static var previews: some View {
            EnvyQuestionStyleMirrorView(
                question: .init(
                    id: 1,
                    totalQuestions: 100,
                    type: .singleChoice,
                    uiStyle: .styleMirror,
                    texts: ["当你感到嫉妒时，你内心相信自己也能够实现类似的成就。现在，请选择你觉得自己擅长或已取得成就的方面吧！"],
                    animation: nil,
                    options: singleOptions,
                    introTexts: nil,
                    showSlider: nil,
                    endingStyle: nil,
                    routine: "envy"
                )
            ) { _ in
            }
            .previewDisplayName("单选")

            EnvyQuestionStyleMirrorView(
                question: .init(
                    id: 2,
                    totalQuestions: 100,
                    type: .multiChoice,
                    uiStyle: .styleMirror,
                    texts: ["有哪些个人成长的目标是你可以通过自己的努力实现的？"],
                    animation: nil,
                    options: anyMultiOptions,
                    introTexts: nil,
                    showSlider: nil,
                    endingStyle: nil,
                    routine: "envy"
                ),
                requiredSelections: 1
            ) { _ in }
            .previewDisplayName("多选（任意1）")

            EnvyQuestionStyleMirrorView(
                question: .init(
                    id: 3,
                    totalQuestions: 100,
                    type: .multiChoice,
                    uiStyle: .styleMirror,
                    texts: ["选出三件你现在生活中感到感激的事物："],
                    animation: nil,
                    options: threeMultiOptions,
                    introTexts: nil,
                    showSlider: nil,
                    endingStyle: nil,
                    routine: "envy"
                ),
                requiredSelections: 3
            ) { _ in }
            .previewDisplayName("多选（必选3）")
    }
}
