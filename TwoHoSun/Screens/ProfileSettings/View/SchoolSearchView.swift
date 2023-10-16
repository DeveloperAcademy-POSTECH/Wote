//
//  SchoolSearchView.swift
//  TwoHoSun
//
//  Created by 김민 on 10/17/23.
//

import SwiftUI

struct SchoolSearchView: View {
    @State private var searchWord = ""

    var body: some View {
        VStack {
            schoolInputView
            schoolList
        }
    }

    private var schoolInputView: some View {
        HStack {
            schoolSearchField
            searchButton
        }
    }

    private var schoolSearchField: some View {
        TextField("학교 입력", text: $searchWord)
            .frame(height: 44)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(.black, lineWidth: 1)
            }
    }

    private var searchButton: some View {
        Button {
        } label: {
            Image(systemName: "magnifyingglass")
        }
    }

    private var schoolList: some View {
        List(0..<10) { index in
            HStack {
                Text("\(index)")
                Text("\(index)")
            }
        }
    }
}

#Preview {
    SchoolSearchView()
}
