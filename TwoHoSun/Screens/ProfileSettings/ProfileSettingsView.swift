//
//  ProfileSettingsView.swift
//  TwoHoSun
//
//  Created by 김민 on 10/16/23.
//

import PhotosUI
import SwiftUI

enum InputType {
    case nickname, school, grade

    var iconName: String {
        switch self {
        case .nickname:
            return ""
        case .school:
            return "magnifyingglass"
        case .grade:
            return "chevron.down"
        }
    }

    var alertMessage: String {
        switch self {
        case .nickname:
            return "닉네임을 입력해주세요."
        case .school:
            return "학교를 입력해주세요."
        case .grade:
            return "학년을 입력해주세요."
        }
    }
}

struct ProfileSettingsView: View {
    let viewModel = ProfileSettingViewModel()
    
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImageData: Data?
    @State private var nickname: String = ""
    @State private var selectedSchool: String?
    @State private var selectedGrade: String?
    @State private var isSchoolSearchSheetPresented = false
    @Binding var navigationPath: [Route]
    @State var selectedSchoolInfo: SchoolInfoModel?

    let grades = ["1학년", "2학년", "3학년"]

    var body: some View {
        ZStack {
            Color.white
            GeometryReader { _ in
                VStack(spacing: 0) {
                    Spacer()
                    titleLabel
                        .padding(.leading, 26)
                    Spacer()
                    profileImage
                    Spacer()
                    VStack(spacing: 8) {
                        nicknameInputView
                        schoolInputView
                        gradeInputView
                    }
                    .padding(.horizontal, 26)
                    Spacer()
                    nextButton
                        .padding(.bottom, 38)
                }
            }
            .ignoresSafeArea(.keyboard)
            .fullScreenCover(isPresented: $isSchoolSearchSheetPresented) {
                NavigationView {
                    SchoolSearchView(selectedSchoolInfo: $selectedSchoolInfo)
                }
            }
        }
    }
}

extension ProfileSettingsView {

    private var titleLabel: some View {
        HStack {
            Text("Vote 프로필")
                .font(.system(size: 32, weight: .bold)) +
            Text("을\n설정해 주세요.")
                .font(.system(size: 32, weight: .medium))
            Spacer()
        }
    }

    private var profileImage: some View {
        ZStack(alignment: .bottomTrailing) {
            Circle()
                .frame(width: 130, height: 130)
                .foregroundStyle(.gray)
            if let selectedImageData,
               let uiImage = UIImage(data: selectedImageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 130, height: 130)
                    .clipShape(Circle())
            }
            selectProfileButton
        }
    }

    private var selectProfileButton: some View {
        PhotosPicker(selection: $selectedPhoto,
                     matching: .images,
                     photoLibrary: .shared()) {
            ZStack {
                Circle()
                    .frame(width: 40, height: 40)
                    .foregroundStyle(.blue)
                Image(systemName: "camera")
                    .font(.system(size: 20))
                    .foregroundStyle(.black)
            }
            .onChange(of: selectedPhoto) { _, newValue in
                PHPhotoLibrary.requestAuthorization { status in
                    guard status == .authorized else { return }

                    Task {
                        if let data = try? await newValue?.loadTransferable(type: Data.self) {
                            selectedImageData = data
                        }
                    }
                }
            }
        }
    }

    private var nicknameInputView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("닉네임")
                .font(.system(size: 16))
                .padding(.bottom, 8)
            HStack(spacing: 10) {
                HStack {
                    TextField("",
                              text: $nickname,
                              prompt: Text("한/영 10자 이내(특수문자 불가)")
                                    .font(.system(size: 12)))
                        .frame(height: 44)
                        .padding(EdgeInsets(top: 0, leading: 17, bottom: 0, trailing: 0))
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(.black, lineWidth: 1)
                }
                checkDuplicatedIdButton
            }
            alertMessage(for: .nickname)
                .padding(.top, 8)
        }
    }

    private var checkDuplicatedIdButton: some View {
        Button {
            viewModel.postNickname(nickname: nickname)
        } label: {
            Text("중복확인")
                .font(.system(size: 14))
                .foregroundStyle(.white)
                .frame(width: 100, height: 44)
                .background(Color.black)
                .cornerRadius(10)
        }
    }

    private var schoolInputView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("학교")
                .font(.system(size: 16))
            roundedIconTextField(text: selectedSchoolInfo?.school.schoolName ?? "학교를 검색해주세요.", for: .school)
        }
        .onTapGesture {
            isSchoolSearchSheetPresented = true
        }
    }

    private var gradeInputView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("학년")
                .font(.system(size: 16))
            gradeMenu
        }
    }

    private var gradeMenu: some View {
        Menu {
            ForEach(grades, id: \.self) { grade in
                Button {
                    selectedGrade = grade
                } label: {
                    Text(grade)
                }
            }
        } label: {
            roundedIconTextField(text: selectedGrade ?? "학년을 선택해주세요.",
                                 for: .grade)
        }
        .accentColor(.black)
    }

    private var nextButton: some View {
        Button {
            print("next button did tap")
            // TODO: - 프로필 설정 api 연결
            // selectedSchoolInfoModel에서 school 정보 post하기
        } label: {
            Text("완료")
                .font(.system(size: 20))
                .foregroundStyle(.white)
                .frame(width: 361, height: 52)
                .background(Color.gray)
                .cornerRadius(10)
        }
    }

    private func roundedIconTextField(text: String, for input: InputType) -> some View {
        VStack(spacing: 10) {
            HStack(spacing: 0) {
                Text(text)
                    .font(.system(size: 12))
                    .frame(height: 44)
                    .padding(.leading, 17)
                Spacer()
                Image(systemName: input.iconName)
                    .font(.system(size: 16))
                    .padding(.trailing, 18)
            }
            .frame(maxWidth: .infinity)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(.black, lineWidth: 1)
            }
            alertMessage(for: input)
        }
    }

    // TODO: - 유효성 검사
    private func alertMessage(for input: InputType) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "light.beacon.max")
            Text(input.alertMessage)
            Spacer()
        }
        .font(.system(size: 12))
        .foregroundStyle(.red)
    }
}

#Preview {
    ProfileSettingsView(selectedSchoolInfo:
                            SchoolInfoModel(school: SchoolModel(schoolName: "예문여고",
                                                                schoolRegion: "부산",
                                                                schoolType: SchoolType.highSchool.schoolType),
                                            schoolAddress: "부산시 수영구"))
}
