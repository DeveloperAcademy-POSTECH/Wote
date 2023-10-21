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
    private var searchWords: [String] = ["label"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Divider()
            if !searchWords.isEmpty {
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
                TextField("원하는 소비항목을 검색해보세요.", text: $searchText)
                    .font(.system(size: 14))
                    .frame(height: 30)
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
    
    private var recentSearch: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("최근 검색어")
                .foregroundStyle(.gray)
                .font(.system(size: 14))
            HStack(spacing: 8) {
                ForEach(searchWords, id: \.self) { word in
                    Button {
                        
                    } label: {
                        HStack(spacing: 5) {
                            Text(word)
                                .font(.system(size: 14))
                            Image(systemName: "xmark")
                                .font(.system(size: 12))
                        }
                        .foregroundStyle(.gray)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 7)
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
