//
//  WordToVisitorView.swift
//  voiceout
//
//  Created by Jiaqi Chen on 10/22/24.
//

import Foundation
import SwiftUI

struct WordToVisitorView: View {
    var showEditButton: Bool

    var body: some View {
        ProfileCardView(
            title: LocalizedStringKey("word_to_visitor_title"),
            showEditButton: showEditButton
        ) {
            Text("作为您的心理咨询师，我想让您知道这里是一个完全属于您的空间，您可以探索自己所承载的任何思想和情感。重要的是要记住，您所感受到的一切都是有效的，没有“正确”或“错误”的感受方式。我们可以一起审视这些感受，了解它们的来源，以及它们可能对您的需求和欲望表达了什么。我的角色是支持您，必要时提供不同的视角，并帮助您发现自己的力量和智慧。在这个旅程中，您并不孤单；我在这里与您同行，帮助您应对自己的经历。")
            .foregroundColor(.textSecondary)
            .font(Font.typography(.bodySmall))
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
    }
}

struct WordToVisitorView_Previews: PreviewProvider {
    static var previews: some View {
        WordToVisitorView(showEditButton: true)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
