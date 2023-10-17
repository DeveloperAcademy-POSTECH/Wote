//
//  ProfileSettingsView.swift
//  TwoHoSun
//
//  Created by 김민 on 10/16/23.
//

import PhotosUI
import SwiftUI

enum NicknameValidationType {
    case none, empty, length, forbiddenWord, duplicated, valid

    var alertMessage: String {
        switch self {
        case .none:
            return ""
        case .empty:
            return "닉네임을 입력해주세요."
        case .length:
            return "닉네임은 1~10자로 설정해주세요."
        case .forbiddenWord:
            return "해당 닉네임으로는 아이디를 생성할 수 없어요."
        case .duplicated:
            return "중복된 닉네임입니다."
        case .valid:
            return "사용 가능한 닉네임입니다."
        }
    }

    var alertMessageColor: Color {
        switch self {
        case .none:
            return .clear
        case .valid:
            return .blue
        default:
            return .red
        }
    }
}

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

    var placeholder: String {
        switch self {
        case .nickname:
            return "한/영 10자 이내(특수문자 불가)"
        case .school:
            return "학교를 검색해주세요."
        case .grade:
            return "학년을 선택해주세요."
        }
    }

    var alertMessage: String {
        switch self {
        case .nickname:
            return "닉네임을 입력해주세요."
        case .school:
            return "학교를 입력해주세요."
        case .grade:
            return "학년을 선택해주세요."
        }
    }
}

struct ProfileSettingsView: View {
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImageData: Data?
    @State private var selectedGrade: String?
    @State private var isSchoolSearchSheetPresented = false
    @Binding var navigationPath: [Route]
    @State var selectedSchoolInfo: SchoolInfoModel?
    @State private var isFormValid = true

    @Bindable var viewModel: ProfileSettingViewModel

    private let grades = ["1학년", "2학년", "3학년"]

    private var isNicknameValid: Bool {
        return selectedSchoolInfo != nil
    }

    private var isSchoolValid: Bool {
        return selectedSchoolInfo != nil
    }

    private var isGradeValid: Bool {
        return selectedGrade != nil
    }

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
                              text: $viewModel.nickname,
                              prompt: Text("한/영 10자 이내(특수문자 불가)")
                        .font(.system(size: 12)))
                    .frame(height: 44)
                    .padding(EdgeInsets(top: 0, leading: 17, bottom: 0, trailing: 0))
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(.black, lineWidth: 1)
                }
                .onChange(of: viewModel.nickname) { _, newValue in
                    viewModel.checkNicknameValidation(newValue)
                }
                checkDuplicatedIdButton
            }
            nicknameValidationAlertMessage(for: viewModel.nicknameInvalidType)
                .padding(.top, 10)
        }
    }

    private var checkDuplicatedIdButton: some View {
        Button {
            viewModel.postNickname()
        } label: {
            Text("중복확인")
                .font(.system(size: 14))
                .foregroundStyle(.white)
                .frame(width: 100, height: 44)
                .background(viewModel.checkDuplicateButtonEnable() ? .black : .gray)
                .cornerRadius(10)
        }
        .disabled(viewModel.checkDuplicateButtonEnable() ? false : true)
    }

    private var schoolInputView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("학교")
                .font(.system(size: 16))
            roundedIconTextField(text: selectedSchoolInfo?.school.schoolName,
                                 for: .school)
            validationAlertMessage(for: .school, isValid: isSchoolValid)
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
            validationAlertMessage(for: .grade, isValid: isGradeValid)
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
            roundedIconTextField(text: selectedGrade,
                                 for: .grade)
        }
        .accentColor(.black)
    }

    private var nextButton: some View {
        Button {
            guard isGradeValid,
                    isSchoolValid,
                    viewModel.nicknameInvalidType == .valid else {
                isFormValid = false
                return
            }

            // TODO: - 프로필 설정 api 연결 / selectedSchoolInfoModel에서 school 정보 post하기
            print("profile setting api")

        } label: {
            Text("완료")
                .font(.system(size: 20))
                .foregroundStyle(.white)
                .frame(width: 361, height: 52)
                .background(Color.gray)
                .cornerRadius(10)
        }
    }

    private func roundedIconTextField(text: String?, for input: InputType) -> some View {
        VStack(spacing: 10) {
            HStack(spacing: 0) {
                Text(text ?? input.placeholder)
                    .font(.system(size: 12))
                    .foregroundColor(text != nil ? .black : .gray)
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
        }
    }

    private func nicknameValidationAlertMessage(for input: NicknameValidationType) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "light.beacon.max")
            Text(input.alertMessage)
            Spacer()
        }
        .font(.system(size: 12))
        .foregroundStyle(viewModel.nicknameInvalidType.alertMessageColor)
    }

    private func validationAlertMessage(for input: InputType, isValid: Bool) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "light.beacon.max")
            Text(input.alertMessage)
            Spacer()
        }
        .font(.system(size: 12))
        .foregroundStyle(!isFormValid && !isValid ? .red : .clear)
    }
}

//#Preview {
//    ProfileSettingsView(selectedSchoolInfo:
//                            SchoolInfoModel(school: SchoolModel(schoolName: "예문여고",
//                                                                schoolRegion: "부산",
//                                                                schoolType: SchoolType.highSchool.schoolType),
//                                            schoolAddress: "부산시 수영구"))
//}
