//
//  ConsultationReservationView.swift
//  voiceout
//
//  Created by Yujia Yang on 11/23/24.
//

import SwiftUI

struct ConsultationReservationView: View {
    @StateObject var viewModel: TherapistProfilePageService
    @EnvironmentObject var router: RouterModel
    @Binding var selectedDate: Date?
    @Binding var selectedTimeSlot: Slot?
    var clinicianId: String

    @State private var isNavigatingToConfirmation: Bool = false

    init(clinicianId: String, selectedDate: Binding<Date?>, selectedTimeSlot: Binding<Slot?>) {
        self.clinicianId = clinicianId
        _viewModel = StateObject(wrappedValue: TherapistProfilePageService(clinicianId: clinicianId))
        _selectedDate = selectedDate
        _selectedTimeSlot = selectedTimeSlot
    }

    var body: some View {
        ScrollView {
            VStack(spacing: ViewSpacing.medium) {
                TherapistScheduleCalendarView(viewModel: viewModel, selectedTimeSlot: $selectedTimeSlot, selectedDate: $selectedDate)
                    .frame(maxWidth: .infinity)

                if let date = selectedDate {
                    TherapistScheduleTimeView(viewModel: viewModel, selectedTimeSlot: $selectedTimeSlot, selectedDate: date)
                        .frame(maxWidth: .infinity)
                }

                Rectangle()
                    .foregroundColor(.clear)
                    .frame(height: 2)
                    .background(Color.surfacePrimaryGrey)

                reservationInstructions

                Spacer()

                ButtonView(
                    text: "book_now",
                    action: {
                        if let date = selectedDate, let timeSlot = selectedTimeSlot {
                            router.navigateTo(.waitingConfirmation(date: date, timeSlot: timeSlot, clinicianId: clinicianId))
                        }
                    },
                    variant: .solid,
                    theme: isAppointmentReady ? .action : .bagdeInactive,
                    fontSize: .medium,
                    borderRadius: .full,
                    maxWidth: .infinity
                )
                .disabled(!isAppointmentReady)
            }
            .padding(.horizontal, ViewSpacing.large)
            .padding(.bottom, ViewSpacing.medium)
        }
    }

    private var reservationInstructions: some View {
        VStack(alignment: .center, spacing: ViewSpacing.medium) {
            Text(LocalizedStringKey("reservation_notice"))
                .font(Font.typography(.bodyLargeEmphasis))
                .multilineTextAlignment(.center)
                .foregroundColor(.textTitle)
                .frame(alignment: .top)

            Group {
                Text(LocalizedStringKey("reservation_instructions"))
                    .font(Font.typography(.bodyMedium))
                    .foregroundColor(.textPrimary) +
                Text(LocalizedStringKey("faq"))
                    .font(Font.typography(.bodyMedium))
                    .foregroundColor(.textBrandSecondary)
            }
            .padding(.horizontal, 4 * ViewSpacing.betweenSmallAndBase)
        }
    }

    private var isAppointmentReady: Bool {
        selectedDate != nil && selectedTimeSlot != nil
    }
}

#Preview {
    ConsultationReservationView(
        clinicianId: "test_clinician_id",
        selectedDate: .constant(nil),
        selectedTimeSlot: .constant(nil)
    )
}
