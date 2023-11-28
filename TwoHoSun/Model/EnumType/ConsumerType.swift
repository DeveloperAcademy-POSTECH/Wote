//
//  ConsumerType.swift
//  TwoHoSun
//
//  Created by 235 on 11/1/23.
//

import SwiftUI

enum ConsumerType: String, Codable {
    case ecoWarrior = "ECO_WARRIOR"
    case budgetKeeper = "BUDGET_KEEPER"
    case flexer = "FLEXER"
    case trendsetter = "TRENDSETTER"
    case beautyLover = "BEAUTY_LOVER"
    case impulseBuyer = "IMPULSE_BUYER"
    case adventurer = "ADVENTURER"
    case riskAverse = "RISK_AVERSE"
    case banUser
    case withDrawel

    var title: String {
        switch self {
        case .ecoWarrior:
            return "지구지킴이"
        case .budgetKeeper:
            return "지갑지킴이"
        case .flexer:
            return "플랙스킹"
        case .trendsetter:
            return "유행선도자"
        case .beautyLover:
            return "예쁜게최고야"
        case .impulseBuyer:
            return "지름신강림러"
        case .adventurer:
            return "프로도전러"
        case .riskAverse:
            return "안전소비러"
        case .banUser:
            return "차단된사용자"
        case .withDrawel:
            return "탈퇴한사용자"
        }
    }

    var description: String {
        switch self {
        case .ecoWarrior:
            return "환경을 생각해 친환경 제품을 소비하는"
        case .budgetKeeper:
            return "소비의 기준은 가격! 가성비에 따라 소비하는"
        case .flexer:
            return "가성비보다 가심비 중심의 소비를 하는"
        case .trendsetter:
            return "빠르게 바뀌는 트랜드에 맞춰 소비하는"
        case .beautyLover:
            return "디자인이나 외관이 중요한 소비 가치인"
        case .impulseBuyer:
            return "가지고 싶은거 사고싶은 건 전부 다 사야하는"
        case .adventurer:
            return "새로운 물건을 직접 경험해보는걸 좋아하는"
        case .riskAverse:
            return "내가 신뢰도가 있는 제품만 소비하는 안전러"
        case .banUser:
            return ""
        case .withDrawel:
            return ""
        }
    }

    var icon: Image {
        switch self {
        case .ecoWarrior:
            return Image("icnEcoWarrior")
        case .budgetKeeper:
            return Image("icnSaving")
        case .flexer:
            return Image("icnFlexerKing")
        case .trendsetter:
            return Image("icnTrendy")
        case .beautyLover:
            return Image("icnBeautyLover")
        case .impulseBuyer:
            return Image("icnImpulseBuyer")
        case .adventurer:
            return Image("icnAdventurer")
        case .riskAverse:
            return Image("icnSafetyShopper")
        default:
            return Image("icnBan")
        }
    }

    var textColor: Color {
        switch self {
        case .ecoWarrior:
            return Color.blue200
        case .budgetKeeper:
            return Color.darkBlue100
        case .flexer:
            return Color.yellow100
        case .trendsetter:
            return Color.pink100
        case .beautyLover:
            return Color.purple100
        case .impulseBuyer:
            return Color.green100
        case .adventurer:
            return Color.red100
        case .riskAverse:
            return Color.lightBlue100
        default:
            return Color.gray800
        }
    }

    var lightBackgroundColor: Color {
        switch self {
        case .ecoWarrior:
            return Color.lightBlue200
        case .budgetKeeper:
            return Color.lightBlue300
        case .flexer:
            return Color.lightYellow100
        case .trendsetter:
            return Color.lightPink100
        case .beautyLover:
            return Color.lightPurple100
        case .impulseBuyer:
            return Color.lightGreen100
        case .adventurer:
            return Color.lightRed100
        case .riskAverse:
            return Color.lightBlue400
        case .banUser:
            return Color.darkRed200
        case .withDrawel:
            return Color.gray900

        }
    }

    var darkBackgroundColor: Color {
        switch self {
        case .ecoWarrior:
            return Color.darkBlue200
        case .budgetKeeper:
            return Color.darkBlue300
        case .flexer:
            return Color.darkYellow100
        case .trendsetter:
            return Color.darkPink100
        case .beautyLover:
            return Color.darkPurple100
        case .impulseBuyer:
            return Color.darkGreen100
        case .adventurer:
            return Color.darkRed100
        case .riskAverse:
            return Color.darkBlue400
        case .banUser:
            return Color.darkRed200
        case .withDrawel:
            return Color.gray900
        }
    }
}
