//
//  SpendTItleType.swift
//  TwoHoSun
//
//  Created by 235 on 11/1/23.
//

import SwiftUI
enum SpendTItleType {
    case ecoWarrior, saving, flexer, trendy, beutyLover, impulseBuyer, adventurer, safetyShopper
    var title: String {
        switch self {
        case .ecoWarrior:
            return "지구지킴이"
        case .saving:
            return "지갑지킴이"
        case .flexer:
            return "Flexer킹"
        case .trendy:
            return "유행선도자"
        case .beutyLover:
            return "예쁜게최고야짜릿해"
        case .impulseBuyer:
            return "지름신강림러"
        case .adventurer:
            return "프로도전러"
        case .safetyShopper:
            return "실패줄임러"
        }
    }
    
    var color: Color {
        switch self {
        case .ecoWarrior:
            return Color.green
        case .saving:
            return Color.yellow
        default:
            return Color.blue
        }
    }
}
