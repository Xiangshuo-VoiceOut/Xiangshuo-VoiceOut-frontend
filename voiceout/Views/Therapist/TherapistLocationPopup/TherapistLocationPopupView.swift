//
//  TherapistLocationPopupView.swift
//  TherapistLocationPopup
//
//  Created by Yujia Yang on 7/16/24.
//
import SwiftUI
import CoreLocation
import MapKit

extension CGFloat {
    struct DropdownHeight {
        static let closed: CGFloat = 247
        static let opened: CGFloat = 394
    }
}

struct TherapistLocationPopupView: View {
    @StateObject var viewModel = TherapistLocationPopupViewModel()
    @StateObject var dropdownViewModel = LocationDropdownViewModel()
    @State private var selectedState: DropdownOption? = nil
    @State private var states: [DropdownOption] = []
    @State private var isDropdownOpened = false
    @StateObject var locationManager = LocationManager()
    @State private var isShowingClinicianList = false
    
    private func loadStates() {
        let stateData = StateData.allStates
        states = stateData.map { DropdownOption(option: $0.code) }
    }
    
    let placeholder: String
    let options: [DropdownOption]
    var isCardInput: Bool = false
    
    var body: some View {
        VStack {
            if isShowingClinicianList {
                ClinicianListView(clinicians: viewModel.clinicians)
            } else {
                switch viewModel.currentView {
                case 1:
                    view1
                case 2:
                    view2
                case 3:
                    view3
                default:
                    EmptyView()
                }
            }
        }
        .onAppear {
            viewModel.showPopup()
            loadStates()
        }
    }
    
