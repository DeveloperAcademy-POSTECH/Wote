//
//  WoteTabType.swift
//  TwoHoSun
//
//  Created by 235 on 10/18/23.
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

struct WoteTabView: View {
    @State private var selection = WoteTabType.consider

    var body: some View {
        TabView(selection: $selection) {
            ForEach(WoteTabType.allCases, id: \.self) { tab in
                tabDestinationView(for: tab)
                    .tabItem {
                        Image(selection == tab ?
                              tab.selectedTabIcon : tab.unselectedTabIcon)
                        Text(tab.tabTitle)
                    }
            }
        }
        .tint(Color.accentBlue)
        .onAppear {
            UITabBar.appearance().unselectedItemTintColor = .gray100
            UITabBar.appearance().backgroundColor = .background
        }
    }

    @ViewBuilder
    private func tabDestinationView(for tab: WoteTabType) -> some View {
        switch tab {
        case .consider:
            Text("소비고민")
        case .review:
            Text("소비후기")
        case .myPage:
            Text("마이페이지")
        }
    }
}

#Preview {
    WoteTabView()
}
