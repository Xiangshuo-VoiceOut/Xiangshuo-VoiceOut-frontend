//
//  Typography.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 4/16/24.
//

import SwiftUI

enum Typography {
    case headerLarge
    case headerMedium
    case headerSmall
    case headerXSmall
    case bodyLarge
    case bodyLargeEmphasis
    case bodyMedium
    case bodyMediumEmphasis
    case bodySmall
    case bodyXSmall
    case bodyXSmallEmphasis
    case bodyXXSmall
}

extension Font {
    static let typography: (Typography) -> Font = { typography in
        switch typography {
        case .headerLarge:
            Font.custom("AlibabaPuHuiTi_3_85_Bold", size: 48)
        case .headerMedium:
            Font.custom("AlibabaPuHuiTi_3_85_Bold", size: 40)
        case .headerSmall:
            Font.custom("AlibabaPuHuiTi_3_85_Bold", size: 32)
        case .headerXSmall:
            Font.custom("AlibabaPuHuiTi_3_85_Bold", size: 20)
        case .bodyLarge:
            Font.custom("AlibabaPuHuiTi_3_65_Medium", size: 18)
        case .bodyLargeEmphasis:
            Font.custom("AlibabaPuHuiTi_3_85_Bold", size: 18)
        case .bodyMedium:
            Font.custom("AlibabaPuHuiTi_3_65_Medium", size: 16)
        case .bodyMediumEmphasis:
            Font.custom("AlibabaPuHuiTi_3_85_Bold", size: 16)
        case .bodySmall:
            Font.custom("AlibabaPuHuiTi_3_65_Medium", size: 14)
        case .bodyXSmall:
            Font.custom("AlibabaPuHuiTi_3_65_Medium", size: 12)
        case .bodyXSmallEmphasis:
            Font.custom("AlibabaPuHuiTi_3_85_Bold", size: 12)
        case .bodyXXSmall:
            Font.custom("AlibabaPuHuiTi_3_65_Medium", size: 10)
        }
    }
}
