//
//  SchoolSearchView.swift
//  TwoHoSun
//
//  Created by 김민 on 10/17/23.
//

import SwiftUI

struct SchoolSearchView: View {
    @State private var searchWord = ""
    private let viewModel = SchoolSearchViewModel()
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 0) {
            schoolSearchField
            Rectangle()
                .frame(height: 1)
            schoolList
        }
        .navigationTitle("학교 검색")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                backButton
            }
        }
        .toolbarBackground(.white, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }

    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.backward")
                .font(.system(size: 20))
                .accentColor(.gray)
        }
    }

    private var schoolSearchField: some View {
        TextField("학교 입력", text: $searchWord)
            .frame(height: 44)
            .padding(EdgeInsets(top: 0, leading: 17, bottom: 0, trailing: 0))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(.black, lineWidth: 1)
            }
            .padding(.horizontal, 26)
            .padding(.vertical, 20)
    }

    private func schoolListCell(_ school: SchoolModel) -> some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("세원고등학교")
                        .font(.system(size: 16, weight: .medium))
                    HStack(spacing: 5) {
                        infoLabel("도로명")
                        infoDescription("경기도 고양시 일산동구 숲속마을로")
                    }
                    HStack(spacing: 13) {
                        infoLabel("지역")
                        infoDescription("경기도")
                    }
                }
                Spacer()
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 26)
            Rectangle()
                .frame(height: 1)
        }
    }

    private func infoLabel(_ labelName: String) -> some View {
        Text(labelName)
            .font(.system(size: 10, weight: .medium))
            .padding(.vertical, 4)
            .padding(.horizontal, 5)
            .background(Color.gray)
            .clipShape(RoundedRectangle(cornerRadius: 3.0))
    }

    private func infoDescription(_ description: String) -> some View {
        Text(description)
            .font(.system(size: 13, weight: .medium))
    }

    private var schoolList: some View {
        List(0..<3) { _ in
            schoolListCell(SchoolModel(schoolName: "..",
                                       schoolRegion: "..",
                                       schoolType: ".."))
            .listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
}

#Preview {
    NavigationView {
        SchoolSearchView()
    }
}
