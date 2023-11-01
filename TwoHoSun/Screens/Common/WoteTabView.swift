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

enum VoteCategoryType {
    case all, mySchool

    var title: String {
        switch self {
        case .all:
            return "전국투표"
        case .mySchool:
            return "OO고등학교 투표"
        }
    }
}

struct WoteTabView: View {
    @State private var selection = WoteTabType.consider

    var body: some View {
        NavigationStack {
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
            .onAppear {
                UITabBar.appearance().unselectedItemTintColor = .gray100
                UITabBar.appearance().backgroundColor = .background
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    voteCategoryButton
                }

                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        notificationButton
                        searchButton
                    }
                }
            }
            .toolbarBackground(Color.background, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

extension WoteTabView {

    @ViewBuilder
    private func tabDestinationView(for tab: WoteTabType) -> some View {
        switch tab {
        case .consider:
            MainVoteView()
        case .review:
            Text("소비후기")
        case .myPage:
            Text("마이페이지")
        }
    }

    private var voteCategoryButton: some View {
        Button {

        } label: {
            HStack(spacing: 5) {
                Text("전국 투표")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
                Image(systemName: "chevron.down")
                    .font(.system(size: 16))
                    .foregroundStyle(Color.descriptionGray)
            }
        }
    }

    private var notificationButton: some View {
        NavigationLink {
            NotificationView()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .frame(width: 39, height: 39)
                    .foregroundStyle(Color.disableGray)
                Image(systemName: "bell.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(Color.woteWhite)
            }
        }
    }

    private var searchButton: some View {
        NavigationLink {
            SearchView()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .frame(width: 39, height: 39)
                    .foregroundStyle(Color.disableGray)
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16))
                    .foregroundStyle(Color.woteWhite)
            }
        }
    }
}

#Preview {
    WoteTabView()
}
