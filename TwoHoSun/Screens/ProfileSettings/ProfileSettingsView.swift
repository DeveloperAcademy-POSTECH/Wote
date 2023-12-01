//
//  ProfileSettingsView.swift
//  TwoHoSun
//
//  Created by 김민 on 10/16/23.
//

import PhotosUI
import SwiftUI

enum NicknameValidationType {
    case none, empty, length, forbiddenWord, duplicated, valid, same

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
        case .same:
            return "같은 닉네임입니다."
        }
    }

    var alertMessageColor: Color {
        switch self {
        case .none:
            return .clear
        case .valid:
            return Color.deepBlue
        default:
            return Color.errorRed
        }
    }

    var textfieldBorderColor: Color {
        switch self {
        case .none, .valid:
            return Color.grayStroke
        default:
            return Color.errorRed
        }
    }
}

enum ProfileInputType {
    case nickname, school

    var iconName: String {
        switch self {
        case .nickname:
            return ""
        case .school:
            return "magnifyingglass"
        }
    }

    var placeholder: String {
        switch self {
        case .nickname:
            return "한/영 10자 이내(특수문자 불가)"
        case .school:
            return "학교를 검색해주세요."
        }
    }

    var alertMessage: String {
        switch self {
        case .nickname:
            return "닉네임을 입력해주세요."
        case .school:
            return "학교를 입력해주세요."
        }
    }
}

enum ProfileSettingType: Decodable {
    case setting, modfiy
}

struct ProfileSettingsView: View {
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var isProfileSheetShowed = false
    @State private var retryProfileImage = false
    @State private var isRestricted = false
    @State var viewType: ProfileSettingType
    @State var originalImage: String?
    @Bindable var viewModel: ProfileSettingViewModel
    @AppStorage("haveConsumerType") var haveConsumerType: Bool = false
    @Environment(\.dismiss) private var dismiss
    @Environment(AppLoginState.self) private var loginStateManager
    @FocusState var focusState: Bool
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            VStack(spacing: 0) {
                switch viewType {
                case .setting:
                    titleLabel
                        .padding(.top, 40)
                case .modfiy:
                    if let consumerType = loginStateManager.serviceRoot.memberManager.profile?.consumerType {
                        HStack {
                            ConsumerTypeLabel(consumerType: consumerType, usage: .standard)
                            Spacer()
                        }
                        .padding(.top, 30)
                    }
                }
                Spacer()
                profileImageView
                    .onAppear {
                        if let image = loginStateManager.serviceRoot.memberManager.profile?.profileImage {
                            originalImage = image
                        }
                    }
                Spacer()
                nicknameInputView
                    .padding(.bottom, 34)
                schoolInputView
                    .onAppear {
                        if let school = loginStateManager.serviceRoot.memberManager.profile?.school {
                            if viewModel.selectedSchoolInfo == nil {
                                viewModel.selectedSchoolInfo = SchoolInfoModel(school: school, schoolAddress: nil)
                            }
                            viewModel.firstSchool = SchoolInfoModel(school: school, schoolAddress: nil)
                        }
                        if let lastSchoolRegisterDate = loginStateManager.serviceRoot.memberManager.profile?.lastSchoolRegisterDate {
                            isRestricted = viewModel.checkSchoolRegisterDate(lastSchoolRegisterDate)
                        }
                        
                    }
                Spacer()
                switch viewType {
                case .setting:
                    nextButton
                case .modfiy:
                    if haveConsumerType && loginStateManager.serviceRoot.memberManager.profile?.canUpdateConsumerType ?? false {
                        goToTypeTestButton
                            .padding(.bottom, 12)
                    }
                    completeButton
                }
            }
            .padding(.bottom, 12)
            .padding(.horizontal, 16)
        }
        .onTapGesture {
            endTextEditing()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(viewType == .setting ? true : false)
        .toolbar {
            if viewType == .modfiy {
                ToolbarItem(placement: .principal) {
                    Text("프로필 수정")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(.white)
                }
            }
        }
        .toolbarBackground(Color.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .photosPicker(isPresented: $retryProfileImage, selection: $selectedPhoto)
        .onChange(of: selectedPhoto) { _, newValue in
            PHPhotoLibrary.requestAuthorization { status in
                guard status == .authorized else { return }
                Task {
                    if let data = try? await newValue?.loadTransferable(type: Data.self) {
                        viewModel.selectedImageData = data
                    }
                }
            }
        }
        .customConfirmDialog(isPresented: $isProfileSheetShowed, isMine: .constant(true)) {_ in
            Button {
                originalImage = nil
                selectedPhoto = nil
                viewModel.selectedImageData = nil
                isProfileSheetShowed.toggle()
            } label: {
                Text("프로필 삭제하기")
                    .frame(maxWidth: .infinity)
            }
            .frame(height: 42)
            Divider()
                .background(Color.gray300)
            Button {
                retryProfileImage = true
                isProfileSheetShowed.toggle()
            } label: {
                Text("프로필 재설정하기")
            }
            .frame(height: 42)
        }
    }
}

