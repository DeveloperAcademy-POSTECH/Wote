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

    var textfieldBorderColor: Color {
        switch self {
        case .none, .valid:
            return .black
        default:
            return .red
        }
    }
}

enum ProfileInputType {
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
    @State private var isSchoolSearchSheetPresented = false
    @State private var genderSelection = UserGender.boy
    @Binding var navigationPath: [Route]
    @Bindable var viewModel: ProfileSettingViewModel

    var body: some View {
        ZStack {
            Color.white
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 0) {
                        titleLabel
                            .padding(.leading, 26)
                            .padding(.top, 70)
                        profileImage
                            .padding(.top, 48)
                        VStack(spacing: 30) {
                            nicknameInputView
                            genderPicker
//                                .padding(.bottom, 30)
                            schoolInputView
                            gradeInputView
                        }
                        .padding(.top, 46)
                        .padding(.horizontal, 26)
                        .padding(.bottom, 70)
                    }
                }
                nextButton
                    .padding(.bottom, 12)
            }
            .scrollIndicators(.hidden)
            .ignoresSafeArea(.keyboard)
            .fullScreenCover(isPresented: $isSchoolSearchSheetPresented) {
                NavigationView {
                    SchoolSearchView(selectedSchoolInfo: $viewModel.selectedSchoolInfo)
                }
            }
            .navigationBarBackButtonHidden()
        }
    }
}

extension ProfileSettingsView {

    // MARK: - UI Components

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
                .font(.system(size: 16, weight: .medium))
                .padding(.bottom, 8)
            HStack(spacing: 10) {
                HStack {
                    TextField("",
                              text: $viewModel.nickname,
                              prompt: Text(ProfileInputType.nickname.placeholder)
                        .font(.system(size: 12)))
                    .frame(height: 44)
                    .padding(EdgeInsets(top: 0, leading: 17, bottom: 0, trailing: 0))
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(viewModel.nicknameValidationType.textfieldBorderColor, lineWidth: 1)
                }
                .onChange(of: viewModel.nickname) { _, newValue in
                    viewModel.checkNicknameValidation(newValue)
                }
                checkDuplicatedIdButton
            }

            if viewModel.nicknameValidationType != .none {
                nicknameValidationAlertMessage(for: viewModel.nicknameValidationType)
                    .padding(.top, 6)
            }
        }
    }

    private var checkDuplicatedIdButton: some View {
        Button {
            viewModel.postNickname()
            if viewModel.nicknameValidationType == .valid { dismissKeyboard() }
        } label: {
            Text("중복확인")
                .font(.system(size: 14))
                .foregroundStyle(.white)
                .frame(width: 100, height: 44)
                .background(viewModel.isDuplicateButtonEnabled() ? .black : .gray)
                .cornerRadius(10)
        }
        .disabled(viewModel.isDuplicateButtonEnabled() ? false : true)
    }

    private var genderPicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("성별")
                .font(.system(size: 16, weight: .medium))
            HStack(spacing: 0) {
                ForEach(UserGender.allCases, id: \.self) { gender in
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(genderSelection == gender ? .blue : .clear)
                        Text(gender.rawValue + "자")
                            .font(.system(size: 14))
                            .foregroundColor(genderSelection == gender ? .white : .black)
                    }
                    .onTapGesture {
                        withAnimation(.easeOut) {
                            genderSelection = gender
                        }
                    }
                }
            }
            .frame(height: 44)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(.black, lineWidth: 1)
            }
        }
    }

    private var schoolInputView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("학교")
                .font(.system(size: 16, weight: .medium))
            roundedIconTextField(for: .school,
                                 text: viewModel.selectedSchoolInfo?.school.schoolName,
                                 isFilled: viewModel.isSchoolFilled)
            if !viewModel.isFormValid && !viewModel.isSchoolFilled {
                validationAlertMessage(for: .school, isValid: viewModel.isSchoolFilled)
            }
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
            if !viewModel.isFormValid && !viewModel.isGradeFilled {
                validationAlertMessage(for: .grade, isValid: viewModel.isGradeFilled)
            }
        }
    }

    private var gradeMenu: some View {
        Menu {
            ForEach(1..<4) { grade in
                Button {
                    viewModel.selectedGrade = "\(grade)학년"
                } label: {
                    Text("\(grade)학년")
                }
            }
        } label: {
            roundedIconTextField(for: .grade, 
                                 text: viewModel.selectedGrade,
                                 isFilled: viewModel.isGradeFilled)
        }
        .accentColor(.black)
    }

    private var nextButton: some View {
        Button {
            guard viewModel.isAllInputValid else {
                viewModel.setInvalidCondition()
                return
            }
            viewModel.setProfile()
        } label: {
            Text("완료")
                .font(.system(size: 20))
                .foregroundStyle(.white)
                .frame(width: 361, height: 52)
                .background(viewModel.isAllInputValid ? .blue : .gray)
                .cornerRadius(10)
        }
    }

    private func roundedIconTextField(for input: ProfileInputType, text: String?, isFilled: Bool) -> some View {
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
                    .strokeBorder(!isFilled && !viewModel.isFormValid ? .red : .black, lineWidth: 1)
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
        .foregroundStyle(viewModel.nicknameValidationType.alertMessageColor)
    }

    private func validationAlertMessage(for input: ProfileInputType, isValid: Bool) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "light.beacon.max")
            Text(input.alertMessage)
            Spacer()
        }
        .font(.system(size: 12))
//        .foregroundStyle(!viewModel.isFormValid && !isValid ? .red : .clear)
        .foregroundStyle(.red)
    }

    // MARK: - Custom Methods
    
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
