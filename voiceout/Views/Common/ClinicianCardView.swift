//
//  ContentView.swift
//  Therapist Card
//
//  Created by Yujia Yang on 7/5/24.
//

import SwiftUI
struct ClinicianCardView: View {
    @StateObject var viewModel = ClinicianViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                } else if let clinician = viewModel.clinician {
                    ClinicianDetailView(clinician: clinician)
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                } else {
                    Text("Unable to load clinician data")
                        .foregroundColor(.red)
                }
            }
            .onAppear {
                //viewModel.loadTestData()
                viewModel.fetchClinician()
            }
        }
    }
}




struct StarRatingView2: View{
    var rating: Double
    let maximumRating = 5
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<maximumRating, id: \.self) { index in
                ZStack(alignment: .leading) {
                    Image(systemName: "star")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.grey50)
                    
                    if rating > Double(index) {
                        Image(systemName: "star.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color(red: 0.98, green: 0.75, blue: 0.14))
                            .mask(
                                Rectangle()
                                    .size(width: min(CGFloat(rating - Double(index)) * 20, 20), height: 20)
                                    .alignmentGuide(.leading) { d in d[.leading] }
                            )
                    }
                }
            }
        }
    }
}

struct ClinicianDetailView: View {
    var clinician: Clinician
    var body: some View{
        //即刻可约
        VStack(alignment: .center, spacing: 0) {
            //4210
            VStack(alignment: .center,spacing:10) {
                //4583
                HStack(alignment: .center, spacing: ViewSpacing.large) {
                    
                    //4207
                    HStack(alignment: .center, spacing: 0) {
                        ZStack(alignment: .bottomLeading) {
                            // AsyncImage 在 ZStack 的底层
                            AsyncImage(url: URL(string: clinician.profilePicture.id)) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 67, height: 67)
                                        .clipShape(Circle())
   
                                default:
                                    Color.gray.frame(width: 67, height: 67)
                                    Text("Unable to load image").foregroundColor(.red)
                                }
                            }
                            .frame(width: 67, height: 67)

                            // 4208
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
                                  .cornerRadius(CornerRadius.xxxsmall.value)
                                
                                // "今天可约" 文字
                                Text("今天可约")
                                    .font(Font.typography(.bodyXSmall))
                                    .kerning(0.36)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color.textInvert)
                                    .frame(width: 53, height: 17)
                                    .background(Color.surfaceSecondary)
                            }
                            .padding(.horizontal, ViewSpacing.xsmall)
                            .padding(.vertical, ViewSpacing.xxxsmall)
                            .frame(width: 69, height: 17, alignment: .center)
                            .background(Color.surfaceSecondary)
                            .cornerRadius(CornerRadius.xsmall.value)
                        }
                        
