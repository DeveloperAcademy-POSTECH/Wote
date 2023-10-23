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
    @State private var searchWords: [String] = []
    @State private var dismissTabBar: Bool = false
    @State private var hasResult: Bool = false
    @State private var hasRecommendation: Bool = false
    @State private var hasRecentSearch: Bool = true
    private let viewModel = SearchViewModel()

    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .frame(height: 1)
                .foregroundStyle(hasResult ? .clear : .black)

            if hasResult {
                if viewModel.searchedDatas.isEmpty {
                    Spacer()
                    emptyResultView
                } else {
                    ScrollView {
                        ForEach(viewModel.searchedDatas) { data in
                            MainCellView(postData: data)
                        }
                    }
                }
            } else {
                recentSearchView
            }

            Spacer()
        }
        .onChange(of: searchWords) {
            if searchWords.isEmpty {
                hasRecentSearch = false
            }
        }
        .onAppear {
            if searchWords.isEmpty {
                hasRecentSearch = false
            }
        }
        .padding(.horizontal, 12)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                backButton
            }
            ToolbarItem(placement: .principal) {
                searchField
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar(dismissTabBar || hasResult ? .visible : .hidden, for: .tabBar)
    }
}

extension SearchView {
    private var backButton: some View {
        Button {
            dismissTabBar.toggle()
            dismiss()
        } label: {
            Image(systemName: "chevron.backward")
                .font(.system(size: 18))
                .foregroundStyle(.gray)
        }
    }
    
    private var searchField: some View {
        ZStack(alignment: .trailing) {
            TextField("원하는 소비항목을 검색해보세요.", text: $searchText)
                .font(.system(size: 14))
                .frame(height: 30)
                .padding(.leading, 12)
                .background(
                    hasResult ? Color(UIColor.secondarySystemBackground) : .white
                )
                .clipShape(.capsule)
                .onSubmit {
                    hasResult = true
                    searchWords.append(searchText)
                    viewModel.fetchSearchedData(keyword: searchText)
                }
            if hasResult {
                Button {
                    hasResult = false
                    searchText.removeAll()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 12))
                        .foregroundStyle(.gray)
                        .padding(.trailing, 4)
                }
            }
        }
    }
    
    private var recentSearchView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("최근 검색어")
                    .foregroundStyle(.gray)
                    .font(.system(size: 14))
                Spacer()
            }
            HStack(spacing: 8) {
                ForEach(Array(zip(searchWords.indices, searchWords)), id: \.0) { index, word in
                    Button {
                        searchWords.remove(at: index)
                    } label: {
                        HStack(spacing: 5) {
                            Text(word)
                                .font(.system(size: 14))
                            Image(systemName: "xmark")
                                .font(.system(size: 12))
                        }
                        .foregroundStyle(.gray)
                        .fixedSize()
                        .frame(height: 28)
                        .padding(.horizontal, 10)
                        .background(
                            Capsule()
                                .stroke(Color.gray, lineWidth: 1)
                                .foregroundStyle(.white)
                        )
                    }
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.top, 16)
    }

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
