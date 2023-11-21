//
//  SchoolSearchView.swift
//  TwoHoSun
//
//  Created by 김민 on 10/17/23.
//

import SwiftUI

struct SchoolSearchView: View {
    @State private var searchWord = ""
    @Binding var selectedSchoolInfo: SchoolInfoModel?
    @Environment(\.dismiss) var dismiss
    @State private var textFieldState = SearchTextFieldState.inactive
    @StateObject private var viewModel = SchoolSearchViewModel()
    @FocusState private var isFocused: Bool

    var body: some View {
        ZStack(alignment: .top) {
            Color.background
                .ignoresSafeArea()
            VStack(spacing: 0) {
                schoolSearchField
                    .padding(.horizontal, 16)
                schoolSearchResultView
            }
            .padding(.top, 20)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("학교 검색")
                    .font(.system(size: 18, weight: .medium))
            }
        }
        .toolbarBackground(Color.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .foregroundStyle(.white)
    }
}

extension SchoolSearchView {

    private var schoolSearchField: some View {
        TextField("",
                  text: $searchWord,
                  prompt: Text("학교명 검색")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(textFieldState.placeholderColor))
            .focused($isFocused)
            .font(.system(size: 16, weight: .medium))
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0))
            .frame(height: 44)
            .background(textFieldState.backgroundColor)
            .tint(Color.placeholderGray)
            .onSubmit {
                Task {
                    textFieldState = .submitted
                    try await viewModel.setSchoolData(searchWord: searchWord)
                }
            }
            .onChange(of: isFocused) { _, isFocused in
                if isFocused {
                    textFieldState = .active
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay {
                if textFieldState == .active {
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(textFieldState.strokeColor, lineWidth: 1)
                        .blur(radius: 3)
                        .shadow(color: Color.shadowBlue, radius: 2)
                }
            }
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(textFieldState.strokeColor, lineWidth: 1)
            }
    }

    private var emptyResultView: some View {
        VStack(spacing: 20) {
            Image("imgNoResult")
            Text("검색 결과가 없습니다.")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(Color.subGray1)
        }
        .padding(.top, 170)
    }

    private func schoolListCell(_ schoolInfo: SchoolInfoModel, isLastCell: Bool) -> some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text(schoolInfo.school.schoolName)
                        .font(.system(size: 18, weight: .medium))
                        .padding(.bottom, 13)
                    HStack(spacing: 5) {
                        infoLabel("도로명")
                        infoDescription(schoolInfo.schoolAddress ?? "")
                    }
                    .padding(.bottom, 10)
                    HStack(spacing: 16) {
                        infoLabel("지역")
                        infoDescription(schoolInfo.school.schoolRegion)
                    }
                    .padding(.bottom, 10)
                }
                Spacer()
            }
            .background(Color.clear)
            .padding(.vertical, 16)
            .padding(.horizontal, 26)

            if !isLastCell {
                Divider()
                    .background(Color.dividerGray)
                    .padding(.horizontal, 16)
            }
        }
    }

    private func infoLabel(_ labelName: String) -> some View {
        Text(labelName)
            .font(.system(size: 12, weight: .medium))
            .padding(.vertical, 4)
            .padding(.horizontal, 5)
            .background(Color.lightBlue)
            .clipShape(RoundedRectangle(cornerRadius: 3.0))
    }

    private func infoDescription(_ description: String) -> some View {
        Text(description)
            .font(.system(size: 13, weight: .medium))
            .foregroundStyle(Color.infoGray)
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
                    .foregroundStyle(Color.subGray1)
            }
            Spacer()
        }
        .padding(.leading, 32)
    }

    @ViewBuilder
    private var searchedSchoolList: some View {
        List(viewModel.schools.indices, id: \.self) { index in
            let school = viewModel.schools[index]
            schoolListCell(school, isLastCell: index == viewModel.schools.count - 1)
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .onTapGesture {
                let schoolModel = school.school
                selectedSchoolInfo = SchoolInfoModel(school: SchoolModel(schoolName: schoolModel.schoolName,
                                                                         schoolRegion: regionMapping[schoolModel.schoolRegion]
                                                                         ?? schoolModel.schoolRegion),
                                                     schoolAddress: school.schoolAddress)
                dismiss()
            }
        }
        .listStyle(.plain)
    }

    @ViewBuilder
    private var schoolSearchResultView: some View {
        if viewModel.isFetching {
            ProgressView()
                .padding(.top, 100)
        } else {
            switch textFieldState {
            case .submitted:
                if viewModel.schools.isEmpty {
                    emptyResultView
                } else {
                    searchedSchoolList
                        .padding(.top, 16)
                }
            default:
                searchDescriptionView
                    .padding(.top, 32)
            }
        }
    }
}
