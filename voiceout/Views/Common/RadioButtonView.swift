//
//  RadioButtonView.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 5/7/24.
//

import Foundation
import SwiftUI

struct RadioButtonView: View {
    @Binding private var isSelected: Bool
    private let labelView: AnyView
    private var isDisabled: Bool = false

    init(isSelected: Binding<Bool>, labelView: AnyView = AnyView(Text(""))) {
        self._isSelected = isSelected
        self.labelView = labelView
    }

    init<V: Hashable>(
        tag: V,
        selection: Binding<V?>,
        labelView: AnyView = AnyView(Text(""))
    ) {
        self._isSelected = Binding(
            get: { selection.wrappedValue == tag },
            set: { _ in selection.wrappedValue = tag }
        )
        self.labelView = labelView
    }

    var body: some View {
        HStack {
            circleView
                .contentShape(Rectangle())
                .onTapGesture {
                    isSelected = !isSelected
                }
                .disabled(isDisabled)
            labelView
        }
    }
}

private extension RadioButtonView {
    @ViewBuilder var circleView: some View {
        Circle()
            .fill(innerCircleColor)
            .animation(.easeInOut(duration: 0.15), value: isSelected)
            .padding(ViewSpacing.xxsmall)
            .overlay(
                Circle()
                    .stroke(outlineColor, lineWidth: 1)
            )
            .frame(width: 14, height: 14)
    }

    var innerCircleColor: Color {
        guard isSelected else { return .surfacePrimary }
        if isDisabled { return .borderLight }
        return .borderBrandPrimary
    }

    var outlineColor: Color {
        if isDisabled { return .borderLight }
        return isSelected ? .borderBrandPrimary : .borderLight
    }

    func disabled(_ value: Bool) -> Self {
        var view = self
        view.isDisabled = value
        return view
    }
}

struct RadioButtonView_Previews: PreviewProvider {
    static var previews: some View {
        RadioButtonView(isSelected: .constant(false), labelView: AnyView(Text("123")))
    }
}
