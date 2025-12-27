//
//  PrivacyPolicyView.swift
//  voiceout
//
//  Created by Yujia Yang on 12/22/25.
//

import SwiftUI

struct PrivacyPolicyView: View {
    @EnvironmentObject var router: RouterModel
    @Environment(\.openURL) private var openURL
    
    private let agreedKey: String = "user_agreement_accepted"
    
    private let agreementURL: URL = URL(string: "https://voiceout.app/UserAgreement.pdf")!
    private let policyURL: URL = URL(string: "https://voiceout.app/PrivacyPolicy.pdf")!
    
    private let agreementText = """
1. 引言
本政策说明 Voiceout LLC（“VoiceOut”“我们”）如何收集、使用、存储与保护用户隐私。适用于 VoiceOut iOS 及相关服务。

2. 我们收集的个人信息
“个人信息”指独立或与其他信息结合后可识别自然人身份的数据。我们遵循数据最小化原则，仅收集：
a) 结构化选择与填空答案（情绪分值、选项 ID、简短关键词）；
b) 匿名设备信息（随机用户 ID、设备型号、系统版本、崩溃日志、使用时长）。
我们不会收集或存储：姓名、邮箱、电话、地址、自由格式日记、语音、影像、精确位置、广告标识符（IDFA/GAID）或任何可直接识别身份的敏感信息。

3. 通信信息
若你直接联系我们（如 xiangshuo@voiceout.pro），我们可能会收到你的邮箱地址和消息内容，仅用于回复与支持，对话结束后 90 天内删除，除非法律另有要求。

4. 收集方式
• 你完成练习或点击呼吸引导时由 App 自动记录；
• 通过 AWS CloudWatch/X-Ray 收集性能与崩溃日志（采样率 ≤5%）。

5. 使用目的
a) 展示练习历史与进度；
b) 修复崩溃与性能问题；
c) 生成不可识别的汇总统计以改进服务（已匿名且不可还原），我们不会将个人信息用于定向广告或出售。

6. 存储与跨境传输
• 数据经加密（AES-256 静态、TLS 1.3 传输）后存储于 AWS US-East-2（Ohio）。
• 美国境外用户访问时，数据将跨境传输至美国；我们依据标准合同条款及 AWS 安全认证提供 GDPR、PIPEDA 等法律要求的适当保障。

7. 数据保留与删除
• 活跃数据：自最后交互日起保留 365 天，用于同步历史进度。
• 你可在“设置-数据管理”一键提交删除；我们在 24 小时内清除主库与备份，仅保留已匿名化的汇总统计。
• 法律要求：若需遵守强制法律义务，可能延长保留，但不再用于其他目的。

8. 第三方处理者
• Amazon Web Services, Inc.——云基础设施（已签署数据处理附录）。
•上海稀宇极智科技有限公司——仅预生成呼吸引导视频，接收匿名文本脚本，不接收任何个人数据，也不会将脚本用于模型训练（2025 服务条款）。
• 深圳脸萌科技有限公司——通过剪映商用版曲库提供背景音乐，不接收任何个人数据。
  我们绝不与广告网络、分析商或生成式 AI 服务商共享个人信息。

9. 自动化决策与分析
当前版本不含用户画像或自动决策；若未来增加，将提前披露并向你提供退出机制。

10. 你的权利
依据 CCPA/CPRA、PIPEDA 及 GDPR（如适用），你可：
• 访问：获取我们持有的与你有关的数据副本；
• 更正：纠正不准确数据；
• 删除：一键删除全部数据（见第 6 条）；
• 撤回同意：删除数据即视为撤回；
• 不歧视：行使上述权利不会导致服务质量降低。
你可发送邮件至 support@voiceout.app 或使用 App 内“意见反馈”提交请求，我们将在 45 天内完成处理与答复。

11. 儿童隐私
服务不面向 13 岁以下儿童。若我们发现已收集此类数据，将立即删除。

12. 信息安全
我们采取行业标准技术与管理措施（加密、最小权限、定期漏洞扫描、员工保密协议）防止未经授权的访问、披露、篡改或毁损。

13. 隐私政策变更
我们可能因功能或法律变化更新本政策；重大变更将在 App 内弹窗通知。继续访问即表示你接受更新后的政策。

14. 联系我们
数据控制者：
Voiceout LLC
401 Ryland Street Suite 200-A, Reno, NV 89502, USA
邮箱：support@voiceout.app
如有隐私投诉，你可向所在州/省或国家的数据保护监管机构提出。
"""
    
