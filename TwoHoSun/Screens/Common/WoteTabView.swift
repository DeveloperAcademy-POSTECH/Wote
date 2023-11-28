//
//  WoteTabType.swift
//  TwoHoSun
//
//  Created by 235 on 10/18/23.
//

import SwiftUI

struct WoteTabView: View {
    @State private var selection = WoteTabType.consider
    @State private var visibilityScope = VisibilityScopeType.global
    @State private var isVoteCategoryButtonDidTap = false
    @Environment(AppLoginState.self) private var loginStateManager
    @ObservedObject var notiManager: DataController
    @State private var tabScrollHandler = WoteTabHandler()

    var body: some View {
        @Bindable var navigationPath = loginStateManager.serviceRoot.navigationManager
        NavigationStack(path: $navigationPath.navigatePath) {
            ZStack(alignment: .topLeading) {
                VStack(spacing: 0) {
                    navigationBar
                    TabView(selection: $tabScrollHandler.selectedTab) {
                        ForEach(WoteTabType.allCases, id: \.self) { tab in
                            tabDestinationView(for: tab)
                                .tabItem {
                                    Image(tabScrollHandler.selectedTab == tab ?
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
            .navigationDestination(for: AllNavigation.self) { destination in
                switch destination {
                case .profileSettingView(let viewType):
                    ProfileSettingsView(viewType: viewType,
                                        viewModel: ProfileSettingViewModel(appState: loginStateManager))
                case .considerationView:
                    ConsiderationView(visibilityScope: $visibilityScope,
                                      scrollToTop: $tabScrollHandler.scrollToTop,
                                      viewModel: ConsiderationViewModel(appLoginState: loginStateManager))
                case .detailView(let postId,
                                 let showDetailComments,
                                 let isShowingItems):
                    DetailView(viewModel: DetailViewModel(appLoginState: loginStateManager),
                               isShowingItems: isShowingItems,
                               postId: postId,
                               directComments: showDetailComments
                    )
                case .makeVoteView:
                    VoteWriteView(viewModel: VoteWriteViewModel(visibilityScope: visibilityScope, 
                                                                apiManager: loginStateManager.serviceRoot.apimanager), 
                                  tabselection: $tabScrollHandler.selectedTab)
                case .testIntroView:
                    TypeTestIntroView()
                        .toolbar(.hidden, for: .navigationBar)
                case .testView:
                    TypeTestView(viewModel: TypeTestViewModel(apiManager: loginStateManager.serviceRoot.apimanager))
                case .reviewView:
                    ReviewView(visibilityScope: $visibilityScope,
                               viewModel: ReviewTabViewModel(loginState: loginStateManager))
                case .writeReiview:
                    Text("아직")
                case .settingView:
                    SettingView(viewModel: SettingViewModel(loginStateManager: loginStateManager))
                case .mypageView:
                    MyPageView(viewModel: MyPageViewModel(loginState: loginStateManager),
                               selectedVisibilityScope: $visibilityScope)
                case .searchView:
                    SearchView(viewModel: SearchViewModel(apiManager: loginStateManager.serviceRoot.apimanager,
                                                          selectedVisibilityScope: visibilityScope))
                case .reviewDetailView(let postId, 
                                       let reviewId,
                                       let isShowDetailComments,
                                       let isShowingItems):
                    ReviewDetailView(viewModel: ReviewDetailViewModel(loginState: loginStateManager),
                                     isShowingItems: isShowingItems,
                                     postId: postId,
                                     reviewId: reviewId,
                                     directComments: isShowDetailComments
                    )
                case .reviewWriteView(let post):
                    ReviewWriteView(viewModel: ReviewWriteViewModel(post: post,
                                                                    apiManager: loginStateManager.serviceRoot.apimanager))
                case .notiView:
                    NotificationView( viewModel: notiManager)
                }
            }
        }
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            UITabBar.appearance().backgroundColor = .background
            UITabBar.appearance().unselectedItemTintColor = .gray400
            UITabBar.appearance().standardAppearance = appearance
        }
        .navigationTitle(tabScrollHandler.selectedTab.tabTitle)
        .toolbar(.hidden, for: .navigationBar)
        .tint(Color.accentBlue)
        
    }
}

extension WoteTabView {

    @ViewBuilder
    private func tabDestinationView(for tab: WoteTabType) -> some View {
        switch tab {
        case .consider:
            ConsiderationView(visibilityScope: $visibilityScope, 
                              scrollToTop: $tabScrollHandler.scrollToTop,
                              viewModel: ConsiderationViewModel(appLoginState: loginStateManager))
        case .review:
            ReviewView(visibilityScope: $visibilityScope,
                       viewModel: ReviewTabViewModel(loginState: loginStateManager))
        case .myPage:
            MyPageView(viewModel: MyPageViewModel(loginState: loginStateManager),
                       selectedVisibilityScope: $visibilityScope)
        }
    }

    @ViewBuilder
    private var navigationBar: some View {
        switch tabScrollHandler.selectedTab {
        case .consider, .review:
            HStack(spacing: 0) {
                voteCategoryButton
                Spacer()
                notificationButton
                    .padding(.trailing, 8)
                searchButton
            }
            .padding(.top, 2)
            .padding(.bottom, 9)
            .padding(.horizontal, 16)
            .background(Color.background)
        case .myPage:
            HStack {
                Image("imgWoteLogo")
                Spacer()
                settingButton
            }
            .padding(.top, 2)
            .padding(.bottom, 9)
            .padding(.horizontal, 16)
            .background(Color.background)
        }
    }

    private var notificationButton: some View {
        Button {
            loginStateManager.serviceRoot.navigationManager.navigate(.notiView)
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
        Button {
            loginStateManager.serviceRoot.navigationManager.navigate(.searchView)
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

    private var settingButton: some View {
        Button {
            loginStateManager.serviceRoot.navigationManager.navigate(.settingView)
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .frame(width: 39, height: 39)
                    .foregroundStyle(Color.disableGray)
                Image(systemName: "gear")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.woteWhite)
            }
        }
    }

    private var voteCategoryMenu: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                visibilityScope = .global
                isVoteCategoryButtonDidTap = false
            } label: {
                Text("전국 투표")
                    .padding(.leading, 15)
                    .padding(.top, 14)
                    .padding(.bottom, 12)
            }
            .contentShape(.rect)
            Divider()
                .background(Color.gray300)
            Button {
                visibilityScope = .school
                isVoteCategoryButtonDidTap = false
            } label: {
                Text("우리 학교 투표")
                    .padding(.leading, 15)
                    .padding(.top, 12)
                    .padding(.bottom, 14)
            }
            .contentShape(.rect)
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
                    Text(visibilityScope.title)
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
