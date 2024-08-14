//
//  SegmentPicker.swift
//  voiceout
//
//  Created by J. Wu on 8/13/24.
//

import SwiftUI

enum TimeType: String, Hashable{
    case start = "start_time"
    case end = "end_time"
}

struct SegmentPicker<T: Hashable>: View {
    @Binding var selectedSegment: T
    let segments: [T]
    let segmentLabels: (T) -> String
    
    var body: some View {

        ZStack {
    
            HStack(spacing: ViewSpacing.base){
                    
                    ForEach(segments, id: \.self) { segment in
                        Text(LocalizedStringKey(segmentLabels(segment)))
                            .padding(.vertical, ViewSpacing.base)
                            .padding(.horizontal, ViewSpacing.medium)
                            .foregroundColor(selectedSegment == segment ? .textInvert : .textPrimary)
                            .bold(selectedSegment == segment)
                            .font(.typography(.bodyMedium))
                            .background{
                                ZStack {
                                        
                                    if selectedSegment == segment {
                                        Capsule()
                                            .foregroundColor(Color.brandPrimary)
                                    }
                                }
                                .animation(.bouncy, value: selectedSegment)
                            }
                    }
                        
            }
            .background(
                RoundedRectangle(cornerRadius: CornerRadius.large.value)
                            .fill(Color.brandPrimary.opacity(0.2))
            )
            
        }
            }

    
}


struct SegmentPicker_Previews: PreviewProvider {
    @State static var selectedSegment: TimeType = .end

    static var previews: some View {
        SegmentPicker(
            selectedSegment: $selectedSegment,
            segments: [.start, .end],
            segmentLabels: { $0.rawValue }
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