    @State private var showMainHomepage = false
    
    var body: some View {
        ZStack {
            Image("day2")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack{
                VStack(alignment: .center, spacing: ViewSpacing.medium) {
                    Text("使用协议及隐私条款概要")
                        .font(Font.typography(.bodyLarge))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.textPrimary)
                    
                    VStack(alignment: .leading, spacing: ViewSpacing.small) {
                        HStack(alignment: .center, spacing: 0) {
                            ScrollView(showsIndicators: true) {
                                Text(agreementText)
                                    .font(Font.typography(.bodySmall))
                                    .foregroundColor(.textPrimary)
                                    .frame(maxHeight: .infinity, alignment: .topLeading)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 0) {
                            HStack(spacing: 0) {
                                Text("查看完整版：")
                                    .font(Font.typography(.bodySmall))
                                    .foregroundColor(.textPrimary)
                                
                                Button { openURL(agreementURL) } label: {
                                    Text("《用户协议》")
                                        .font(Font.typography(.bodySmall))
                                        .foregroundColor(.textInfo)
                                        .underline()
                                }
                                .buttonStyle(.plain)
                                
                                Text("和")
                                    .font(Font.typography(.bodySmall))
                                    .foregroundColor(.textPrimary)
                                
                                Button { openURL(policyURL) } label: {
                                    Text("《隐私政策》")
                                        .font(Font.typography(.bodySmall))
                                        .foregroundColor(.textInfo)
                                        .underline()
                                }
                                .buttonStyle(.plain)
                            }
                            .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    
                    HStack(alignment: .center, spacing: ViewSpacing.medium) {
                        Button(action: closeApp) {
                            Text("退出")
                                .font(Font.typography(.bodyMedium))
                                .kerning(0.64)
                                .foregroundColor(.textBrandPrimary)
                                .frame(maxWidth: .infinity, minHeight: 44)
                                .background(Color.surfacePrimary)
                                .overlay(
                                    Capsule()
                                        .stroke(Color.surfaceBrandPrimary,lineWidth: StrokeWidth.width200.value)
                                )
                                .clipShape(Capsule())
                                .cornerRadius(360)
                        }
                        .buttonStyle(.plain)
                        
                        Button {
                            UserDefaults.standard.set(true, forKey: agreedKey)
                            router.navigateTo(.mainHomepage)
                        } label: {
                            Text("同意")
                                .font(Font.typography(.bodyMedium))
                                .kerning(0.64)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.textInvert)
                                .padding(.horizontal, ViewSpacing.medium)
                                .padding(.vertical,ViewSpacing.small)
                                .frame(maxWidth: .infinity, minHeight: 44, maxHeight: 44, alignment: .center)
                                .background(Color.surfaceBrandPrimary)
                                .cornerRadius(CornerRadius.full.value)
                        }
                    }
                    .frame(maxWidth: .infinity, minHeight: 44, maxHeight: 44, alignment: .leading)
                }
                .padding(ViewSpacing.large)
                .frame(height:341)
                .background(Color.surfacePrimary)
                .cornerRadius(CornerRadius.medium.value)
            }
            .padding(.horizontal,ViewSpacing.xlarge+ViewSpacing.base)
        }
        .navigationBarHidden(true)
    }
    
    private func closeApp() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            exit(0)
        }
    }
}

struct PrivacyPolicyView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PrivacyPolicyView()
                .environmentObject(RouterModel())
        }
    }
}
