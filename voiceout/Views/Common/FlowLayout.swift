////
////  FlowLayout.swift
////  voiceout
////
////  Created by J. Wu on 7/23/24.
////
//
//import SwiftUI
//
//struct FlowLayout<T, V: View>: View {
//    let items: [T]
//    let viewForItem: (T) -> V
//    
//    init(items: [T], viewForItem: @escaping (T) -> V) {
//        self.items = items
//        self.viewForItem = viewForItem
//    }
//    
//    var body: some View {
//        GeometryReader { geometry in
//            self.generateContent(in: geometry)
//        }
//    }
//    
//    private func generateContent(in g: GeometryProxy) -> some View {
//        var width = CGFloat.zero
//        var height = CGFloat.zero
//        var lastHeight = CGFloat.zero
//        
//        return ZStack(alignment: .topLeading) {
//            ForEach(self.items, id: \.self) { item in
//                self.viewForItem(item)
//                    .padding([.horizontal, .vertical], 4)
//                    .alignmentGuide(.leading, computeValue: { d in
//                        if (abs(width - d.width) > g.size.width) {
//                            width = 0
//                            height -= lastHeight
//                        }
//                        let result = width
//                        if item == self.items.last! {
//                            width = 0 // last item
//                        } else {
//                            width -= d.width
//                        }
//                        return result
//                    })
//                    .alignmentGuide(.top, computeValue: { d in
//                        let result = height
//                        lastHeight = d.height
//                        return result
//                    })
//            }
//        }
//    }
//}
//
////#Preview {
////    FlowLayout<Any, <#Content: View#>>()
////}
