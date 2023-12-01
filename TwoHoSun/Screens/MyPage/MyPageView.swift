//
//  MyPageView.swift
//  TwoHoSun
//
//  Created by 김민 on 11/11/23.
//

import SwiftUI

enum MyPageListType {
    case myVote, myReview

    var title: String {
        switch self {
        case .myVote:
            return "나의 투표"
        case .myReview:
            return "나의 후기"
        }
    }
}

enum MyVoteCategoryType: String, CaseIterable, Hashable {
    case all = "모든 투표"
    case allSchool = "전체 학교 투표"
    case mySchool = "우리 학교 투표"
    case progressing = "진행중인 투표"
    case end = "종료된 투표"
    
    var parameter: String {
        switch self {
        case .all:
            return "ALL_VOTES"
        case .allSchool:
            return "GLOBAL_VOTES"
        case .mySchool:
            return "SCHOOL_VOTES"
        case .progressing:
            return "ACTIVE_VOTES"
        case .end:
            return "CLOSED_VOTES"
        }
    }
}

enum MyReviewCategoryType: String, CaseIterable, Hashable {
    case all = "모든 후기"
    case allSchool = "전체 학교 후기"
    case mySchool = "우리 학교 후기"
    
    var parameter: String {
        switch self {
        case .all:
            return "ALL"
        case .allSchool:
            return "GLOBAL"
        case .mySchool:
            return "SCHOOL"
        }
    }
}

struct MyPageView: View {
    @State private var didFinishSetup = false
    @State private var isMyVoteCategoryButtonDidTap = false
    @State private var isMyReviewCategoryButtonDidTap = false
    @State var viewModel: MyPageViewModel
    @Binding var selectedVisibilityScope: VisibilityScopeType
    @AppStorage("haveConsumerType") var haveConsumerType: Bool = false
    @Environment(AppLoginState.self) private var loginStateManager

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                profileHeaderView
                    .padding(.top, 24)
                    .padding(.bottom, haveConsumerType ? 24 : 0)
                if !haveConsumerType {
                    GoToTypeTestButton()
                        .padding(.horizontal, 24)
                        .padding(.top, 24)
                }
                ScrollViewReader { proxy in
                    LazyVStack(pinnedViews: .sectionHeaders) {
                        Section {
                            myPageListTypeView
                        } header: {
                            sectionHeaderView
                        }
                        .id("myPageList")
                    }
                    .onChange(of: viewModel.selectedMyPageListType) { _, _ in
                        isMyVoteCategoryButtonDidTap = false
                        isMyReviewCategoryButtonDidTap = false
                        proxy.scrollTo("myPageList", anchor: .top)
                        viewModel.fetchPosts()
                    }
                }
            }
        }
        .toolbarBackground(Color.background, for: .tabBar)
        .scrollIndicators(.hidden)
        .background(Color.background)
        .onAppear {
            if !didFinishSetup {
                viewModel.fetchPosts()
                didFinishSetup = true
            }
        }
        .onTapGesture {
            isMyVoteCategoryButtonDidTap = false
        }
        .onChange(of: viewModel.selectedMyVoteCategoryType) { _, _ in
            viewModel.fetchPosts()
        }
        .onChange(of: viewModel.selectedMyReviewCategoryType) { _, _ in
            viewModel.fetchPosts()
        }
        .refreshable {
            viewModel.fetchPosts()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.voteStateUpdated)) { _ in
            viewModel.fetchPosts()
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(NSNotification.voteStateUpdated)
        }
    }
}

extension MyPageView {

