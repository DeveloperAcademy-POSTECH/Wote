//
//  SearchView.swift
//  TwoHoSun
//
//  Created by 관식 on 10/21/23.
//

import SwiftUI

enum SearchFilterType: Int, CaseIterable {
    case progressing, end, review

    var filterTitle: String {
        switch self {
        case .progressing:
            return "진행중인 투표"
        case .end:
            return "종료된 투표"
        case .review:
            return "후기"
        }
    }
}

struct SearchView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var hasResult: Bool = false
    @State private var isSearchResultViewShown = true
    @State private var searchFilterType = SearchFilterType.progressing
    private let viewModel = SearchViewModel()

    var body: some View {
        ZStack(alignment: .top) {
            Color.background
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 0) {
                if isSearchResultViewShown {
                    searchFilterView
                    searchResultView
                        .padding(.top, 24)
                } else {
                    HStack {
                        recentSearchLabel
                        Spacer()
                        deleteAllButton
                    }
                    recentSearchView
                }
            }
            .padding(.top, 24)
            .padding(.horizontal, 16)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                backButton
            }
            ToolbarItem(placement: .principal) {
                searchField
            }
        }
    }
}

extension SearchView {

    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .font(.system(size: 20, weight: .medium))
        }
    }

    private var searchField: some View {
        HStack {
            TextField("search",
                      text: $searchText,
                      prompt: Text("원하는 소비항목을 검색해보세요.")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(Color.placeholderGray))
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.white)
                .tint(Color.placeholderGray)
                .padding(.leading, 16)
                .onSubmit {
                    // TODO: screen transition to result
                    isSearchResultViewShown = true
                    viewModel.addRecentSearch(searchWord: searchText)
                }
            Spacer()
            Button {
                searchText.removeAll()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.subGray2)
                    .padding(.trailing, 4)
            }
        }
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color.darkBlue, lineWidth: 1)
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
            Spacer()
            Button {
                viewModel.removeRecentSearch(at: index)
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.darkGray)
            }
        }
        .padding(.vertical, 8)
    }

    private var recentSearchView: some View {
        List {
            ForEach(viewModel.searchWords.indices, id: \.self) { index in
                recentSearchCell(word: viewModel.searchWords[index], index: index)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
    }

    private var searchFilterView: some View {
        HStack(spacing: 8) {
            ForEach(SearchFilterType.allCases, id: \.self) { filter in
                Button {
                    searchFilterType = filter
                } label: {
                    Text(filter.filterTitle)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(searchFilterType == filter ? Color.white : Color.gray100)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(searchFilterType == filter ? Color.lightBlue : Color.disableGray)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
    }

    private var searchVoteResultCell: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(spacing: 8) {
                Circle()
                    .frame(width: 32, height: 32)
                    .foregroundStyle(.gray)
                Text("얄루")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                Spacer()
                Text("소비성향")
                    .font(.system(size: 14))
                    .foregroundStyle(.white)
            }
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("ACG 마운틴 플라이 살까 말까?sdffdsfsdfsdf")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                    Text("어쩌고저쩌고50자미만임~~asdfasadsafsdadsf")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .padding(.bottom, 9)
                    HStack(spacing: 0) {
                        Text("161,100원 · 64명 투표 · ")
                        Image(systemName: "message")
                        Text("245명")
                    }
                    .font(.system(size: 14))
                    .foregroundStyle(Color.gray100)
                }
                Spacer()
                Rectangle()
                    .frame(width: 66, height: 66)
                    .foregroundStyle(.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
        .background(Color.disableGray)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var searchResultView: some View {
        List {
            switch searchFilterType {
            case .review:
                // TODO: - create review search result layout
                Text("review cell")
                    .foregroundStyle(.pink)
            default:
                ForEach(0..<5) { _ in
                    searchVoteResultCell
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0))
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
    }

    private var emptyResultView: some View {
        VStack(spacing: 20) {
            Image("imgNoResult")
            Text("검색 결과가 없습니다.")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(Color.descriptionGray)
        }
    }
}

#Preview {
    NavigationStack {
        SearchView()
    }
}
