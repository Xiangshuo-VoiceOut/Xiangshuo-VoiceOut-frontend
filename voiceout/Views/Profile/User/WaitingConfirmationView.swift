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

    var body: some View {
        ZStack(alignment: .top) {
            Color.surfacePrimaryGrey2
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                ZStack {
                    StickyHeaderView(
                        title: "订单确认",
                        leadingComponent: AnyView(
                            Button(action: {
                                router.navigateBack()
                            }) {
                                Image(systemName: "arrow.backward")
                                    .foregroundColor(.black)
                                    .frame(height: 24)
                            }
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
                }
                .frame(height: 44)
                .zIndex(1)

                ScrollView {
                    VStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: CornerRadius.medium.value)
                                .fill(Color.surfacePrimary)

                            HStack(alignment: .center, spacing: ViewSpacing.medium) {
                                HStack(alignment: .center, spacing: ViewSpacing.medium) {
                                    AsyncImage(
                                        url: URL(string: "https://s3-alpha-sig.figma.com/img/349a/f982/5c5db48e5ba3bd06c62e4c9c892f02af?Expires=1732492800&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=llNknhfxTEXJcscv6wMhAKRFA65gzgqx60yEE7rZkA77~haSuwlioGXy-wvVaEaAbertZMdth7H2nxYPUPYoPvnja32O5nqNITp567r8frlC2XvQD299G3pdjZdo63LCHVmUvFXnp3jCLT82-zJXTWU5eSBrnRkFMwRm7VlHQSH7cwLlQZWFlyb96WgBAQ4xNKmFU1cEoaEr56wwXTp-2LfBE1NszbkznJ5dpYchUTL9uA2AE7RPC3YmuT4xqgGjNKg0xoSTv00OLe8z1qdqzFl9DzaMFR1WB7hvM9b0ZMOv8bweCGyIL8j~BaBtR0X9jO-nlGxAM92CEaORjNoW5A__")
                                    ) { phase in
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

                                    Text("董丽华")
                                        .font(Font.typography(.bodyLargeEmphasis))
                                        .foregroundColor(.black)

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
                                    Text("视频通话")
                                        .font(Font.typography(.bodyLargeEmphasis))
                                        .foregroundColor(.textBrandSecondary)
                                }
                                HStack(alignment: .center, spacing: ViewSpacing.large) {
                                    Text("咨询时间")
                                        .font(Font.typography(.bodySmall))
                                        .foregroundColor(.textPrimary)
                                    Text("2024年9月9日 16:00-16:50 PM")
                                        .font(Font.typography(.bodySmall))
                                        .foregroundColor(.textPrimary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)

                                HStack(alignment: .center, spacing: ViewSpacing.large) {
                                    Text("订单价格")
                                        .font(Font.typography(.bodySmall))
                                        .foregroundColor(.textPrimary)
                                    Text("$200/次")
                                        .font(Font.typography(.bodySmall))
                                        .foregroundColor(.textPrimary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                                HStack(alignment: .center, spacing: ViewSpacing.large) {
                                    Text("实付金额")
                                        .font(Font.typography(.bodySmall))
                                        .foregroundColor(.textPrimary)
                                    Text("$200.00")
                                        .font(Font.typography(.bodyMedium))
                                        .foregroundColor(.textBrandSecondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)

                                HStack(alignment: .center, spacing: ViewSpacing.large) {
                                    Text("订单状态")
                                        .font(Font.typography(.bodySmall))
                                        .foregroundColor(.textPrimary)
                                    Text("待支付")
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
                                    Text("备注信息")
                                        .font(Font.typography(.bodySmall))
                                        .foregroundColor(.textPrimary)
                                    TextField("您想对咨询师说的话（选填）", text: $userMessage)
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
                            Text("下单后，如果咨询师同意您的预约邀请，咨询师将会向您发送视频链接。")
                                .font(Font.typography(.bodySmall))
                                .foregroundColor(.textSecondary)
                                .frame(width: 245, alignment: .center)
                        }
                        .padding(.bottom, -ViewSpacing.large-ViewSpacing.xxlarge)
                        .frame(maxWidth: .infinity)
                        HStack {
                            VStack(alignment: .leading, spacing: ViewSpacing.xsmall) {
                                Text("$200.00")
                                    .font(Font.typography(.bodyMediumEmphasis))
                                    .foregroundColor(.textBrandSecondary)
                                Text("1次线上咨询")
                                    .font(Font.typography(.bodyXSmall))
                                    .foregroundColor(.textSecondary)
                            }
                            Spacer()
                            HStack(alignment: .center, spacing: ViewSpacing.betweenSmallAndBase) {
                                Button(action: {
                                    print("确认订单按钮点击")
                                }) {
                                    Text("确认订单")
                                        .font(Font.typography(.bodyMedium))
                                        .kerning(0.64)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.textInvert)
                                }
                                .padding(.horizontal, ViewSpacing.large)
                                .padding(.vertical, ViewSpacing.small)
                                .frame(width: 204, height: 44, alignment: .center)
                                .background(Color.surfaceBrandPrimary)
                                .cornerRadius(CornerRadius.full.value)
                            }
                        }
                        .padding(.top,ViewSpacing.large)
                        .padding(.leading, ViewSpacing.xlarge)
                        .padding(.trailing, ViewSpacing.medium)
                        .background(Color.surfacePrimary)
                    }
                }
            }
        }
    }
}

#Preview {
    WaitingConfirmationView()
        .environmentObject(RouterModel())
}
