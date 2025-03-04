//
//  ExitAppointmentView.swift
//  voiceout
//
//  Created by Yujia Yang on 2/9/25.
//

import SwiftUI

struct ExitAppointmentView: View {
    var didCancel: () -> Void
    var didConfirm: () -> Void

    var body: some View {
        VStack(alignment: .center, spacing: ViewSpacing.medium) {
            Text(LocalizedStringKey("exit_appointment_title"))
                .font(Font.typography(.bodyLargeEmphasis))
                .multilineTextAlignment(.center)
                .foregroundColor(.grey500)
                .frame(maxWidth: .infinity, alignment: .top)

            Text(LocalizedStringKey("exit_appointment_message"))
                .font(Font.typography(.bodyMedium))
                .multilineTextAlignment(.center)
                .foregroundColor(.grey500)
                .frame(maxWidth: .infinity, alignment: .top)

            HStack(alignment: .center, spacing: ViewSpacing.medium) {
                ButtonView(
                    text: "cancel",
                    action: didCancel,
                    variant: .outline,
                    theme: .base,
                    fontSize: .medium,
                    borderRadius: .full,
                    maxWidth: .infinity
                )

                ButtonView(
                    text: "confirm",
                    action: didConfirm,
                    variant: .solid,
                    theme: .action,
                    fontSize: .medium,
                    borderRadius: .full,
                    maxWidth: .infinity
                )
            }
        }
        .padding(ViewSpacing.large)
        .frame(width: 342,alignment: .center)
        .background(Color.surfacePrimary)
        .cornerRadius(CornerRadius.medium.value)
    }
}

struct ExitAppointmentView_Previews: PreviewProvider {
    static var previews: some View {
        ExitAppointmentView(didCancel: {}, didConfirm: {})
            .previewLayout(.sizeThatFits)
    }
}
