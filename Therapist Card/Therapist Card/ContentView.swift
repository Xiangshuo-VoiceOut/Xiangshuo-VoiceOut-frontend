//
//  ContentView.swift
//  Therapist Card
//
//  Created by Yujia Yang on 7/5/24.
//

import SwiftUI

struct ContentView: View {
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
                viewModel.loadTestData()
                //viewModel.fetchClinician()
            }
        }
    }
}




struct StarRatingView: View{
    var rating: Double
    let maximumRating = 5
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<maximumRating, id: \.self) { index in
                ZStack(alignment: .leading) {
                    Image(systemName: "star")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color(red: 0.98, green: 0.99, blue: 1))
                    
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
                HStack(alignment: .center, spacing: 24) {
                    
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
                                  .cornerRadius(1)
                                
                                // "今天可约" 文字
                                Text("今天可约")
                                    .font(Font.custom("Alibaba PuHuiTi 3.0", size: 12))
                                    .kerning(0.36)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(red: 0.98, green: 0.99, blue: 1))
                                    .frame(width: 53, height: 17)
                                    .background(Color(red: 0.09, green: 0.07, blue: 0.07))
                            }
                            .padding(.horizontal, 4)
                            .padding(.vertical, 1)//1
                            .frame(width: 69, height: 17, alignment: .center)// alignmentbottomLeading
                            .background(Color(red: 0.09, green: 0.07, blue: 0.07))
                            .cornerRadius(4)
                        }
                        
                        .frame(width: 69, height: 67, alignment: .bottomLeading)
                        .cornerRadius(1)
                        
                    }
                        .padding(0)
                        .frame(width: 69, height: 67, alignment: .center)
                        .cornerRadius(1)

                    //4304
                    VStack(alignment: .leading, spacing: 8) {
                        //4301
                        VStack(alignment: .leading, spacing: 4) {
                            //4206
                            HStack(alignment: .center, spacing: 0) {
                                //4300
                                HStack(alignment: .center, spacing: 0) {
                                // Body XL
                                Text(clinician.name)
                                    .font(Font.custom("Alibaba PuHuiTi 3.0", size: 18))
                                    .foregroundColor(.black)
                            }
                            .padding(0)
                            .frame(width: 54, height: 25, alignment: .center)
                            .cornerRadius(1)
                        }
                            .padding(0)
                            .frame(width: 54, height: 25, alignment: .center)
                            .cornerRadius(1)
                            //4302
                            HStack(alignment: .center, spacing: 0) {
                                // Pre Title
                                Text("从业经验：\(clinician.yearOfExperience)年")
                                  .font(Font.custom("Alibaba PuHuiTi 3.0", size: 12))
                                  .kerning(0.36)
                                  .foregroundColor(Color(red: 0.58, green: 0.64, blue: 0.93))
                            }
                            .padding(.leading, 1)
                            //.padding(.trailing, 159)
                            .padding(.vertical, 0)
                            .frame(height:12, alignment: .leading)
                            .cornerRadius(4)
                        }
                        .padding(0)
                        .frame(width:241,height:42,alignment: .topLeading)
                        //.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .cornerRadius(1)
                        //4293
                        HStack(alignment: .center, spacing: 16) {
                            //4235
                            //4237
                            //4236
                            ForEach(clinician.consultField, id: \.tag) { tag in
                                    HStack(alignment: .center, spacing: 0) {
                                        Text(tag.tag)
                                            .font(Font.custom("Alibaba PuHuiTi 3.0", size: 12))
                                            .kerning(0.36)
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Color(red: 0.98, green: 0.99, blue: 1))
                                    }
                                }
                            .padding(.horizontal, 6)
                            .padding(.vertical, 1)
                            .background(Color(red: 0.58, green: 0.64, blue: 0.93))
                            .cornerRadius(4)
                            .frame(height:17)
                        }
                        .padding(0)
                        //.frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height:17, alignment: .leading)
                        .cornerRadius(1)
                    }
                    .padding(0)
                    //.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .frame(width: 241, height: 67, alignment: .topLeading)
                    
                    .cornerRadius(1)
                }
                .padding(0)
                .frame(width: 334, height:67,alignment: .leading)
                .cornerRadius(1)
            }
            .padding(16)
            .frame(height:99)
            .cornerRadius(1)
            //4205
            VStack(alignment: .leading,spacing:8) {
                //第二个4293
                HStack(alignment: .top, spacing: 12) {
                    // Small
                    Text(clinician.certificationType)
                      .font(Font.custom("Alibaba PuHuiTi 3.0", size: 14))
                      .foregroundColor(Color(red: 0.26, green: 0.19, blue: 0.15))
                      //.frame(width: 125, alignment: .topLeading)
                }
                .padding(0)
                .cornerRadius(1)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .frame(width: 366,height:36,alignment: .topLeading)
            .cornerRadius(1)
            //4582
            HStack(alignment: .center) {
              // Space Between
              //4581
                HStack(alignment: .center, spacing: 8) {
                    // Body XL Bold
                    Text(String(format: "%.1f", clinician.avgRating))
                      .font(Font.custom("Alibaba PuHuiTi 3.0", size: 18))
                      .multilineTextAlignment(.center)
                      .foregroundColor(Color(red: 0.26, green: 0.19, blue: 0.15))
                    
                    StarRatingView(rating: clinician.avgRating)
                }
                .padding(0)
                .frame(maxHeight: .infinity, alignment: .leading)
                .cornerRadius(1)
                
              Spacer()
              // Alternative Views and Spacers
                
              //$200
                // Typography/BodyXL Bold
                Text("$\(clinician.charge)/次")
                  .font(Font.custom("Alibaba PuHuiTi 3.0", size: 18))
                  .foregroundColor(Color(red: 0.99, green: 0.49, blue: 0.26))
            }
            .padding(16)
            .frame(height:57,alignment: .center)
            //.frame(maxWidth: .infinity, alignment: .center)
            .cornerRadius(1)
        }
        .padding(0)
        .background(Color(red: 0.98, green: 0.99, blue: 1))
        .cornerRadius(16)
        .shadow(color: Color(red: 0.36, green: 0.36, blue: 0.47).opacity(0.03), radius: 8.95, x: 5, y: 3)
        .shadow(color: Color(red: 0.15, green: 0.15, blue: 0.25).opacity(0.08), radius: 5.75, x: 2, y: 4)
        .frame(width:366, height:283)
    }
}



#Preview {
    ContentView()
}
