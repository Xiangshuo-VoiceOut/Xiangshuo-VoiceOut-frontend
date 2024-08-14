//
//  TimePickerPopoverView.swift
//  voiceout
//
//  Created by J. Wu on 8/13/24.
//

import SwiftUI

struct TimePickerPopoverView: View {
    @Binding var startTime: Date
    @Binding var endTime: Date
    @State private var selectedTimeType: TimeType = .start
    
    var body: some View {
        VStack {
            SegmentPicker(
                selectedSegment: $selectedTimeType,
                segments: [.start, .end],
                segmentLabels: { $0.rawValue }
            )
            .padding()

            DatePicker(
                "",
                selection: selectedTimeType == .start ? $startTime : $endTime,
                displayedComponents: [.hourAndMinute]
            )
            .datePickerStyle(WheelDatePickerStyle())
            .labelsHidden()
            .environment(\.locale, Locale(identifier: "en_US"))

            HStack {
                
                ButtonView(text: "cancel", 
                           action: {},
                           variant: .outline
                )
                .padding()
                
                ButtonView(text: "confirmation",
                           action: {},
                           theme: selectedTimeType == .start ? .base : .action,
                           spacing: .medium
                )
            }
            .padding(.horizontal)
        }
        
    }
}


struct TimePickerPopoverView_Previews: PreviewProvider {
    @State static var startTime: Date = Date()
    @State static var endTime: Date = Date().addingTimeInterval(3600)

    static var previews: some View {
        TimePickerPopoverView(startTime: $startTime, endTime: $endTime)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
