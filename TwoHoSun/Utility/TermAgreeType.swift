//
//  TermAgreeType.swift
//  TwoHoSun
//
//  Created by 김민 on 11/28/23.
//

import Foundation

enum TermAgreeType: Int {
    case needs, personalData, marketing
    
    static func fromRawValue(_ rawValue: Int) -> TermAgreeType? {
        return TermAgreeType(rawValue: rawValue)
    }

    var text: String {
        switch self {
        case .needs:
            return "서비스 이용약관, 개인정보 수집 및 이용 동의"
        case .personalData:
            return "개인정보 수집 및 이용 동의"
        case .marketing:
            return "마케팅 정보 수신 동의"
        }
    }

    var isRequired: Bool {
        switch self {
        case .needs:
            return true
        case .personalData:
            return true
        case .marketing:
            return false
        }
    }

    var termURL: String {
        switch self {
        case .needs:
            return "https://hansn97.notion.site/Wote-dcd81699a906483d8b91f88f88164d31"
        case .personalData:
            return "https://hansn97.notion.site/88ed8c9e4dd04f31b071c6b43d32a828"
        case .marketing:
            return "https://hansn97.notion.site/3a21b194a622480b88e60a066f71c44f"
        }
    }
}
