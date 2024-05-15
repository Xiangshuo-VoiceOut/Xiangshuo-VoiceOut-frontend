//
//  RadioButton.swift
//  voiceout
//
//  Created by J. Wu on 5/15/24.
//

import SwiftUI

struct RadioButton: View {
    @Binding private var isSelected: Bool
    
    init(isSelected: Binding<Bool>) {
        self._isSelected = isSelected
    }
    var body: some View {
        Circle()
            .fill(innerCircleColor)
            .padding(4)
            .overlay(
                Circle()
                    .stroke(outlineColor, lineWidth: 1)
            )
            .frame(width: 18, height: 18)
    }
    
    private var innerCircleColor: Color {
        return isSelected ? Color(.brandPrimary) : Color(.clear)
    }
    
    private var outlineColor: Color {
        return isSelected ? Color(.brandPrimary) : Color(.borderLight)
    }
    
}

#Preview {
    Group{
        RadioButton(isSelected: .constant(true))
        RadioButton(isSelected: .constant(false))
    }
    
}
