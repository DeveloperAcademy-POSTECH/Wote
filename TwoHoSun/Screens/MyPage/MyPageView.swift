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
}

enum MyReviewCategoryType: String, CaseIterable, Hashable {
    case all = "모든 후기"
    case allSchool = "전체 학교 후기"
    case mySchool = "우리 학교 후기"
}

struct MyPageView: View {
    private var isTypeTestCompleted = false
    @State private var selectedMyPageListType = MyPageListType.myVote
    @State private var selectedMyVoteCategoryType = MyVoteCategoryType.all
    @State private var selectedMyReviewCategoryType = MyReviewCategoryType.all
    @State private var isMyVoteCategoryButtonDidTap = false
    @State private var isMyReviewCategoryButtonDidTap = false

    @Environment(AppLoginState.self) private var loginState
    @EnvironmentObject private var pathManger: NavigationManager

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                profileHeaderView
                    .padding(.top, 24)
                    .padding(.bottom, isTypeTestCompleted ? 24 : 0)
                if !isTypeTestCompleted {
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
                    .onChange(of: selectedMyPageListType) { _, _ in
                        isMyVoteCategoryButtonDidTap = false
                        isMyReviewCategoryButtonDidTap = false
                        proxy.scrollTo("myPageList", anchor: .top)
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
    }
}

extension MyPageView {

    private var profileHeaderView: some View {
        NavigationLink {
            ProfileSettingsView(viewType: .modfiy,
                                viewModel: ProfileSettingViewModel(appState: loginState))
        } label: {
            HStack {
                Circle()
                    .frame(width: 103, height: 103)
                    .foregroundStyle(.gray)
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 0) {
                        Text("김보람")
                            .font(.system(size: 20, weight: .medium))
                            .padding(.trailing, 12)
                        ConsumerTypeLabel(consumerType: .flexer, usage: .standard)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.subGray1)
                    }
                    Text("서현고등학교")
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
                    Text("0건")
                        .font(.system(size: 14))
                        .foregroundStyle(.white)
                    Spacer()
                    switch selectedMyPageListType {
                    case .myVote:
                        selectCategoryButton(selectedCategoryType: $selectedMyVoteCategoryType, isButtonTapped: $isMyVoteCategoryButtonDidTap)
                    case .myReview:
                        selectCategoryButton(selectedCategoryType: $selectedMyReviewCategoryType, isButtonTapped: $isMyReviewCategoryButtonDidTap)
                    }
                }
                .padding(.horizontal, 24)
                .overlay(
                        isMyVoteCategoryButtonDidTap ? 
                        categoryMenuView(categories: MyVoteCategoryType.allCases,
                                         selectedCategoryType: $selectedMyVoteCategoryType,
                                         isButtonTapped: $isMyVoteCategoryButtonDidTap)
                            .offset(x: -24, y: 30) : nil,
                        alignment: .topTrailing
                    )
                .overlay(
                        isMyReviewCategoryButtonDidTap ?
                        categoryMenuView(categories: MyReviewCategoryType.allCases,
                                         selectedCategoryType: $selectedMyReviewCategoryType,
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
                .foregroundStyle(type == selectedMyPageListType ? Color.lightBlue : Color.fontGray)
            Rectangle()
                .frame(width: 66, height: 2)
                .foregroundStyle(type == selectedMyPageListType ? Color.lightBlue : Color.clear)
        }
        .onTapGesture {
            selectedMyPageListType = type
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
        switch selectedMyPageListType {
        case .myVote:
            ForEach(0..<50) { _ in
                NavigationLink {
                    // TODO: - postId 알맞게 변경
//                    DetailView(postId: 0)
                } label: {
                    VStack(spacing: 0) {
                        VoteCardCell(cellType: .myVote,
                                     progressType: .end,
                                     voteResultType: .draw)
                        Divider()
                            .background(Color.dividerGray)
                            .padding(.horizontal, 8)
                    }
                }
            }
            .padding(.horizontal, 8)
//            NoVoteView()
//                .padding(.top, 52)
        case .myReview:
            ForEach(0..<30) { _ in
                NavigationLink {
                    ReviewDetailView()
                } label: {
                    VStack(spacing: 0) {
                        ReviewCardCell(cellType: .myReview, isPurchased: Bool.random())
                        Divider()
                            .background(Color.dividerGray)
                            .padding(.horizontal, 8)
                    }
                }
            }
            .padding(.horizontal, 8)
//            NoReviewView()
//                .padding(.top, 60)
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