    private var profileHeaderView: some View {
        Button {
            loginStateManager.serviceRoot.navigationManager.navigate(.profileSettingView(type: .modfiy))
        } label: {
            HStack(spacing: 14) {
                if let image = loginStateManager.serviceRoot.memberManager.profile?.profileImage {
                    ProfileImageView(imageURL: image)
                        .frame(width: 103, height: 103)
                } else {
                    Image("defaultProfile")
                        .resizable()
                        .frame(width: 103, height: 103)
                }
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 0) {
                        Text(loginStateManager.serviceRoot.memberManager.profile?.nickname ?? "")
                            .font(.system(size: 20, weight: .medium))
                            .padding(.trailing, 12)
                        if let consumerType = loginStateManager.serviceRoot.memberManager.profile?.consumerType {
                            ConsumerTypeLabel(consumerType: consumerType, usage: .standard)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.subGray1)
                    }
                    Text(loginStateManager.serviceRoot.memberManager.profile?.school.schoolName ?? "")
                        .font(.system(size: 14))
                }
                .foregroundStyle(.white)
            }
            .padding(.leading, 24)
            .padding(.trailing, 16)
        }
    }

    private var sectionHeaderView: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 16) {
                HStack(spacing: 19) {
                    myPageListTypeButton(for: .myVote)
                    myPageListTypeButton(for: .myReview)
                    Spacer()
                }
                .padding(.bottom, 9)
                .padding(.horizontal, 24)
                HStack {
                    Text("\(viewModel.total)건")
                        .font(.system(size: 14))
                        .foregroundStyle(.white)
                    Spacer()
                    switch viewModel.selectedMyPageListType {
                    case .myVote:
                        selectCategoryButton(selectedCategoryType: $viewModel.selectedMyVoteCategoryType,
                                             isButtonTapped: $isMyVoteCategoryButtonDidTap)
                    case .myReview:
                        selectCategoryButton(selectedCategoryType: $viewModel.selectedMyReviewCategoryType,
                                            isButtonTapped: $isMyReviewCategoryButtonDidTap)
                    }
                }
                .padding(.horizontal, 24)
                Divider()
                    .background(Color.dividerGray)
                    .padding(.horizontal, 16)
            }
            .overlay(
                isMyVoteCategoryButtonDidTap ? myVoteCategoryMenu
                                                    .offset(x: -24, y: 85) : nil, alignment: .topTrailing
            )
            .overlay(
                isMyReviewCategoryButtonDidTap ? myReviewCategoryMenu
                                                    .offset(x: -24, y: 85) : nil, alignment: .topTrailing
            )
            .padding(.top, 23)
            .background(Color.background)
        }
    }

    private func myPageListTypeButton(for type: MyPageListType) -> some View {
        VStack(spacing: 10) {
            Text(type.title)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(type == viewModel.selectedMyPageListType ? Color.lightBlue : Color.fontGray)
            Rectangle()
                .frame(width: 66, height: 2)
                .foregroundStyle(type == viewModel.selectedMyPageListType ? Color.lightBlue : Color.clear)
        }
        .onTapGesture {
            viewModel.selectedMyPageListType = type
        }
    }

    private func selectCategoryButton<T: RawRepresentable>
    (selectedCategoryType: Binding<T>, isButtonTapped: Binding<Bool>) -> some View where T.RawValue == String {
        Button {
            isButtonTapped.wrappedValue.toggle()
        } label: {
            HStack(spacing: 5) {
                Text(selectedCategoryType.wrappedValue.rawValue)
                    .font(.system(size: 12, weight: .light))
                    .foregroundStyle(.white)
                Image(systemName: "chevron.down")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.subGray5)
            }
        }
    }

    @ViewBuilder
    private var myPageListTypeView: some View {
        switch viewModel.selectedMyPageListType {
        case .myVote:
            let myPosts = loginStateManager.appData.postManager.myPosts
            ForEach(Array(zip(myPosts.indices, myPosts)), id: \.0) { index, post in
                Button {
                    loginStateManager.serviceRoot.navigationManager.navigate(.detailView(postId: post.id))
                } label: {
                    VStack(spacing: 0) {
                        VoteCardCell(cellType: .myVote,
                                      progressType: PostStatus(rawValue: post.postStatus) ?? .closed,
                                      data: post)
                        Divider()
                            .background(Color.dividerGray)
                            .padding(.horizontal, 8)
                    }
                }
                .onAppear {
                    if index == myPosts.count - 4 {
                        viewModel.fetchMorePosts()
                    }
                }
            }
            .padding(.horizontal, 8)
        case .myReview:
            let myReviews = loginStateManager.appData.reviewManager.myReviews
            ForEach(Array(zip(myReviews.indices, myReviews)), id: \.0) { index, data in
                Button {
                    loginStateManager.serviceRoot.navigationManager.navigate(.reviewDetailView(postId: nil,
                                                                                               reviewId: data.id))
                } label: {
                    VStack(spacing: 0) {
                        ReviewCardCell(cellType: .myReview,
                                       data: data)
                        Divider()
                            .background(Color.dividerGray)
                            .padding(.horizontal, 8)
                    }
                    .onAppear {
                        if index == myReviews.count - 4 {
                            viewModel.fetchMorePosts()
                        }
                    }
                }
                .padding(.horizontal, 8)
            }
        }
    }

    private var myVoteCategoryMenu: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(MyVoteCategoryType.allCases, id: \.self) { category in
                categoryButton(for: category) {
                    viewModel.selectedMyVoteCategoryType = category
                    isMyVoteCategoryButtonDidTap.toggle()
                }
                Divider()
                    .background(Color.gray300)
                    .opacity(category != MyVoteCategoryType.allCases.last ? 1 : 0)
            }
        }
        .frame(width: 131, height: 44 * CGFloat(MyVoteCategoryType.allCases.count))
        .font(.system(size: 14))
        .foregroundStyle(Color.woteWhite)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.disableGray)
        )
    }

    private var myReviewCategoryMenu: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(MyReviewCategoryType.allCases, id: \.self) { category in
                categoryButton(for: category) {
                    viewModel.selectedMyReviewCategoryType = category
                    isMyReviewCategoryButtonDidTap.toggle()
                }
                Divider()
                    .background(Color.gray300)
                    .opacity(category != MyReviewCategoryType.allCases.last ? 1 : 0)
            }
        }
        .frame(width: 131, height: 44 * CGFloat(MyReviewCategoryType.allCases.count))
        .font(.system(size: 14))
        .foregroundStyle(Color.woteWhite)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.disableGray)
        )
    }

    private func categoryButton<T: RawRepresentable>(for category: T, _ action: @escaping () -> Void)
        -> some View where T.RawValue == String {
        Button {
            action()
        } label: {
            Text(category.rawValue)
                .padding(.leading, 15)
                .padding(.top, 14)
                .padding(.bottom, 12)
        }
    }
}
