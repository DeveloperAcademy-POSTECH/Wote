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
    
    var body: some View {
        VStack {
            
        }
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
}

#Preview {
    SearchView()
}
