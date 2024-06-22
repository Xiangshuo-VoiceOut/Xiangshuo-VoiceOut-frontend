//
//  DropdownView.swift
//  voiceout
//
//  Created by J. Wu on 6/17/24.
//

import SwiftUI

struct DropdownView: View {
    var prefixIcon: String? = nil
    let prompt: String
    let options: [String]
    
    @State private var isExpanded = false
    @Binding var selection: String?
    
    var body: some View {
        
            VStack{
                HStack {
                    if let icon = prefixIcon {
                        Image(icon)
                            .foregroundColor(.borderSecondary)
                    }
                    
                    Text(selection ?? prompt)
                        .foregroundColor(selection == nil ? Color.textSecondary : Color.textPrimary)
                        .font(.typography(.bodyMedium))
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(Color.grey500)
                        .padding(.horizontal,ViewSpacing.xsmall)
                        .padding(.vertical, ViewSpacing.small)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .padding(.horizontal, ViewSpacing.medium)
                .padding(.vertical, ViewSpacing.small)
                .onTapGesture {
                    withAnimation(.snappy) {isExpanded.toggle()}
                }
                if isExpanded {
                    VStack {
                        ForEach(options, id: \.self) { option in
                            HStack {
                                Text(option)
                                Spacer()
                                if selection == option {
                                    Image(systemName: "checkmark")
                                }
                            }
                            .padding(ViewSpacing.baseMedium)
                            .onTapGesture {
                                withAnimation(.snappy) {
                                    selection = option
                                    isExpanded.toggle()
                                }
                            }
                            
                        }
                    }
                    .transition(.move(edge: .bottom))

                }
            }
            .background(Color.surfacePrimaryGrey2)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium))
            .shadow(radius: ViewSpacing.base)
            .padding(ViewSpacing.small)
            
            
           
        
    }
}

#Preview {
    DropdownView(prefixIcon: "local", prompt: "请选择您的地区", options: ["NY", "CA","NJ"], selection: .constant("NY"))
}
