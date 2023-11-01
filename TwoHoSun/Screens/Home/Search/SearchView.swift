//
//  SearchView.swift
//  TwoHoSun
//
//  Created by 관식 on 10/21/23.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.dismiss) private var dismiss: DismissAction
    @State private var searchText = ""
    @State private var dismissTabBar: Bool = false
    @State private var hasResult: Bool = false
    private let viewModel = SearchViewModel()

    var body: some View {
        ZStack(alignment: .top) {
            Color.background
            VStack(spacing: 0) {
                searchField
                HStack {
                    recentSearchLabel
                    Spacer()
                    deleteAllButton
                }
                .padding(.top, 32)
                recentSearchWords
                    .padding(.top, 16)
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
        }
        .ignoresSafeArea(edges: .bottom)
        .toolbarBackground(Color.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("통합검색")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(.white)
            }
        }
    }
}

extension SearchView {
    
    private var searchField: some View {
        TextField("search",
                  text: $searchText,
                  prompt: Text("원하는 소비항목을 검색해보세요.")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(Color.placeholderGray))
            .font(.system(size: 16, weight: .medium))
            .foregroundStyle(.white) // TODO: change text color when textField is active
            .padding(EdgeInsets(top: 13, leading: 16, bottom: 12, trailing: 0))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color.darkBlue, lineWidth: 1)
            }
            .onSubmit {
                // TODO: screen transition to result
                viewModel.addRecentSearch(searchWord: searchText)
                searchText.removeAll()
            }
            .tint(Color.placeholderGray)
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
            deleteButton(index)
        }
        .padding(.vertical, 8)
    }

    private func deleteButton(_ index: Int) -> some View {
        Button {
            viewModel.removeRecentSearch(at: index)
        } label: {
            Image(systemName: "xmark")
                .font(.system(size: 14))
                .foregroundStyle(Color.darkGray)
        }
    }

    private var recentSearchWords: some View {
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

    // TODO: - set search result layout
//    private var recentSearchView: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            HStack {
//                Text("최근 검색어")
//                    .foregroundStyle(.gray)
//                    .font(.system(size: 14))
//                Spacer()
//            }
//            WrappingHStack(horizontalSpacing: 8) {
//                ForEach(Array(zip(viewModel.searchWords.indices, viewModel.searchWords)), id: \.0) { index, word in
//                    Button {
////                        viewModel.searchWords.remove(at: index)
////                        viewModel.searchedDatas.removeAll()
//                        viewModel.remove(at: index)
//                    } label: {
//                        HStack(spacing: 5) {
//                            Text(word)
//                                .font(.system(size: 14))
//                            Image(systemName: "xmark")
//                                .font(.system(size: 12))
//                        }
//                        .foregroundStyle(.gray)
//                        .fixedSize()
//                        .frame(height: 28)
//                        .padding(.horizontal, 10)
//                        .background(
//                            Capsule()
//                                .stroke(Color.gray, lineWidth: 1)
//                                .foregroundStyle(.white)
//                        )
//                    }
//                }
//            }
//        }
//        .padding(.horizontal, 14)
//        .padding(.top, 16)
//    }

    // TODO: - change emptyResultView Layout
    private var emptyResultView: some View {
        VStack(spacing: 20) {
            Rectangle()
                .frame(width: 90, height: 90)
            Text("검색 결과가 없습니다.")
                .font(.system(size: 20, weight: .medium))
        }
        .foregroundStyle(.gray)
    }
}

#Preview {
    NavigationStack {
        SearchView()
    }
}
