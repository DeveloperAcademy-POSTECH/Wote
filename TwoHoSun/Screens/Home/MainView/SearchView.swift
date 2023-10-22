//
//  SearchView.swift
//  TwoHoSun
//
//  Created by 관식 on 10/21/23.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.dismiss) private var dismiss: DismissAction
    @State private var searchText: String = ""
    @State private var searchWords: [String] = []
    @State private var dismissTabBar: Bool = false
    @State private var hasResult: Bool = false
    @State private var hasRecommendation: Bool = false
    @State private var hasRecentSearch: Bool = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Divider()
            if !hasRecommendation, !hasRecentSearch, !hasResult {
                Spacer()
                    .frame(maxWidth: .infinity)
            }
            if hasRecommendation {
                searchRecommendation
            }
            if hasRecentSearch {
                recentSearch
                Spacer()
                    .frame(maxWidth: .infinity)
            }
            if hasResult {
                ScrollView {
                    VStack {
                        Text("hi")
                    }
                }
            }
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
                .onChange(of: searchText) {
                    if searchText.isEmpty {
                        hasRecentSearch = searchWords.isEmpty ? false : true
                        hasRecommendation = false
                    } else {
                        hasRecentSearch = false
                        hasRecommendation = true
                    }
                    hasResult = false
                }
                .onSubmit {
                    if searchWords.count > 4 {
                        searchWords.removeLast()
                    }
                    searchWords.insert(searchText, at: 0)
                    hasRecentSearch = false
                    hasRecommendation = false
                    hasResult = true
                }
            if hasResult {
                Button {
                    hasResult = false
                    searchText = ""
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 12))
                        .foregroundStyle(.gray)
                        .padding(.trailing, 4)
                }
            }
        }
    }
    
    private var recentSearch: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("최근 검색어")
                .foregroundStyle(.gray)
                .font(.system(size: 14))
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
    
    private var searchRecommendation: some View {
        List {
            // TODO: - 서버 나오면 onChange로 데이터 받아오는 로직 추가
            ForEach(0..<5) { _ in
                Button {
                    if searchWords.count > 4 {
                        searchWords.removeLast()
                    }
                    searchWords.insert(searchText, at: 0)
                    hasRecentSearch = false
                    hasRecommendation = false
                    hasResult = true
                } label: {
                    HStack {
                        Text("발렌시아가")
                        Spacer()
                        Image(systemName: "paperplane")
                    }
                    .frame(height: 48)
                    .font(.system(size: 16))
                    .foregroundStyle(.gray)
                    .padding(.leading, 48)
                    .padding(.trailing, 14)
                }
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    SearchView()
}