                        .frame(width: 69, height: 67, alignment: .bottomLeading)
                        .cornerRadius(CornerRadius.xxxsmall.value)
                        
                    }
                        .padding(0)
                        .frame(width: 69, height: 67, alignment: .center)
                        .cornerRadius(CornerRadius.xxxsmall.value)

                    //4304
                    VStack(alignment: .leading, spacing: ViewSpacing.small) {
                        //4301
                        VStack(alignment: .leading, spacing:ViewSpacing.xsmall) {
                            //4206
                            HStack(alignment: .center, spacing: 0) {
                                //4300
                                HStack(alignment: .center, spacing: 0) {
                                Text(clinician.name)
                                    .font(Font.typography(.bodyLargeEmphasis))
                                    .foregroundColor(.black)
                            }
                            .padding(0)
                            .frame(width: 54, height: 25, alignment: .center)
                            .cornerRadius(CornerRadius.xxxsmall.value)
                        }
                            .padding(0)
                            .frame(width: 54, height: 25, alignment: .center)
                            .cornerRadius(CornerRadius.xxxsmall.value)
                            //4302
                            HStack(alignment: .center, spacing: 0) {
                                Text("从业经验：\(clinician.yearOfExperience)年")
                                  .font(Font.typography(.bodyXSmall))
                                  .kerning(0.36)
                                  .foregroundColor(Color.textBrandSecondary)
                            }
                            .padding(.leading, ViewSpacing.xxxsmall)
                            .padding(.vertical, 0)
                            .frame(height:12, alignment: .leading)
                            .cornerRadius(CornerRadius.xsmall.value)
                        }
                        .padding(0)
                        .frame(width:241,height:42,alignment: .topLeading)
                        .cornerRadius(CornerRadius.xxxsmall.value)
                        //4293
                        HStack(alignment: .center, spacing: ViewSpacing.medium) {
                            //4235
                            //4237
                            //4236
                            ForEach(clinician.consultField, id: \.tag) { tag in
                                    HStack(alignment: .center, spacing: 0) {
                                        Text(tag.tag)
                                            .font(Font.typography(.bodyXSmall))
                                            .kerning(0.36)
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Color.textInvert)
                                    }
                                }
                            .padding(.horizontal, 6)
                            .padding(.vertical, 1)
                            .background(Color(red: 0.58, green: 0.64, blue: 0.93))
                            .cornerRadius(CornerRadius.xsmall.value)
                            .frame(height:17)
                        }
                        .padding(0)
                        .frame(height:17, alignment: .leading)
                        .cornerRadius(CornerRadius.xxxsmall.value)
                    }
                    .padding(0)
                    .frame(width: 241, height: 67, alignment: .topLeading)
                    .cornerRadius(CornerRadius.xxxsmall.value)
                }
                .padding(0)
                .frame(width: 334, height:67,alignment: .leading)
                .cornerRadius(CornerRadius.xxxsmall.value)
            }
            .padding(ViewSpacing.medium)
            .frame(height:99)
            .cornerRadius(CornerRadius.xxxsmall.value)
            //4205
            VStack(alignment: .leading,spacing:ViewSpacing.small) {
                //第二个4293
                HStack(alignment: .top, spacing: ViewSpacing.base) {
                    Text(clinician.certificationType)
                      .font(Font.typography(.bodySmall))
                      .foregroundColor(Color.textPrimary)
                }
                .padding(0)
                .cornerRadius(CornerRadius.xxxsmall.value)
            }
            .padding(.horizontal, ViewSpacing.medium)
            .padding(.vertical, ViewSpacing.small)
            .frame(width: 366,height:36,alignment: .topLeading)
            .cornerRadius(CornerRadius.xxxsmall.value)
            //4582
            HStack(alignment: .center) {
              //4581
                HStack(alignment: .center, spacing: ViewSpacing.small) {
                    Text(String(format: "%.1f", clinician.avgRating))
                      .font(Font.typography(.bodyLargeEmphasis))
                      .multilineTextAlignment(.center)
                      .foregroundColor(Color.textPrimary)
                    
                    StarRatingView2(rating: clinician.avgRating)
                }
                .padding(0)
                .frame(maxHeight: .infinity, alignment: .leading)
                .cornerRadius(CornerRadius.xxxsmall.value)
                
              Spacer()
              //$200
                Text("$\(clinician.charge)/次")
                  .font(Font.typography(.bodyLargeEmphasis))
                  .foregroundColor(Color.textBrand)
            }
            .padding(ViewSpacing.medium)
            .frame(height:57,alignment: .center)
            .cornerRadius(CornerRadius.xxxsmall.value)
        }
        .padding(0)
        .background(Color.grey50)
        .cornerRadius(CornerRadius.medium.value)
        .shadow(color: Color(red: 0.36, green: 0.36, blue: 0.47).opacity(0.03), radius: 8.95, x: 5, y: 3)
        .shadow(color: Color(red: 0.15, green: 0.15, blue: 0.25).opacity(0.08), radius: 5.75, x: 2, y: 4)
        .frame(width:366, height:283)
    }
}



#Preview {
    ClinicianCardView()
}