extension ProfileSettingsView {
    // MARK: - UI Components
    private var titleLabel: some View {
        HStack(spacing: 7) {
            VStack(alignment: .leading, spacing: 9) {
                Image("logo")
                    .resizable()
                    .frame(width: 86, height: 28)
                Text("설정해")
                    .font(.system(size: 32, weight: .medium))
                    .foregroundStyle(Color.white)
            }
            VStack(alignment: .leading) {
                Text("프로필")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(Color.white) +
                Text("을")
                    .font(.system(size: 32, weight: .medium))
                    .foregroundStyle(Color.white)
                Text("주세요.")
                    .font(.system(size: 32, weight: .medium))
                    .foregroundStyle(Color.white)
            }
            Spacer()
        }
    }

    private var profileImageView: some View {
        ZStack(alignment: .bottomTrailing) {
            if let selectedData = viewModel.selectedImageData, let uiImage = UIImage(data: selectedData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 130, height: 130)
                    .clipShape(Circle())
            } else if let originalImage = originalImage {
                ProfileImageView(imageURL: originalImage)
                    .frame(width: 130, height: 130)
            } else {
                photoPickerView {
                    Image("defaultProfile")
                        .resizable()
                        .frame(width: 130, height: 130)
                }
            }
            selectProfileButton
        }
        .onTapGesture {
            isProfileSheetShowed = true
        }
    }

    private var selectProfileButton: some View {
        ZStack {
            Circle()
                .frame(width: 34, height: 34)
                .foregroundStyle(Color.lightBlue)
            Image(systemName: "plus")
                .font(.system(size: 20))
                .foregroundStyle(.white)
        }
    }

    @ViewBuilder
    func photoPickerView<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        PhotosPicker(selection: $selectedPhoto,
                     matching: .images,
                     photoLibrary: .shared()) {
            content()
                .onChange(of: selectedPhoto) { _, newValue in
                    PHPhotoLibrary.requestAuthorization { status in
                        guard status == .authorized else { return }
                        Task {
                            if let data = try? await newValue?.loadTransferable(type: Data.self) {
                                viewModel.selectedImageData = data
                            }
                        }
                    }
                }
        }
    }

    private var nicknameInputView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("닉네임")
                .modifier(TitleTextStyle())
            HStack(spacing: 10) {
                TextField("",
                          text: $viewModel.nickname,
                          prompt: Text(ProfileInputType.nickname.placeholder)
                    .font(.system(size: 12))
                    .foregroundStyle(Color.placeholderGray))
                .foregroundStyle(Color.white)
                .font(.system(size: 14))
                .frame(height: 44)
                .padding(EdgeInsets(top: 0, leading: 17, bottom: 0, trailing: 0))
                .overlay {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(viewModel.nicknameValidationType.textfieldBorderColor, lineWidth: 1)
                        if (focusState || viewModel.nicknameValidationType == .empty || viewModel.nicknameValidationType == .none) {
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(viewModel.nicknameValidationType.textfieldBorderColor, lineWidth: 1)
                                .shadow(color: Color.strokeBlue.opacity(0.15), radius: 2)
                                .blur(radius: 3)
                        }
                    }
                }
                .onAppear {
                    if let nickname = loginStateManager.serviceRoot.memberManager.profile?.nickname {
                        viewModel.nickname = nickname
                        viewModel.firstNickname = nickname
                    }
                }
                .onChange(of: viewModel.nickname) { _, newValue in
                    viewModel.checkNicknameValidation(newValue)
                }
                checkDuplicatedIdButton
            }
            nicknameValidationAlertMessage(for: viewModel.nicknameValidationType)
                .padding(.top, 6)
        }
    }

    private var checkDuplicatedIdButton: some View {
        Button {
            viewModel.postNickname()
            if viewModel.nicknameValidationType == .valid {
                endTextEditing()
            }
        } label: {
            Text("중복확인")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.white)
                .frame(width: 103, height: 44)
                .background(Color.disableGray)
                .cornerRadius(10)
        }
        .disabled(viewModel.nicknameValidationType == .length)
    }

    @ViewBuilder
    private var schoolInputView: some View {
        if isRestricted {
            VStack(alignment: .leading, spacing: 0) {
                Text("우리 학교")
                    .modifier(TitleTextStyle())
                roundedIconTextField(for: .school,
                                     text:  viewModel.selectedSchoolInfo?.school.schoolName,
                                     isFilled: viewModel.isSchoolFilled)
                if isRestricted {
                    HStack {
                        Image(systemName: "light.beacon.max")
                        Text("학교를 변경한지 아직 6개월이 안 지났어요!")
                    }
                    .foregroundStyle(Color.errorRed)
                    .font(.system(size: 12))
                    .padding(.top, 4)
                }
            }
        } else {
            NavigationLink {
                SchoolSearchView(selectedSchoolInfo: $viewModel.selectedSchoolInfo)
            } label: {
                VStack(alignment: .leading, spacing: 0) {
                    Text("우리 학교")
                        .modifier(TitleTextStyle())
                    roundedIconTextField(for: .school,
                                         text: viewModel.selectedSchoolInfo?.school.schoolName,
                                         isFilled: viewModel.isSchoolFilled)
                    if !viewModel.isFormValid && !viewModel.isSchoolFilled {
                        schoolValidationAlertMessage
                            .padding(.top, 6)
                    }
                }
            }
        }
    }

    private var nextButton: some View {
        Button {
            guard viewModel.isAllInputValid else {
                viewModel.setInvalidCondition()
                return
            }
            viewModel.setProfile(isRestricted, true)
        } label: {
            Text("완료")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 361, height: 52)
                .background(viewModel.isAllInputValid ? Color.lightBlue : Color.disableGray)
                .cornerRadius(10)
        }
        .disabled(viewModel.isAllInputValid ? false : true)
    }

    private var completeButton: some View {
        Button {
            guard viewModel.isAllInputValid else {
                viewModel.setInvalidCondition()
                return
            }
            viewModel.setProfile(isRestricted, false)
            dismiss()
        } label: {
            Text("완료")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 361, height: 52)
                .background(viewModel.isAllInputValid ? Color.lightBlue : Color.disableGray)
                .cornerRadius(10)
        }
        .disabled(viewModel.isAllInputValid ? false : true)
    }

    private func roundedIconTextField(for input: ProfileInputType, text: String?, isFilled: Bool) -> some View {
        VStack(spacing: 10) {
            HStack(spacing: 0) {
                if isRestricted {
                    Text(text ?? input.placeholder)
                        .font(.system(size: 14))
                        .foregroundColor(Color.subGray7)
                        .frame(height: 45)
                        .padding(.leading, 17)
                } else {
                    Text(text ?? input.placeholder)
                        .font(.system(size: 14))
                        .foregroundColor(text != nil ? .white : Color.placeholderGray)
                        .frame(height: 45)
                        .padding(.leading, 17)
                }
                Spacer()
                Image(systemName: input.iconName)
                    .font(.system(size: 16))
                    .foregroundStyle(Color.placeholderGray)
                    .padding(.trailing, 12)
            }
            .frame(maxWidth: .infinity)
            .background {
                if isRestricted {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(isRestricted ? Color.dividerGray : nil)
                } else {
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(!isFilled && !viewModel.isFormValid ? Color.errorRed : Color.grayStroke, lineWidth: 1)
                }
            }
        }
    }

    private var goToTypeTestButton: some View {
        Button {
            loginStateManager.serviceRoot.navigationManager.navigate(.testIntroView)
        } label: {
            HStack(spacing: 0) {
                Text("소비 성향 테스트하러가기")
                    .foregroundStyle(.white)
                Text("(1회)")
                    .foregroundStyle(Color.gray500)
            }
            .font(.system(size: 16, weight: .semibold))
            .frame(height: 52)
            .frame(maxWidth: .infinity)
            .background(Color.lightBlue)
            .clipShape(.rect(cornerRadius: 10))
        }
    }

    private func nicknameValidationAlertMessage(for input: NicknameValidationType) -> some View {
        HStack(spacing: 8) {
            Image(systemName: viewModel.nicknameValidationType == .valid ?
                  "checkmark.circle.fill" : "light.beacon.max")
            Text(input.alertMessage)
            Spacer()
        }
        .font(.system(size: 12))
        .foregroundStyle(viewModel.nicknameValidationType.alertMessageColor)
    }

    private var schoolValidationAlertMessage: some View {
        HStack(spacing: 8) {
            Image(systemName: "light.beacon.max")
            Text(ProfileInputType.school.alertMessage)
            Spacer()
        }
        .font(.system(size: 12))
        .foregroundStyle(Color.errorRed)
    }

    struct TitleTextStyle: ViewModifier {
        func body(content: Content) -> some View {
            content
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.white)
                .padding(.bottom, 8)
        }
    }
}
