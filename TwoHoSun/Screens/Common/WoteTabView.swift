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
    @State private var selectedVoteCategoryType = VoteCategoryType.all
    @State private var isVoteCategoryButtonDidTap = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
                VStack(spacing: 0) {
                    if selection == .consider || selection == .review {
                        navigationBar
                    }
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
                }

                if isVoteCategoryButtonDidTap {
                    Color.black
                        .opacity(0.7)
                        .ignoresSafeArea()
                        .onTapGesture {
                            isVoteCategoryButtonDidTap = false
                        }
                    HStack(spacing: 0) {
                        voteCategoryButton
                        Spacer()
                        notificationButton
                            .hidden()
                        searchButton
                            .hidden()
                    }
                    .padding(.horizontal, 16)
                    voteCategoryMenu
                        .offset(x: 16, y: 40)
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
            ConsumptionConsiderationView(viewModel: ConsumptionConsiderationViewModel())
        case .review:
            Text("소비후기")
        case .myPage:
            Text("마이페이지")
        }
    }

    private var navigationBar: some View {
        HStack(spacing: 0) {
            voteCategoryButton
            Spacer()
            notificationButton
                .padding(.trailing, 8)
            searchButton
        }
        .padding(.horizontal, 16)
        .background(Color.background)
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

    private var voteCategoryMenu: some View {
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
        .frame(width: 131, height: 88)
        .font(.system(size: 14))
        .foregroundStyle(Color.woteWhite)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.disableGray)
        )
    }

    private var voteCategoryButton: some View {
        ZStack(alignment: .topLeading) {
            Button {
                isVoteCategoryButtonDidTap.toggle()
            } label: {
                HStack(spacing: 5) {
                    Text(selectedVoteCategoryType.title)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.white)
                    Image(systemName: "chevron.down")
                        .font(.system(size: 16))
                        .foregroundStyle(Color.subGray1)
                }
            }
        }
    }
}

#Preview {
    WoteTabView()
}
