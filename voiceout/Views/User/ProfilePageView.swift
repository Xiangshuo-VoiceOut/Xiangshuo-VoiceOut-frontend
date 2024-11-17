//
//  ProfilePageView.swift
//  voiceout
//
//  Created by Jiaqi Chen on 10/27/24.
//

import Foundation
import SwiftUI

//  TODO: 1. Add variables after finishing each component revision (TODOs in component files)
//  TODO: 2. switcher: 基本信息-客户评价-咨询服务
//  TODO: 3. Header, menu and setting icon
//  TODO: 4. 客户评价，咨询服务页面
struct ProfilePageView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            NameTagView(
                name: "董丽华",
                consultingPrice: "$200/次",
                personalTitle: "专攻青少年焦虑情绪问题",
                imageUrl: "https://s3-alpha-sig.figma.com/img/349a/f982/5c5db48e5ba3bd06c62e4c9c892f02af?Expires=1732492800&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=llNknhfxTEXJcscv6wMhAKRFA65gzgqx60yEE7rZkA77~haSuwlioGXy-wvVaEaAbertZMdth7H2nxYPUPYoPvnja32O5nqNITp567r8frlC2XvQD299G3pdjZdo63LCHVmUvFXnp3jCLT82-zJXTWU5eSBrnRkFMwRm7VlHQSH7cwLlQZWFlyb96WgBAQ4xNKmFU1cEoaEr56wwXTp-2LfBE1NszbkznJ5dpYchUTL9uA2AE7RPC3YmuT4xqgGjNKg0xoSTv00OLe8z1qdqzFl9DzaMFR1WB7hvM9b0ZMOv8bweCGyIL8j~BaBtR0X9jO-nlGxAM92CEaORjNoW5A__",
                showEditButton: false

            )
            PersonalView(
                age: "32",
                gender: "女",
                location: "NY",
                language: "普通话",
                showEditButton: false
            )
            EducationView(showEditButton: false)
            QualificationView(showEditButton: false)
            CareerView(showEditButton: false)
            ConsultServiceView(showEditButton: false)
            WordToVisitorView(showEditButton: false)
        }
        .padding()
    }
}

struct ProfilePageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePageView()
    }
}
