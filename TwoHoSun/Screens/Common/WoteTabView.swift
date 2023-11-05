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
            return "전국 투표"
        case .mySchool:
            return "OO고등학교 투표"
        }
    }
}

struct WoteTabView: View {
    @State private var selection = WoteTabType.consider
    @State private var isVoteCategoryButtonDidTap = false
    @State private var selectedVoteCategoryType = VoteCategoryType.all

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
            .tint(Color.accentBlue)
            .onAppear {
                UITabBar.appearance().unselectedItemTintColor = .gray100
                UITabBar.appearance().backgroundColor = .background
            }
            .navigationTitle(selection.tabTitle)
            .toolbar(.hidden, for: .navigationBar)
        }
        .tint(Color.accentBlue)
    }
}

extension WoteTabView {

    @ViewBuilder
    private func tabDestinationView(for tab: WoteTabType) -> some View {
        switch tab {
        case .consider:
            ConsumptionConsiderationView(viewModel: MainVoteViewModel())
        case .review:
            Text("소비후기")
        case .myPage:
            Text("마이페이지")
        }
    }

    private var voteCategoryButton: some View {
        ZStack(alignment: .bottom) {
            Button {
                isVoteCategoryButtonDidTap.toggle()
            } label: {
                HStack(spacing: 5) {
                    Text(selectedVoteCategoryType.title)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.white)
                    Image(systemName: "chevron.down")
                        .font(.system(size: 16))
                        .foregroundStyle(Color.descriptionGray)
                }
            }

            if isVoteCategoryButtonDidTap {
                VStack(alignment: .leading, spacing: 0) {
                    Button {
                        selectedVoteCategoryType = .all
                        isVoteCategoryButtonDidTap = false
                    } label: {
                        Text("전국 투표")
                            .padding(.leading, 15)
                            .padding(.top, 14)
                            .padding(.bottom, 12)
                    }
                    Divider()
                        .background(Color.gray300)
                    Button {
                        selectedVoteCategoryType = .mySchool
                        isVoteCategoryButtonDidTap = false
                    } label: {
                        Text("우리 학교 투표")
                            .padding(.leading, 15)
                            .padding(.top, 12)
                            .padding(.bottom, 14)
                    }
                }
                .font(.system(size: 14))
                .foregroundStyle(Color.woteWhite)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.disableGray)
                        .strokeBorder(Color.gray300, lineWidth: 1)
                )
                .offset(y: 70)
            }
        }
    }
}

#Preview {
    WoteTabView()
}
