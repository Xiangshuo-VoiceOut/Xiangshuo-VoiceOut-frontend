//
//  TimeInputView.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 9/19/24.
//

import SwiftUI

struct TimeInputView: View {
    @EnvironmentObject var popupViewModel: PopupViewModel
    var label: String
    var addAction: () -> Void
    var removeAction: () -> Void
    var showRemoveButton: Bool? = false
    @ObservedObject var timeInput: TimeInputData

    var body: some View {
        HStack(alignment: .center) {
            Text(LocalizedStringKey(label))
                .foregroundColor(.textPrimary)
                .font(.typography(.bodyMedium))
                .frame(minWidth: 32)

            Text("\(timeInput.selectedStartTime) \(timeInput.selectedStartAmPm) - \(timeInput.selectedEndTime) \(timeInput.selectedEndAmPm)")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, ViewSpacing.small)
                .padding(.horizontal, ViewSpacing.medium)
                .background(.white)
                .cornerRadius(CornerRadius.medium.value)
                .onTapGesture {
                    openTimePickerPopup()
                }

            Button(action: addAction) {
                Image("add-round")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.textPrimary)
            }

            if showRemoveButton != false {
                Button(action: removeAction) {
                    Image("delete")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.textPrimary)
                }
            } else {
                Rectangle()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.clear)
            }
        }
    }

    func openTimePickerPopup() {
        withAnimation(.spring()) {
            popupViewModel.present(
                with: .init(
                    content: AnyView(
                        TimePickerPopupContent(timeInput: timeInput)
                    ),
                    hideCloseButton: true
                )
            )
        }
    }
}

#Preview {
    TimeInputView(
        label: "时间",
        addAction: {},
        removeAction: {},
        timeInput: TimeInputData()
    )
    .environmentObject(PopupViewModel())
}