    var view1: some View {
        VStack {
            //4485
            VStack(alignment: .center, spacing: ViewSpacing.large) {
                //4483
                VStack(alignment: .center, spacing: ViewSpacing.small) {
                    //345
                    VStack(alignment: .center, spacing: ViewSpacing.betweenSmallAndBase) {
                        //text 想说”想要使用你的位置信息"
                        Text("“想说”想要使用你的位置信息")
                            .font(Font.typography(.bodyLargeEmphasis))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.grey500)
                            .frame(width: 171, alignment: .top)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.horizontal, ViewSpacing.medium)
                    .padding(.vertical, ViewSpacing.small)
                    .frame(width: 238, height: 66, alignment: .top)
                    .cornerRadius(CornerRadius.medium.value)
                    
                    policyText
                }
                .padding(0)
                .frame(width: 238, height: 125, alignment: .top)
                .cornerRadius(CornerRadius.xxxsmall.value)
                
                //4533
                VStack(alignment: .center, spacing: ViewSpacing.small) {
                    //4482 button
                    VStack(alignment: .center, spacing: ViewSpacing.medium) {
                        //允许
                        ZStack(alignment: .center) {
                            Button(action: {
                                viewModel.handleAllow()
                            }) {
                                Text("")
                                    .frame(width: 44, height: 44)
                            }
                            Text(LocalizedStringKey("Allow"))
                                .font(Font.typography(.bodyMediumEmphasis))
                                .kerning(0.64)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.grey50)
                        }
                        .padding(.horizontal, ViewSpacing.xxxlarge)
                        .padding(.vertical, ViewSpacing.small)
                        .frame(maxWidth: .infinity, minHeight: 44, maxHeight: 44, alignment: .center)
                        .background(Color.brandPrimary)
                        .cornerRadius(CornerRadius.full.value)
                    }
                    .padding(0)
                    .frame(width: 238, height: 44, alignment: .top)
                    .cornerRadius(CornerRadius.xxxsmall.value)
                    //4484 button
                    VStack(alignment: .center, spacing: ViewSpacing.medium) {
                        //不允许
                        ZStack(alignment: .center) {
                            Button(action: {
                                viewModel.handleDisallow()
                            }) {
                                Text("")
                                    .frame(width: 44, height: 44)
                            }
                            Text(LocalizedStringKey("DoNotAllow"))
                                .font(Font.typography(.bodyMediumEmphasis))
                                .kerning(0.64)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.brandPrimary)
                        }
                        .padding(.horizontal, ViewSpacing.xxxlarge)
                        .padding(.vertical, ViewSpacing.small)
                        .frame(maxWidth: .infinity, minHeight: 44, maxHeight: 44, alignment: .center)
                        .background(Color.grey50)
                        .cornerRadius(CornerRadius.full.value)
                        .overlay(
                            RoundedRectangle(cornerRadius: CornerRadius.full.value)
                                .inset(by: 1)
                                .stroke(Color.brandPrimary, lineWidth: 2)
                        )
                    }
                    .padding(0)
                    .frame(width: 238, height: 44, alignment: .top)
                    .cornerRadius(CornerRadius.xxxsmall.value)
                }
                .padding(0)
                .frame(width: 238, height: 96, alignment: .top)
                .cornerRadius(CornerRadius.xxxsmall.value)
            }
            .padding(ViewSpacing.medium)
            .frame(width: 270, height: 277, alignment: .top)
            .cornerRadius(CornerRadius.xxxsmall.value)
        }
        .foregroundColor(.clear)
        .frame(width: 270, height: 278)
        .background(Color.grey50)
        .cornerRadius(CornerRadius.medium.value)
        .shadow(color: .black.opacity(0.5), radius: 0, x: 0, y: 0)
    }
    
    var view2: some View {
        VStack {
            //345
            VStack{
                //"允许 “VoiceOut” 使用你的位置信息"
                Text("AllowVoiceOutToUseYourLocation")
                    .font(Font.typography(.bodyMediumEmphasis))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .frame(width: 133, alignment: .top)
                //"开启精准定位后只推送本地区可约的
                Text("开启精准定位后只推送本地区可约的咨询师，请允许VoiceOut查找您的位置（开启后只推送本地区可约的咨询师）")
                    .font(Font.typography(.bodySmall))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .frame(width: 238, alignment: .top)

                ZStack {
                    MapView()
                        .environmentObject(locationManager)
                        .frame(width: 270, height: 174)
                }
                .cornerRadius(CornerRadius.xxxsmall.value)
                
                Divider()
                    .frame(width: 270)
                //345
                VStack(alignment: .center, spacing: 0) {
                    //"允许一次"
                    VStack(alignment: .center, spacing: ViewSpacing.betweenBaseAndMedium){
                        Button(action: {
                            locationManager.requestPermission()
                            viewModel.handleAllowOnce()
                            viewModel.hidePopup()
                            if let location = locationManager.location {
                                let state = viewModel.getStateFromLocation(location.coordinate)
                                viewModel.confirmRegionSelection(state: state)
                                isShowingClinicianList = true
                            }
                        }) {
                            Text(LocalizedStringKey("AllowOnce"))
                                .font(Font.typography(.bodyMedium))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal, 0)
                    .padding(.vertical, ViewSpacing.betweenSmallAndBase)
                    .frame(width:270,height:42, alignment: .top)
                    .cornerRadius(CornerRadius.xxxsmall.value)
                }
                .padding(0)
                .cornerRadius(CornerRadius.xxxsmall.value)
                Divider()
                    .frame(width: 270)
                //使用App时
                VStack(alignment: .center, spacing: ViewSpacing.betweenBaseAndMedium) {
                    Button(action: {
                        locationManager.requestPermission()
                        viewModel.handleAllowWhileUsingApp()
                        viewModel.hidePopup()
                        if let location = locationManager.location {
                            let state = viewModel.getStateFromLocation(location.coordinate)
                            viewModel.confirmRegionSelection(state: state)
                            isShowingClinicianList = true
                        }
                    }) {
                        Text(LocalizedStringKey("AllowWhileUsingApp"))
                            .font(Font.typography(.bodyMedium))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal, 0)
                .padding(.vertical, ViewSpacing.betweenSmallAndBase)
                .frame(width:270,height:42, alignment: .top)
                .cornerRadius(CornerRadius.xxxsmall.value)
                Divider()
                    .frame(width: 270)
                //不允许
                VStack(alignment: .center, spacing: ViewSpacing.betweenBaseAndMedium) {
                    Button(action: {
                        viewModel.currentView = 3
                    }) {
                        Text(LocalizedStringKey("DoNotAllow"))
                            .font(Font.typography(.bodyMedium))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal, 0)
                .padding(.vertical, ViewSpacing.betweenSmallAndBase)
                .frame(width:270,height:42, alignment: .top)
                .cornerRadius(CornerRadius.xxxsmall.value)
                .shadow(color: .black.opacity(0.5), radius: 0, x: 0, y: 0)
            }
            .padding(ViewSpacing.medium)
            .cornerRadius(CornerRadius.medium.value)
        }
        .frame(width:254)
        .background(Color.surfacePrimary)
        .cornerRadius(CornerRadius.medium.value)
    }
    
    var view3: some View {
        VStack(alignment: .center, spacing: ViewSpacing.large) {
            Text("若无法开启定位，请手动选择所在位置")
                .font(Font.typography(.bodyLargeEmphasis))
                .multilineTextAlignment(.center)
                .foregroundColor(.textPrimary)
                .frame(width: 170, alignment: .top)
                .fixedSize(horizontal: false, vertical: true)
            
            VStack(alignment: .leading, spacing: ViewSpacing.small) {
                Text("地区")
                    .font(Font.typography(.bodyMedium))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.textPrimary)
                
                Button(action: {
                    withAnimation {
                        viewModel.isDropdownOpened.toggle()
                    }
                }) {
                    HStack {
                        Text(selectedState?.option ?? "请选择地区")
                            .foregroundColor(.textSecondary)
                            .font(Font.typography(.bodyMedium))
                        Spacer()
                        Image("down")
                            .rotationEffect(.degrees(viewModel.isDropdownOpened ? 180 : 0))
                    }
                    .padding(ViewSpacing.small)
                    .frame(width: 236, height: 36, alignment: .center)
                    .background(Color.surfacePrimaryGrey2)
                    .cornerRadius(CornerRadius.medium.value)
                }
                
                if viewModel.isDropdownOpened {
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(states, id: \.self) { state in
                                Button(action: {
                                    selectedState = state
                                    withAnimation {
                                        viewModel.isDropdownOpened = false
                                    }
                                }) {
                                    Text(state.option)
                                        .frame(maxWidth: .infinity, minHeight: 50)
                                        .contentShape(Rectangle())
                                        .foregroundColor(.textPrimary)
                                }
                                .padding(.horizontal)
                                .background(Color.surfacePrimaryGrey2)
                            }
                        }
                        .cornerRadius(CornerRadius.medium.value)
                    }
                    .frame(maxHeight: 150)
                }
            }
            
            Button(action: {
                if let state = selectedState?.option {
                    viewModel.confirmRegionSelection(state: state)
                    isShowingClinicianList = true
                }
            }) {
                Text("确认")
                    .font(Font.typography(.bodyMediumEmphasis))
                    .kerning(0.64)
                    .multilineTextAlignment(.center)
                    .foregroundColor(selectedState == nil ? Color.textPrimary : Color.textInvert)
            }
            .padding(.horizontal, ViewSpacing.xxxlarge)
            .padding(.vertical, ViewSpacing.small)
            .frame(width: 238, height: 44, alignment: .center)
            .background(selectedState == nil ? Color.surfacePrimaryGrey : Color.surfaceBrandPrimary)
            .cornerRadius(CornerRadius.full.value)
            .disabled(selectedState == nil)
        }
        .padding(ViewSpacing.medium)
        .frame(width: 270, height: viewModel.isDropdownOpened ? 394 : 247, alignment: .top)
        .background(Color.surfacePrimary)
        .cornerRadius(CornerRadius.medium.value)
        .shadow(color: .black.opacity(0.5), radius: 0, x: 0, y: 0)
        .animation(.easeInOut, value: viewModel.isDropdownOpened)
    }

    var policyText: some View {
        HStack(alignment: .center) {
            HStack(alignment: .center) {
                Text("根据")
                    .font(Font.typography(.bodyXSmallEmphasis))
                    .kerning(0.36)
                    .foregroundColor(.grey500) +
                
                Text("《美国心理咨询政策》")
                    .font(Font.typography(.bodyXSmallEmphasis))
                    .kerning(0.36)
                    .foregroundColor(.actionInfo) +
                Text("，想说需要您的位置信息来匹配与您在同一地区的心理咨询师")
                    .font(Font.typography(.bodyXSmallEmphasis))
                    .kerning(0.36)
                    .foregroundColor(.grey500)
            }
            .multilineTextAlignment(.center)
            .frame(width: 238, height: 51, alignment: .top)
            .padding(0)
            .frame(width: 238, height: 51, alignment: .center)
            .cornerRadius(CornerRadius.xxxsmall.value)
        }
        .padding(0)
        .frame(width: 238, height: 51, alignment: .center)
        .cornerRadius(CornerRadius.xxxsmall.value)
    }
}

struct ClinicianListView: View {
    var clinicians: [Clinician]

    var body: some View {
        List(clinicians) { clinician in
            Text(clinician.name)
        }
    }
}

#Preview {
    TherapistLocationPopupView(placeholder: "请选择地区", options: [])
}

