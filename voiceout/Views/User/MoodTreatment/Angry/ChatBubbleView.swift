//
//  ChatBubbleView.swift
//  voiceout
//
//  Created by Yujia Yang on 6/19/25.
//

import SwiftUI

struct ChatBubbleView: View {
    let text: String
    static let width: CGFloat = 268

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 4, x: 2, y: 2)
                .frame(width: Self.width)

            Text(text)
                .font(Font.typography(.bodyMedium))
                .foregroundColor(.grey500)
                .padding(.horizontal, 12)
                .padding(.vertical, 16)
                .frame(width: Self.width, alignment: .leading)

            Image("vector49")
                .resizable()
                .frame(width: 15, height: 14)
                .offset(x: 24, y: 14)
        }
    }
}

struct BubbleScrollView: View {
    let texts: [String]
    @Binding var displayedCount: Int
    @Binding var bubbleHeight: CGFloat
    let bubbleSpacing: CGFloat
    let totalHeight: CGFloat

    private let animationDuration: TimeInterval = 0.25

    var body: some View {
        ScrollViewReader { reader in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: bubbleSpacing) {
                    ForEach(Array(texts.prefix(displayedCount).enumerated()), id: \.offset) { idx, line in
                        HStack {
                            ChatBubbleView(text: line)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .background(
                            GeometryReader { geo in
                                Color.clear
                                    .preference(key: BubbleHeightKey.self, value: geo.size.height)
                            }
                        )
                        .id(idx)
                    }
                }
                .frame(height: totalHeight, alignment: .bottom)
                .onPreferenceChange(BubbleHeightKey.self) { bubbleHeight = $0 }
            }
            .frame(height: totalHeight + 14)
            .onAppear {
                scrollToLast(with: reader)
            }
            .onChange(of: displayedCount) { _ in
                withAnimation(.easeInOut(duration: animationDuration)) {
                    scrollToLast(with: reader)
                }
            }
        }
    }

    private func scrollToLast(with reader: ScrollViewProxy) {
        let lastIndex = max(0, displayedCount - 1)
        reader.scrollTo(lastIndex, anchor: .bottom)
    }

    private struct BubbleHeightKey: PreferenceKey {
        static var defaultValue: CGFloat = 0
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = max(value, nextValue())
        }
    }
}

//#Preview {
//  ChatBubbleView(text: "如果你现在感到愤怒，可以告诉我身体是否出现了下列这些变化吗？（多选）")
//}

#Preview {
  BubbleScrollView(
    texts: ["第一条消息", "第二条消息", "第三条消息", "第四条消息"],
    displayedCount: .constant(3),
    bubbleHeight: .constant(80),
    bubbleSpacing: 24,
    //maxVisible: 3,
    totalHeight: 800
  )
  .background(Color.gray.opacity(0.2))
}
