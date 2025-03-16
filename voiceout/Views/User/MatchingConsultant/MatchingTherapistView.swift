//
//  MatchingTherapistView.swift
//  voiceout
//
//  Created by Yujia Yang on 3/3/25.
//

import SwiftUI

struct MatchingTherapistView: View {
    @EnvironmentObject var router: RouterModel
    @State private var clinicians: [Clinician] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        ZStack {
            Color.surfacePrimaryGrey2.edgesIgnoringSafeArea(.all)

            VStack(spacing: ViewSpacing.medium) {
                VStack(spacing: ViewSpacing.large) {
                    HStack(alignment: .center) {
                        Image("cloud2")
                            .frame(width: 166, height: 96)

                        Spacer()

                        Text("以下是根据问卷帮您匹配到的咨询师")
                            .font(.typography(.bodyMedium))
                            .foregroundColor(.grey300)
                            .padding(ViewSpacing.medium)
                            .background(Color.surfacePrimary)
                            .cornerRadius(CornerRadius.medium.value)
                    }
                }
                .padding(.horizontal, ViewSpacing.medium)

                if isLoading {
                    ProgressView("加载中...")
                        .padding()
                } else if let errorMessage = errorMessage {
                    Text("加载失败: \(errorMessage)")
                        .foregroundColor(.red)
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: ViewSpacing.medium) {
                            ForEach(clinicians, id: \._id) { therapist in
                                VStack(alignment: .center, spacing: ViewSpacing.betweenSmallAndBase) {
                                    HStack(alignment: .center) {
                                        Text("80%匹配度")
                                            .font(Font.typography(.bodyMedium))
                                            .foregroundColor(.textTitle)

                                        Spacer()

                                        VStack(alignment: .leading, spacing: ViewSpacing.betweenSmallAndBase) {
                                            Rectangle()
                                                .foregroundColor(.clear)
                                                .frame(width: 132, height: 4)
                                                .background(Color.surfaceBrandPrimary)
                                                .cornerRadius(CornerRadius.full.value)
                                        }
                                        .frame(width: 240, height: 4, alignment: .topLeading)
                                        .background(Color.surfacePrimaryGrey)
                                        .cornerRadius(CornerRadius.full.value)
                                    }
                                    .padding(.horizontal, ViewSpacing.medium)
                                    .background(Color.surfaceBrandTertiaryGreen)

                                    HStack(alignment: .center) {
                                        ClinicianCardView(clinician: therapist)
                                    }
                                    .padding(.horizontal, -ViewSpacing.medium)
                                }
                                .padding(.top, ViewSpacing.betweenSmallAndBase)
                                .frame(alignment: .bottom)
                                .background(Color.brandTertiaryGreen)
                                .cornerRadius(CornerRadius.medium.value)
                            }
                        }
                        .frame(alignment: .topLeading)
                    }
                    .padding(.horizontal, ViewSpacing.medium)
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .onAppear {
            MatchingConsultantService.fetchRecommendedClinicians(userId: "66750b14449d353570036534") { result in
                DispatchQueue.main.async {
                    if let clinicians = result {
                        self.clinicians = clinicians
                    } else {
                        self.errorMessage = "Unable to load the matching consultant"
                    }
                    self.isLoading = false
                }
            }
        }
    }
}

#Preview {
    MatchingTherapistView()
        .environmentObject(RouterModel())
}
