//
//  AnxietyHomepageView.swift
//  voiceout
//
//  Created by Ziyang Ye on 10/15/25.
//

import SwiftUI

private struct Constants {
    static let colorGrey500: Color = Color(red: 0.29, green: 0.27, blue: 0.31)
}

private struct DialogHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct MoodTreatmentAnxietyHomepageView: View {
    @EnvironmentObject var router: RouterModel
    @State private var dialogHeight: CGFloat = 0

    var body: some View {
        let screenWidth = UIScreen.main.bounds.width
        enum ScreenSizeCategory { case small, medium, large }
        let category: ScreenSizeCategory = {
            switch screenWidth {
            case ..<400:       return .small
            case 400..<420:    return .medium
            default:           return .large
            }
        }()

        let bubbleHeight: CGFloat = 122
        let bubbleHorizontalPadding: CGFloat
        let bubbleInnerTextTop: CGFloat
        let bubbleInnerTextLeading: CGFloat
        let bubbleTop: CGFloat

        let cloudChatOffsetX: CGFloat = 52
        let buttonBottomPadding: CGFloat

        switch category {
        case .small:
            bubbleHorizontalPadding = 45
            bubbleInnerTextTop = 10
            bubbleInnerTextLeading = 8
            bubbleTop = ViewSpacing.large * ViewSpacing.betweenSmallAndBase + 52
            buttonBottomPadding = 60

        case .medium:
            bubbleHorizontalPadding = 45
            bubbleInnerTextTop = 10
            bubbleInnerTextLeading = 16
            bubbleTop = ViewSpacing.large * ViewSpacing.betweenSmallAndBase + 72
            buttonBottomPadding = ViewSpacing.base + ViewSpacing.medium + ViewSpacing.xxxxlarge

        case .large:
            bubbleHorizontalPadding = 45
            bubbleInnerTextTop = 10
            bubbleInnerTextLeading = 10
            bubbleTop = ViewSpacing.large * ViewSpacing.betweenSmallAndBase + 106
            buttonBottomPadding = ViewSpacing.base + ViewSpacing.medium + ViewSpacing.xxxxlarge
        }

        // cloud-chat 距离屏幕底部 277px
        let cloudChatDistanceFromBottom: CGFloat = 277
        let cloudChatHeight: CGFloat = 71
        let cloudChatWidth: CGFloat = 100
        let screenHeight = UIScreen.main.bounds.height
        // cloud-chat 底部距离屏幕顶部 = 屏幕高度 - 277
        // cloud-chat 顶部距离屏幕顶部 = 屏幕高度 - 277 - 71
        // content 区域从 header 下方开始（header 高度 44px）
        // 所以 cloud-chat 相对于 content 区域的偏移 = 屏幕高度 - 277 - 71 - 44
        let headerHeight: CGFloat = 44
        let cloudChatOffsetY: CGFloat = screenHeight - cloudChatDistanceFromBottom - cloudChatHeight - headerHeight
        
        // cloud-chat 的中间位置（相对于 content 区域）
        let cloudChatCenterY: CGFloat = cloudChatOffsetY + cloudChatHeight / 2
        
        // cloud-chat 在 topTrailing 对齐，offsetX = 52 表示从右边向左偏移 52px
        // 所以 cloud-chat 的左边位置 = 屏幕宽度 - 52 - cloudChatWidth
        let cloudChatLeft: CGFloat = screenWidth - cloudChatOffsetX - cloudChatWidth
        
        // vector 的右边应该距离 cloud-chat 左边 24px
        // 所以 vector 的右边位置 = cloudChatLeft - 24
        let vectorWidth: CGFloat = 15
        let vectorSpacingFromCloudChat: CGFloat = 24
        let vectorRight: CGFloat = cloudChatLeft - vectorSpacingFromCloudChat
        
        // 对话框有 horizontal padding，所以对话框的右边 = 屏幕宽度 - bubbleHorizontalPadding
        // vector 在 HStack 中靠右对齐（使用 Spacer），所以默认右边位置 = 屏幕宽度 - bubbleHorizontalPadding
        // 需要让 vector 的右边 = cloudChatLeft - 24 = screenWidth - 176
        // 所以 offset = (screenWidth - 176) - (screenWidth - bubbleHorizontalPadding) = bubbleHorizontalPadding - 176
        let dialogRight: CGFloat = screenWidth - bubbleHorizontalPadding
        let vectorOffsetFromDialogRight: CGFloat = vectorRight - dialogRight
        
        // 使用实际测量的对话框高度，如果还没有测量则使用更准确的估算值
        // 文本内容大约 4-5 行，每行约 20px，加上 padding 和 vector
        let estimatedDialogHeight: CGFloat = 100 + 32 + 14 // 文本约100px + padding 32px + vector 14px
        let dialogTotalHeight: CGFloat = dialogHeight > 0 ? dialogHeight : estimatedDialogHeight
        
        // 对话框底部应该在 cloud-chat 中间位置
        // cloud-chat 中间 = cloudChatOffsetY + cloudChatHeight / 2
        // 对话框底部 = 对话框顶部 + 对话框高度
        // 所以：对话框顶部 = cloud-chat 中间 - 对话框高度
        let dialogTop: CGFloat = cloudChatCenterY - dialogTotalHeight
        
        // 重新计算 bubbleTop，使对话框底部对齐到 cloud-chat 中间
        let newBubbleTop: CGFloat = dialogTop
        
        // vector 应该在对话框底部，右边距离 cloud-chat 左边 24px
        // vector 的右边位置 = cloudChatLeft - 24
        // vector 的左边位置 = vectorRight - vectorWidth
        let vectorLeft: CGFloat = vectorRight - vectorWidth
        // vector 的顶部应该贴住对话框底部（对话框底部在 cloudChatCenterY）
        let vectorTop: CGFloat = cloudChatCenterY
        // vector 的中心 y 位置 = 顶部 + 高度/2
        let vectorCenterY: CGFloat = vectorTop + 14 / 2
        
        // 按钮距离 vector49-2 底部 102px
        let buttonSpacingFromVector: CGFloat = 102
        
        // anxietyhome 底部距离对话框上部 19px
        let anxietyHomeSpacing: CGFloat = 19
        // anxietyhome 的顶部位置 = 对话框顶部 - 间距 - anxietyhome 高度
        let anxietyHomeTop: CGFloat = dialogTop - anxietyHomeSpacing - 112.99419
        // anxietyhome2 在 anxietyhome 上方 20px
        let anxietyHome2Spacing: CGFloat = 20
        let anxietyHome2Height: CGFloat = 114
        let anxietyHome2Top: CGFloat = anxietyHomeTop - anxietyHome2Spacing - anxietyHome2Height

        return MoodPageContainerView(
            mood: "anxiety",
            onHealTap: {},
            content: {
                ZStack(alignment: .topTrailing) {
                    VStack(spacing: 0) {
                        VStack(spacing: 0) {
                            VStack(spacing: 0) {
                                HStack(alignment: .center, spacing: 10) {
                                    Text("嗯，小伙伴，最近是不是有点焦虑？那种心里轻轻发紧、呼吸也有点浅的感觉。别急，先坐下来，我们慢一点，好吗？有时候，只要给自己一点时间，心就会慢慢松开。")
                                        .font(Font.custom("Alibaba PuHuiTi 3.0", size: 16))
                                        .foregroundColor(Constants.colorGrey500)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .background(.white)
                                .cornerRadius(12)
                            }
                            .background(
                                GeometryReader { geo in
                                    Color.clear
                                        .preference(key: DialogHeightKey.self, value: geo.size.height)
                                }
                            )
                            .onPreferenceChange(DialogHeightKey.self) { height in
                                dialogHeight = height
                            }
                            .padding(.top, newBubbleTop)

                            // 按钮距离 vector49-2 底部 102px
                            Color.clear
                                .frame(height: buttonSpacingFromVector)

                            Button(action: {
                                let startId = RoutineStartConfig.id(for: .anxiety)
                                router.navigateTo(.anxietySingleQuestion(id: startId))
                            }) {
                                Text("点击按钮继续")
                                    .font(Font.typography(.bodyMedium))
                                    .kerning(0.64)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.surfaceBrandPrimary)
                                    .frame(maxWidth: .infinity, minHeight: 44)
                                    .background(Color.surfacePrimary)
                                    .clipShape(Capsule())
                            }
                            .padding(.bottom, buttonBottomPadding)
                        }
                        .padding(.horizontal, bubbleHorizontalPadding)
                        Spacer()
                    }

                    Image("cloud-chat")
                        .resizable()
                        .frame(width: 100, height: 71)
                        .offset(x: cloudChatOffsetX, y: cloudChatOffsetY)
                        .allowsHitTesting(false)
                    
                    // vector 右边距离 cloud-chat 左边 24px，顶部贴住对话框底部
                    Image("vector49-2")
                        .resizable()
                        .frame(width: 15, height: 14)
                        .position(
                            x: (vectorRight - 15 / 2)+100-24 ,  // vector 的中心 x = 右边位置 - 宽度/2
                            y: vectorCenterY
                        )
                        .allowsHitTesting(false)
                    
                    // anxietyhome2 和 anxietyhome 在对话框正上方
                    GeometryReader { geometry in
                        ZStack {
                            // anxietyhome2 在 anxietyhome 上方 20px
                            Image("anxietyhomed")
                                .resizable()
                                .frame(width: 176, height: 114)
                                .position(
                                    x: geometry.size.width / 2,
                                    y: anxietyHome2Top + 114 / 2
                                )
                                .allowsHitTesting(false)
                            
                            // anxietyhome
                            Image("anxietyhome")
                                .resizable()
                                .frame(width: 213.3306, height: 112.99419)
                                .position(
                                    x: geometry.size.width / 2,
                                    y: anxietyHomeTop + 112.99419 / 2
                                )
                                .allowsHitTesting(false)
                        }
                    }
                    .zIndex(0) // 在对话框下方，作为背景
                }
            },
            background: {
                EmptyView()
            }
        )
    }
}

#Preview {
    MoodTreatmentAnxietyHomepageView()
        .environmentObject(RouterModel())
}
