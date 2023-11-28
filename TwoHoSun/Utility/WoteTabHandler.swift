//
//  TabScrollHandler.swift
//  TwoHoSun
//
//  Created by 김민 on 11/28/23.
//

import SwiftUI

enum WoteTabType: Int, CaseIterable {
    case consider, review, myPage

    var tabTitle: String {
        switch self {
        case .consider:
            return "소비고민"
        case .review:
            return "소비후기"
        case .myPage:
            return "마이페이지"
        }
    }

    var selectedTabIcon: String {
        switch self {
        case .consider:
            return "icnTabConsiderSelected"
        case .review:
            return "icnTabReviewSelected"
        case .myPage:
            return "icnTabMyPageSelected"
        }
    }

    var unselectedTabIcon: String {
        switch self {
        case .consider:
            return "icnTabConsider"
        case .review:
            return "icnTabReview"
        case .myPage:
            return "icnTabMyPage"
        }
    }
}

@Observable
final class WoteTabHandler {
    var scrollToTop = false
    var selectedTab: WoteTabType = .consider {
        didSet {
            if oldValue == selectedTab && selectedTab == .consider {
                scrollToTop.toggle()
            }
        }
    }
}
