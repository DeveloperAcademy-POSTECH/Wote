//
//  SpendTItleType.swift
//  TwoHoSun
//
//  Created by 235 on 11/1/23.
//

import SwiftUI

enum SpendTitleType {
    case ecoWarrior, saving, flexer, trendy, beautyLover, impulseBuyer, adventurer, safetyShopper
    
    var title: String {
        switch self {
        case .ecoWarrior:
            return "지구지킴이"
        case .saving:
            return "지갑지킴이"
        case .flexer:
            return "플랙스킹"
        case .trendy:
            return "유행선도자"
        case .beautyLover:
            return "예쁜게최고야짜릿해"
        case .impulseBuyer:
            return "지름신강림러"
        case .adventurer:
            return "프로도전러"
        case .safetyShopper:
            return "안전소비러"
        }
    }

    var description: String {
        switch self {
        case .ecoWarrior:
            return "환경을 생각해 친환경 제품을 소비하는"
        case .saving:
            return "소비의 기준은 가격! 가성비에 따라 소비하는"
        case .flexer:
            return "가성비보다 가심비 중심의 소비를 하는"
        case .trendy:
            return "빠르게 바뀌는 트랜드에 맞춰 소비하는"
        case .beautyLover:
            return "디자인이나 외관이 중요한 소비 가치인"
        case .impulseBuyer:
            return "가지고 싶은거 사고싶은 건 전부 다 사야하는"
        case .adventurer:
            return "새로운 물건을 직접 경험해보는걸 좋아하는"
        case .safetyShopper:
            return "내가 신뢰도가 있는 제품만 소비하는 안전러"
        }
    }

    var icon: Image {
        switch self {
        case .ecoWarrior:
            return Image("icnEcoWarrior")
        case .saving:
            return Image("icnSaving")
        case .flexer:
            return Image("icnFlexerKing")
        case .trendy:
            return Image("icnTrendy")
        case .beautyLover:
            return Image("icnBeautyLover")
        case .impulseBuyer:
            return Image("icnImpulseBuyer")
        case .adventurer:
            return Image("icnAdventurer")
        case .safetyShopper:
            return Image("icnSafetyShopper")
        }
    }

    var textColor: Color {
        switch self {
        case .ecoWarrior:
            return Color.green
        case .saving:
            return Color.yellow
        default:
            return Color.blue
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .ecoWarrior:
            return Color.purple
        default:
            return Color.accentBlue
        }
    }
}
