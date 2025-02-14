//
//  WaitingConfirmationView.swift
//  voiceout
//
//  Created by Yujia Yang on 11/24/24.
//

import SwiftUI

struct WaitingConfirmationView: View {
    @EnvironmentObject var router: RouterModel
    @State private var userMessage: String = ""
    @StateObject private var popupViewModel = PopupViewModel()

    var selectedDate: Date
    var selectedTimeSlot: Slot
    var consultantId: String
    
    @State private var clinicianProfile: ClinicianProfilePageInformation?

    var body: some View {
        ZStack(alignment: .top) {
            Color.surfacePrimaryGrey2
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                StickyHeaderView(
                    title: "order_confirmation",
                    leadingComponent: AnyView(
                        BackButtonView(action: {
                            showExitPopup()
                        })
                    ),
                    trailingComponent: AnyView(
                        Button(action: {
                            print("Help button tapped")
                        }) {
                            Image("help")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.black)
                        }
                    )
                )
                .frame(height: 44)
                
                ScrollView {
                    VStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: CornerRadius.medium.value)
                                .fill(Color.surfacePrimary)
                            
                            HStack(alignment: .center, spacing: ViewSpacing.medium) {
                                HStack(alignment: .center, spacing: ViewSpacing.medium) {
                                    if let profile = clinicianProfile {
                                        AsyncImage(url: URL(string: profile.profilePicture)) { phase in
                                            switch phase {
                                            case .empty:
                                                ProgressView()
                                                    .frame(width: 48, height: 48)
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 48, height: 48)
                                                    .clipShape(Circle())
                                                    .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1))
                                            case .failure:
                                                Image(systemName: "person.circle.fill")
                                                    .resizable()
                                                    .frame(width: 48, height: 48)
                                                    .clipShape(Circle())
                                                    .foregroundColor(.gray)
                                            @unknown default:
                                                EmptyView()
                                            }
                                        }
                                        
                                        Text(profile.name)
                                            .font(Font.typography(.bodyLargeEmphasis))
                                            .foregroundColor(.black)
                                    } else {
                                        ProgressView()
                                            .frame(width: 48, height: 48)
                                        Text("Loading...")
                                            .font(Font.typography(.bodyLargeEmphasis))
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                }
                            }
                            .padding(.leading, ViewSpacing.medium)
                            .padding(.trailing, ViewSpacing.large)
                            .padding(.vertical, ViewSpacing.small)
                            .background(Color.surfacePrimary)
                            .cornerRadius(CornerRadius.medium.value)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, ViewSpacing.medium)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: CornerRadius.medium.value)
                                .fill(Color.surfacePrimary)
                            
                            VStack(alignment: .leading, spacing: ViewSpacing.medium) {
                                HStack(alignment: .top) {
                                    Text(LocalizedStringKey("video_call"))
                                        .font(Font.typography(.bodyLargeEmphasis))
                                        .foregroundColor(.textBrandSecondary)
                                }
                                HStack(alignment: .center, spacing: ViewSpacing.large) {
                                    Text(LocalizedStringKey("consultation_time"))
                                        .font(Font.typography(.bodySmall))
                                        .foregroundColor(.textPrimary)
                                    Text("\(selectedDate, formatter: dateFormatter) \(formatTimeRange(for: selectedTimeSlot))")
                                        .font(Font.typography(.bodySmall))
                                        .foregroundColor(.textPrimary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                                HStack(alignment: .center, spacing: ViewSpacing.large) {
                                    Text(LocalizedStringKey("order_price"))
                                        .font(Font.typography(.bodySmall))
                                        .foregroundColor(.textPrimary)
                                    Text(clinicianProfile != nil ? "$\(clinicianProfile!.charge)/次" : "$0.00")
                                        .font(Font.typography(.bodySmall))
                                        .foregroundColor(.textPrimary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                                HStack(alignment: .center, spacing: ViewSpacing.large) {
                                    Text(LocalizedStringKey("actual_payment"))
                                        .font(Font.typography(.bodySmall))
                                        .foregroundColor(.textPrimary)
                                    Text(clinicianProfile != nil ? "$\(clinicianProfile!.charge)" : "$0.00")
                                        .font(Font.typography(.bodyMedium))
                                        .foregroundColor(.textBrandSecondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                                HStack(alignment: .center, spacing: ViewSpacing.large) {
                                    Text(LocalizedStringKey("order_status"))
                                        .font(Font.typography(.bodySmall))
                                        .foregroundColor(.textPrimary)
                                    Text(LocalizedStringKey("pending_payment"))
                                        .font(Font.typography(.bodySmall))
                                        .foregroundColor(.textPrimary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.horizontal, ViewSpacing.medium)
                            .padding(.top, ViewSpacing.medium)
                            .padding(.bottom, ViewSpacing.large)
                            .frame(alignment: .topLeading)
                            .background(Color.surfacePrimary)
                            .cornerRadius(CornerRadius.medium.value)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, ViewSpacing.medium)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: CornerRadius.medium.value)
                                .fill(Color.surfacePrimary)
                            VStack(alignment: .leading, spacing: ViewSpacing.betweenSmallAndBase) {
                                HStack(alignment: .top, spacing: ViewSpacing.large) {
                                    Text(LocalizedStringKey("remark_information"))
                                        .font(Font.typography(.bodySmall))
                                        .foregroundColor(.textPrimary)
                                    TextField(LocalizedStringKey("remark_placeholder"), text: $userMessage)
                                        .font(Font.typography(.bodySmall))
                                        .foregroundColor(.textSecondary)
                                        .frame(alignment: .topLeading)
                                }
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                            }
                            .padding(.horizontal, ViewSpacing.medium)
                            .padding(.top, ViewSpacing.medium)
                            .padding(.bottom, ViewSpacing.large)
                            .frame(alignment: .topLeading)
                            .background(Color.surfacePrimary)
                            .cornerRadius(CornerRadius.medium.value)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, ViewSpacing.medium)
                    }
                    .padding(.vertical, ViewSpacing.xsmall)
                }
                
                ZStack {
                    Color.surfacePrimaryGrey2
                        .edgesIgnoringSafeArea(.all)
                    VStack(spacing: 0) {
                        ScrollView {
                            VStack {
                                Spacer()
                            }
                        }
                        ZStack {
                            Color.surfacePrimaryGrey2
                            Text(LocalizedStringKey("order_confirmation_message"))
                                .font(Font.typography(.bodySmall))
                                .foregroundColor(.textSecondary)
                                .frame(width: 245, alignment: .center)
                        }
                        .padding(.bottom, -ViewSpacing.large-ViewSpacing.xxlarge)
                        .frame(maxWidth: .infinity)
                        
                        HStack {
                            VStack(alignment: .leading, spacing: ViewSpacing.xxsmall) {
                                Text(clinicianProfile != nil ? "$\(clinicianProfile!.charge)/次" : "$0.00")
                                    .font(Font.typography(.bodyMediumEmphasis))
                                    .foregroundColor(.textBrandSecondary)
                                Text(LocalizedStringKey("one_online_consultation"))
                                    .font(Font.typography(.bodyXSmall))
                                    .foregroundColor(.textSecondary)
                            }
                            
                            Spacer()
                            
                            HStack(alignment: .center, spacing: ViewSpacing.betweenSmallAndBase) {
                                ButtonView(
                                    text: "confirm_order",
                                    action: {
                                    },
                                    variant: .solid,
                                    theme: .action,
                                    fontSize: .medium,
                                    borderRadius: .full,
                                    maxWidth: 204
                                )
                            }
                        }
                        .padding(.top, ViewSpacing.large)
                        .padding(.leading, ViewSpacing.xlarge)
                        .padding(.trailing, ViewSpacing.medium)
                        .background(Color.surfacePrimary)
                    }
                }
            }
            .zIndex(0)
            
            if case let .present(config) = popupViewModel.action {
                ZStack {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                    config.content
                }
                .zIndex(1)
            }
        }
        .onAppear {
            fetchProfileData(for: consultantId)
        }
    }

    private func showExitPopup() {
        let config = PopupViewModel.Config(
            content: AnyView(
                ExitAppointmentView(
                    didCancel: {
                        popupViewModel.dismiss()
                    },
                    didConfirm: {
                        router.popToRoot()
                    }
                )
            ),
            hideCloseButton: true
        )
        popupViewModel.present(with: config)
    }

    private func closePopup() {
        popupViewModel.dismiss()
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter
    }

    private func formatTimeRange(for slot: Slot) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return "\(formatter.string(from: slot.startTime)) - \(formatter.string(from: slot.endTime))"
    }


    private func fetchProfileData(for consultantId: String) {
        let urlString = "http://localhost:6500/api/doctors/\(consultantId)"
        guard let url = URL(string: urlString) else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                return
            }

            guard let data = data else {
                return
            }

            do {
                let profile = try JSONDecoder().decode(ClinicianProfilePageInformation.self, from: data)
                DispatchQueue.main.async {
                    self.clinicianProfile = profile
                }
            } catch {
            }
        }.resume()
    }
}

#Preview {
    WaitingConfirmationView(
        selectedDate: Date(),
        selectedTimeSlot: Slot(startTime: Date(), isAvailable: true),
        consultantId: "667ab297a0ada2dceea38f7f"
    )
    .environmentObject(RouterModel())
}
