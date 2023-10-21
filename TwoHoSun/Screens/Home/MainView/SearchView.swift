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
    @State private var searchWords: [String] = ["label", "label", "label", "label", "label"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Divider()
            if isFocus {
                Text("focus")
            } else if !searchWords.isEmpty {
                recentSearch
            }
            Spacer()
                .frame(maxWidth: .infinity)
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
    }
}

extension SearchView {
    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.backward")
                .font(.system(size: 20))
                .foregroundStyle(.gray)
        }
    }
    
    private var searchField: some View {
        TextField("원하는 소비항목을 검색해보세요.", text: $searchText)
            .font(.system(size: 14))
            .frame(height: 30)
            .onSubmit {
                if searchWords.count > 4 {
                    searchWords.removeLast()
                    searchWords.insert(searchText, at: 0)
                } else {
                    searchWords.insert(searchText, at: 0)
                }
                searchText = ""
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
    }
}

#Preview {
    SearchView()
}
