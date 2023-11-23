//
//  SearchView.swift
//  TwoHoSun
//
//  Created by 관식 on 10/21/23.
//

import SwiftUI

struct SearchView: View {
    @Environment(AppLoginState.self) private var loginState
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var hasResult: Bool = false
    @State private var isSearchResultViewShown = false
    @State private var selectedFilterType = PostStatus.active
    @State private var searchTextFieldState = SearchTextFieldState.inactive
    @FocusState private var isFocused: Bool
    @StateObject var viewModel: SearchViewModel
    @State private var isOpen = true

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            if viewModel.isFetching {
                ProgressView()
            }
            if viewModel.showEmptyView {
                emptyResultView
            }
            ZStack(alignment: .top) {
                VStack( spacing: 0) {
                    HStack(spacing: 8) {
                        backButton
                        searchField
                            .padding(.horizontal, 8)
                    }
                    .padding(.horizontal, 8)
                    VStack(alignment: .leading) {
                        if isFocused {
                            HStack {
                                recentSearchLabel
                                Spacer()
                                deleteAllButton
                            }
                            recentSearchView
                        } else {
                            searchFilterView
                                .padding(.bottom, 24)
                            switch selectedFilterType {
                            case .review:
                                reviewSearchedResult
                            default:
                                voteSearchedResult
                            }
                        }
                    }
                    .padding(.top, 24)
                    .padding(.horizontal, 16)
                }
            }
        }
        .onAppear {
            isFocused = isOpen
        }
        .onDisappear {
            isOpen = false
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

extension SearchView {

    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(Color.accentBlue)
        }
    }

    private var searchField: some View {
        HStack {
            TextField("search",
                      text: $searchText,
                      prompt: Text("원하는 소비항목을 검색해보세요.")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color.placeholderGray))
            .focused($isFocused)
            .font(.system(size: 14, weight: .medium))
            .foregroundStyle(searchTextFieldState.foregroundColor)
            .tint(Color.placeholderGray)
            .frame(height: 32)
            .padding(.leading, 16)
            .onChange(of: isFocused) { _, isFocused in
                if isFocused {
                    searchTextFieldState = .active
                    viewModel.showEmptyView = false
                }
            }
            .onSubmit {
                searchTextFieldState = .submitted
                viewModel.fetchSearchedData(keyword: searchText, reset: true, save: searchText.isEmpty ? false : true)
                isSearchResultViewShown = true
            }
            Spacer()
            Button {
                searchText.removeAll()
                searchTextFieldState = .active
                isFocused = true
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.subGray2)
                    .padding(.trailing, 16)
            }
        }
        .background(searchTextFieldState.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay {
            if searchTextFieldState == .active {
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(searchTextFieldState.strokeColor, lineWidth: 1)
                    .blur(radius: 3)
                    .shadow(color: Color.shadowBlue, radius: 2)
            }
        }
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(searchTextFieldState.strokeColor, lineWidth: 1)
        }
        .frame(height: 32)
    }

    private var recentSearchLabel: some View {
        Text("최근 검색")
            .font(.system(size: 14, weight: .medium))
            .foregroundStyle(.white)
    }

    private var deleteAllButton: some View {
        Button {
            viewModel.removeAllRecentSearch()
        } label: {
            Text("전체 삭제")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color.darkGray)
        }
    }

    private func recentSearchCell(word: String, index: Int) -> some View {
        HStack(spacing: 0) {
            HStack {
                ZStack {
                    Circle()
                        .strokeBorder(Color.purpleStroke, lineWidth: 1)
                        .frame(width: 28, height: 28)
                        .foregroundStyle(.clear)
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.system(size: 18, weight: .light))
                        .foregroundStyle(Color.darkGray)
                }
                Text(word)
                    .font(.system(size: 16))
                    .foregroundStyle(Color.woteWhite)
                    .padding(.leading, 16)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            .background(Color.background.opacity(0.01))
            .onTapGesture {
                searchText = word
                viewModel.fetchSearchedData(keyword: word)
                isFocused.toggle()
            }
            Image(systemName: "xmark")
                .font(.system(size: 14))
                .foregroundStyle(Color.darkGray)
                .padding(15)
                .onTapGesture {
                    viewModel.removeRecentSearch(at: index)
                }
        }
    }

    private var recentSearchView: some View {
        List {
            ForEach(viewModel.searchHistory.indices, id: \.self) { index in
                recentSearchCell(word: viewModel.searchHistory[index], index: index)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
    }

    private var searchFilterView: some View {
        HStack(spacing: 8) {
            ForEach(PostStatus.allCases, id: \.self) { filter in
                FilterButton(title: filter.filterTitle,
                             isSelected: viewModel.selectedFilterType == filter) {
                    viewModel.selectedFilterType = filter
                }
            }
        }
    }

    private var reviewSearchedResult: some View {
        ScrollView {
            ScrollViewReader { proxy in
                LazyVStack {
                    ForEach(Array(viewModel.searchedDatas.enumerated()), id: \.offset) { index, data in
                        Button {
                            loginState.serviceRoot.navigationManager.navigate(.reviewDetailView(postId: nil, reviewId: data.id))
                        } label: {
                            VoteCardCell(cellType: .standard,
                                         progressType: .closed,
                                         data: data)
                        }
                        .onAppear {
                            if index == viewModel.searchedDatas.count - 4 {
                                viewModel.fetchSearchedData(keyword: searchText)
                            }
                        }
                    }
                    .id("searchResult")
                    .onChange(of: viewModel.selectedFilterType) { _, _ in
                        viewModel.fetchSearchedData(keyword: searchText, reset: true)
                        proxy.scrollTo("searchResult", anchor: .top)
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
    }

    private var voteSearchedResult: some View {
        ScrollView {
            ScrollViewReader { proxy in
                LazyVStack {
                    ForEach(Array(viewModel.searchedDatas.enumerated()), id: \.offset) { index, data in
                        Button {
                            loginState.serviceRoot.navigationManager.navigate(.detailView(postId: data.id))
                        } label: {
                            VoteCardCell(cellType: .standard,
                                         progressType: .closed,
                                         data: data)
                        }
                        .onAppear {
                            if index == viewModel.searchedDatas.count - 4 {
                                viewModel.fetchSearchedData(keyword: searchText)
                            }
                        }
                    }
                    .id("searchResult")
                    .onChange(of: viewModel.selectedFilterType) { _, _ in
                        viewModel.fetchSearchedData(keyword: searchText, reset: true)
                        proxy.scrollTo("searchResult", anchor: .top)
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
    }
    
    private var emptyResultView: some View {
        VStack(spacing: 20) {
            Image("imgNoResult")
            Text("검색 결과가 없습니다.")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(Color.subGray1)
        }
    }
}
