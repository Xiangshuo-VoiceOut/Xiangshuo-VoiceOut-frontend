//
//  TimePickerView.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 9/23/24.
//

import SwiftUI

struct TimePickerView: View {
    @Binding var hour: Int
    @Binding var amPm: String
    var amPmList = ["AM", "PM"]

    var body: some View {
        HStack(spacing: 0) {
            PickerViewWithoutIndicator(selection: $hour) {
                ForEach(0...12, id: \.self) { value in
                    Text("\(value)")
                        .tag(value)
                }
            }

            PickerViewWithoutIndicator(selection: $amPm) {
                ForEach(amPmList, id: \.self) { value in
                    Text("\(value)")
                        .tag(value)
                }
            }
        }
        .background {
            RoundedRectangle(cornerRadius: CornerRadius.small)
                .fill(.ultraThinMaterial)
                .frame(height: 35)
        }
    }
}

struct PickerViewWithoutIndicator<Content: View, Selection: Hashable>: View {
    @Binding var selection: Selection
    @ViewBuilder var content: Content
    @State private var isHidden: Bool = false

    var body: some View {
        Picker("", selection: $selection) {
            if !isHidden {
                RemovePickerIndicator {
                    isHidden = true
                }
            }

            content
        }
        .pickerStyle(.wheel)
    }
}

private
struct RemovePickerIndicator: UIViewRepresentable {
    var result: () -> Void
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        DispatchQueue.main.async {
            if let pickerView = view.pickerView {
                if pickerView.subviews.count >= 2 {
                    pickerView.subviews[1].backgroundColor = .clear
                }
                result()
            }
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) { }
}

fileprivate
extension UIView {
    var pickerView: UIPickerView? {
        if let view = superview as? UIPickerView {
            return view
        }

        return superview?.pickerView
    }
}

#Preview {
    TimePickerView(hour: .constant(1), amPm: .constant("AM"))
}
