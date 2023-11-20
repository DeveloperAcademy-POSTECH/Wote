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
    @State private var isMyVoteCategoryButtonDidTap = false
    @State private var isMyReviewCategoryButtonDidTap = false
    @State var viewModel: MyPageViewModel
    @Binding var selectedVisibilityScope: VisibilityScopeType
    @AppStorage("haveConsumerType") var haveConsumerType: Bool = false
    @Environment(AppLoginState.self) private var loginState
    @EnvironmentObject private var pathManger: NavigationManager

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
                    .onAppear {
                        viewModel.fetchPosts()
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
        .onTapGesture {
            isMyVoteCategoryButtonDidTap = false
        }
        .onChange(of: viewModel.selectedMyVoteCategoryType) { _, _ in
            viewModel.fetchPosts()
        }
        .onChange(of: viewModel.selectedMyReviewCategoryType) { _, _ in
            viewModel.fetchPosts()
        }
    }
}

extension MyPageView {

    private var profileHeaderView: some View {
        NavigationLink {
            ProfileSettingsView(viewType: .modfiy, viewModel: ProfileSettingViewModel(appState: loginState), profileImage: viewModel.profile?.profileImage, nickname: viewModel.profile?.nickname, school: viewModel.profile?.school, consumerType: viewModel.profile?.consumerType)
        } label: {
            HStack(spacing: 14) {
                if let image = viewModel.profile?.profileImage {
                    ProfileImageView(imageURL: image)
                        .frame(width: 103, height: 103)
                } else {
                    Image("defaultProfile")
                        .resizable()
                        .frame(width: 103, height: 103)
                }
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 0) {
                        Text(viewModel.profile?.nickname ?? "")
                            .font(.system(size: 20, weight: .medium))
                            .padding(.trailing, 12)
                        ConsumerTypeLabel(consumerType: viewModel.profile?.consumerType ?? .adventurer, usage: .standard)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.subGray1)
                    }
                    Text(viewModel.profile?.school.schoolName ?? "")
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
                    Text("\(viewModel.posts.count)건")
                        .font(.system(size: 14))
                        .foregroundStyle(.white)
                    Spacer()
                    switch viewModel.selectedMyPageListType {
                    case .myVote:
                        selectCategoryButton(selectedCategoryType: $viewModel.selectedMyVoteCategoryType, isButtonTapped: $isMyVoteCategoryButtonDidTap)
                    case .myReview:
                        selectCategoryButton(selectedCategoryType: $viewModel.selectedMyReviewCategoryType, isButtonTapped: $isMyReviewCategoryButtonDidTap)
                    }
                }
                .padding(.horizontal, 24)
                .overlay(
                        isMyVoteCategoryButtonDidTap ? 
                        categoryMenuView(categories: MyVoteCategoryType.allCases,
                                         selectedCategoryType: $viewModel.selectedMyVoteCategoryType,
                                         isButtonTapped: $isMyVoteCategoryButtonDidTap)
                            .offset(x: -24, y: 30) : nil,
                        alignment: .topTrailing
                    )
                .overlay(
                        isMyReviewCategoryButtonDidTap ?
                        categoryMenuView(categories: MyReviewCategoryType.allCases,
                                         selectedCategoryType: $viewModel.selectedMyReviewCategoryType,
                                         isButtonTapped: $isMyReviewCategoryButtonDidTap)
                            .offset(x: -24, y: 30) : nil,
                        alignment: .topTrailing
                )
                Divider()
                    .background(Color.dividerGray)
                    .padding(.horizontal, 16)
            }
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
            ForEach(Array(zip(viewModel.posts.indices, viewModel.posts)), id: \.0) { index, post in
                NavigationLink {
                    Text("DetailView")
                } label: {
                    VStack(spacing: 0) {
                        VoteCardCell(cellType: .myVote,
                                     progressType: .end,
                                     voteResultType: .draw,
                                     post: post)
                        Divider()
                            .background(Color.dividerGray)
                            .padding(.horizontal, 8)
                    }
                }
                .onAppear {
                    if index == viewModel.posts.count - 4 {
                        viewModel.fetchMorePosts()
                    }
                }
            }
            .padding(.horizontal, 8)
        case .myReview:
            ForEach(Array(zip(viewModel.posts.indices, viewModel.posts)), id: \.0) { index, post in
                NavigationLink {
                    ReviewDetailView()
                } label: {
                    VStack(spacing: 0) {
                        ReviewCardCell(cellType: .myReview, post: post)
                        Divider()
                            .background(Color.dividerGray)
                            .padding(.horizontal, 8)
                    }
                }
                .onAppear {
                    if index == viewModel.posts.count - 4 {
                        viewModel.fetchMorePosts()
                    }
                }
            }
            .padding(.horizontal, 8)
        }
    }

    private func categoryMenuView<T: RawRepresentable & CaseIterable & Hashable>
    (categories: [T], selectedCategoryType: Binding<T>, isButtonTapped: Binding<Bool>)
    -> some View where T.RawValue == String {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(categories, id: \.self) { category in
                categoryButton(for: category) {
                    selectedCategoryType.wrappedValue = category
                    isButtonTapped.wrappedValue.toggle()
                    // TODO: - fetch data as each filter
                }
                if category != categories.last {
                    Divider()
                        .background(Color.gray300)
                }
            }
        }
        .frame(width: 131, height: 44 * CGFloat(categories.count))
        .font(.system(size: 14))
        .foregroundStyle(Color.woteWhite)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.disableGray)
        )
    }

    private func categoryButton<T: RawRepresentable>(for category: T, _ action: @escaping () -> Void) -> some View where T.RawValue == String {
        Button {
            action()
        } label: {
            Text(category.rawValue)
                .frame(alignment: .leading)
                .padding(.leading, 15)
                .padding(.top, 12)
                .padding(.bottom, 14)
        }
    }
}
