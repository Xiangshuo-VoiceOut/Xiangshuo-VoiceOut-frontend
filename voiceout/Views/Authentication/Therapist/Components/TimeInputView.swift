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
    var onValidate: () -> Void
    var showRemoveButton: Bool? = false
    @ObservedObject var timeInput: TimeInputData

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center) {
                Text(LocalizedStringKey(label))
                    .foregroundColor(.textPrimary)
                    .font(.typography(.bodyMedium))
                    .frame(minWidth: 32)

                TextField(
                    LocalizedStringKey(""),
                    text: $timeInput.timeRangeLabel
                )
                .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, ViewSpacing.small)
                .padding(.horizontal, ViewSpacing.medium)
                .background(.white)
                .cornerRadius(CornerRadius.medium.value)
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.medium.value)
                        .stroke(
                            .width100,
                            timeInput.isValidTimeRange ? .clear : .borderInValid
                        )
                )
                .onChange(of: timeInput.timeRangeLabel) {
                    onValidate()
                }
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

            if !timeInput.isValidTimeRange {
                Text(LocalizedStringKey("invalid_time_range"))
                    .foregroundColor(.textInvalid)
                    .font(.typography(.bodyXXSmall))
                    .padding(.top, ViewSpacing.xsmall)
                    .padding(.leading, ViewSpacing.xlarge + ViewSpacing.small)
            } else {
                Text(" ")
                    .font(.typography(.bodyXXSmall))
                    .opacity(0)
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
        onValidate: {},
        timeInput: TimeInputData()
    )
    .environmentObject(PopupViewModel())
}
