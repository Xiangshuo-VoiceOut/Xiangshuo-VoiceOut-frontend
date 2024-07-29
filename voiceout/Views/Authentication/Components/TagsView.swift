//
//  TagsView.swift
//  voiceout
//
//  Created by J. Wu on 7/30/24.
//

import SwiftUI

struct TagsView: View {
    @StateObject var viewModel: TagsViewModel
    
    init(tags: [Tag]) {
        _viewModel = StateObject(wrappedValue: TagsViewModel(tags: tags))
    }
    var body: some View {
        VStack(alignment: .leading) {
            ForEach (viewModel.rows, id:\.self) { row in
//                HStack(spacing: ViewSpacing.medium) {
                HStack{
                    ForEach(row) {tag in
                        BadgeView(text: tag.name)
                            .padding(.leading, ViewSpacing.medium)
                    }
                }
                
            }
            .padding(.top,ViewSpacing.xsmall)
        }
    }
}

#Preview {
    TagsView(tags: Tag.targetFields)
}
