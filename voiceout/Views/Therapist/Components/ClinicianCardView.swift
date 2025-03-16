//
//  ClinicianCardView.swift
//  Therapist Card
//
//  Created by Yujia Yang on 7/5/24.
//

import SwiftUI

struct ClinicianCardView: View {
    var clinician: Clinician
    
    var body: some View {
        CardView(content: {
            VStack {
                HStack(alignment: .top, spacing: ViewSpacing.xsmall) {
                    VStack(alignment: .center, spacing: -ViewSpacing.small) {
                        AsyncImage(url: URL(string: clinician.profilePicture ?? "")) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 56, height: 56)
                                    .clipShape(Circle())
                            default:
                                Color.gray.frame(width: 56, height: 56)
                                Text("Unable to load image").foregroundColor(.red)
                            }
                        }
                        .frame(width: 56, height: 56)
                        HStack(alignment: .center, spacing: 0) {
                            HStack(alignment: .center, spacing: 0) {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 12, height: 12)
                                    .background(
                                        Image("lightning")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 12, height: 12)
                                            .clipped()
                                    )
                                Text("今天可约")
                                    .font(Font.typography(.bodyXSmallEmphasis))
                                    .kerning(0.36)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.textInvert)
                                    .frame(width: 49, height: 18, alignment: .top)
                            }
                            .padding(.trailing, ViewSpacing.xxsmall)
                            .frame(height: 18, alignment: .center)
                            .cornerRadius(CornerRadius.xxxsmall.value)
                        }
                        .padding(.trailing, ViewSpacing.xsmall)
                        .frame(maxWidth: .infinity, minHeight: 18, maxHeight: 18, alignment: .leading)
                        .background(Color.surfaceSecondary)
                        .cornerRadius(CornerRadius.xsmall.value)
                    }
                    .frame(width: 67, alignment: .top)
                    .cornerRadius(CornerRadius.xxxsmall.value)
                    
                    VStack(alignment: .leading, spacing: ViewSpacing.xsmall) {
                        HStack(alignment: .top) {
                            Text(clinician.name)
                                .font(Font.typography(.bodyLargeEmphasis))
                                .foregroundColor(.textTitle)
                            Spacer()
                            Text(priceText)
                                .font(Font.typography(.bodyMedium))
                                .multilineTextAlignment(.trailing)
                                .foregroundColor(.textBrandSecondary)
                                .frame(width: 63, height: 25, alignment: .topTrailing)
                        }
                        .frame(height: 25, alignment: .top)
                        
                        Text(experienceText)
                            .font(Font.typography(.bodySmall))
                            .foregroundColor(.textPrimary)
                            .frame(height: 16, alignment: .leading)
                        
                        clinicianTagsSection
                        
                        Text(clinician.certificationType ?? "未提供认证")
                            .font(Font.typography(.bodySmall))
                            .foregroundColor(.textPrimary)
                            .frame(height: 40, alignment: .topLeading)
                    }
                    .frame(maxWidth: .infinity, minHeight: 115, maxHeight: 115, alignment: .topLeading)
                }
                .padding(.leading, ViewSpacing.betweenSmallAndBase)
                .padding(.trailing, ViewSpacing.medium)
                .padding(.vertical, ViewSpacing.medium)
                .background(Color.surfacePrimary)
                .cornerRadius(CornerRadius.medium.value)
            }
        }, modifiers: CardModifiers(
            padding: EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0),
            backgroundColor: Color.grey50,
            cornerRadius: CornerRadius.medium.value,
            shadow1Color: Color(red: 0.36, green: 0.36, blue: 0.47).opacity(0.03),
            shadow1Radius: 8.95,
            shadow1X: 5,
            shadow1Y: 3,
            shadow2Color: Color(red: 0.15, green: 0.15, blue: 0.25).opacity(0.08),
            shadow2Radius: 5.75,
            shadow2X: 2,
            shadow2Y: 4
        ))
        .frame(height: 147)
        .background(Color.clear)
    }
    
    private var priceText: String {
        return String(format: NSLocalizedString("charge_per_session", comment: ""), "\(clinician.charge)")
    }
    
    private var experienceText: String {
        return String(format: NSLocalizedString("years_of_experience", comment: ""), "\(clinician.yearOfExperience)")
    }
    
    private var clinicianTagsSection: some View {
        let displayedTags = Array(clinician.consultField.prefix(3))
        return HStack(alignment: .center, spacing: ViewSpacing.small) {
            ForEach(displayedTags, id: \.tag) { tag in
                Text(tag.tag)
                    .font(Font.typography(.bodyXSmall))
                    .kerning(0.24)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.textTitle)
                    .frame(height: 18, alignment: .top)
                    .padding(.horizontal, ViewSpacing.small)
                    .padding(.vertical, 0)
                    .background(Color.surfaceBrandPrimary.opacity(0.4)
                        .cornerRadius(CornerRadius.xsmall.value)
                    )}
        }
    }
}

#Preview {
    ClinicianCardView(clinician: Clinician(
        _id: "1",
        name: "董国友",
        certification: [
            Certification(
                certificationType: "国家一级",
                certificationLocation: "北京",
                certificationID: "43872",
                certificationExpiration: "2025-08-20T00:00:00.000Z",
                certificationPhoto: "examplePhotoID"
            )
        ],
        charge: 200,
        consultField: [Tag(tag: "人际关系"), Tag(tag: "焦虑抑郁")],
        yearOfExperience: 13,
        profilePicture: "https://example.com/image.jpg",
        ratingCount: 10
    ))
}
