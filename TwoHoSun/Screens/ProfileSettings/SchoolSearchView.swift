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
    @Binding var selectedSchoolInfo: SchoolInfoModel?
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                schoolSearchField
                schoolSearchResult
                Spacer()
            }
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
}

extension SchoolSearchView {

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
            .onSubmit {
                Task {
                    try await viewModel.setSchoolData(searchWord: searchWord)
                }
            }
    }

    private func schoolListCell(_ schoolInfo: SchoolInfoModel) -> some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(schoolInfo.school.schoolName)
                        .font(.system(size: 16, weight: .medium))
                    HStack(spacing: 5) {
                        infoLabel("도로명")
                        infoDescription(schoolInfo.schoolAddress)
                    }
                    HStack(spacing: 13) {
                        infoLabel("지역")
                        infoDescription(schoolInfo.school.schoolRegion)
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

    private var searchDescriptionView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("이렇게 검색해보세요")
                    .font(.system(size: 16, weight: .semibold))
                    .padding(.bottom, 20)
                Text("학교명")
                    .font(.system(size: 16, weight: .medium))
                    .padding(.bottom, 5)
                Text("예) 세원고, 세원고등학교")
                    .font(.system(size: 14, weight: .light))
            }
            Spacer()
        }
        .padding(.leading, 43)
    }

    @ViewBuilder
    private var searchedSchoolList: some View {
        Rectangle()
            .frame(height: 1)
        List(viewModel.schools) { school in
            schoolListCell(school)
            .listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)
            .onTapGesture {
                selectedSchoolInfo = school
                dismiss()
            }
        }
        .listStyle(.plain)
    }

    @ViewBuilder
    private var schoolSearchResult: some View {
        if viewModel.schools.isEmpty && !viewModel.isFetching {
            searchDescriptionView
        } else if viewModel.isFetching {
            ProgressView()
                .padding(.top, 100)
        } else {
            searchedSchoolList
        }
    }
}

#Preview {
    NavigationView {
        SchoolSearchView(selectedSchoolInfo:
                .constant(SchoolInfoModel(school: SchoolModel(schoolName: "예문여고",
                                                              schoolRegion: "부산",
                                                              schoolType: SchoolType.highSchool.schoolType),
                                          schoolAddress: "부산시 수영구")))
    }
}
