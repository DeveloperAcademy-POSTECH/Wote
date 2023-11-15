//
//  ProfileSettingViewModel.swift
//  TwoHoSun
//
//  Created by 관식 on 10/17/23.
//

import Combine
import Observation
import SwiftUI

import Alamofire
import Moya

@Observable
final class ProfileSettingViewModel {
    var nickname = ""
    var selectedSchoolInfo: SchoolInfoModel?
    var selectedGrade: String?    
    var nicknameValidationType = NicknameValidationType.none
    var selectedImageData: Data?
    var isNicknameDuplicated = false
    var isFormValid = true
    var model: ProfileSetting? 
    private let forbiddenWord = ["금지어1", "금지어2"]
    var bag = Set<AnyCancellable>()
//    var path: Binding<[AllNavigation]>
    private var appState: AppLoginState
    private var isSucceed = false {
        didSet {
            if isSucceed {
                self.appState.serviceRoot.auth.authState = .loggedIn
            }
        }
    }
    init(appState: AppLoginState) {
        self.appState = appState
//        self.path = path
    }
    var isSchoolFilled: Bool {
        return selectedSchoolInfo != nil
    }
    var isAllInputValid: Bool {
        return nicknameValidationType == .valid
        && isSchoolFilled
    }

    private func isNicknameLengthValid(_ text: String) -> Bool {
        let pattern = #"^.{1,10}$"#
        if let range = text.range(of: pattern, options: .regularExpression) {
            return text.distance(from: range.lowerBound, to: range.upperBound) == text.count
        }
        return false
    }
    
    private func isNicknameIncludeForbiddenWord(_ text: String) -> Bool {
        for word in forbiddenWord where text.contains(word) {
            return true
        }
        return false
    }
    
    func checkNicknameValidation(_ text: String) {
        isNicknameDuplicated = false
        
        if !isNicknameLengthValid(text) {
            nicknameValidationType = .length
        } else if isNicknameIncludeForbiddenWord(text) {
            nicknameValidationType = .forbiddenWord
        } else {
            nicknameValidationType = .none
        }
    }
    
    func isDuplicateButtonEnabled() -> Bool {
        return isNicknameLengthValid(nickname) && !isNicknameIncludeForbiddenWord(nickname)
    }
    
    func setInvalidCondition() {
        if nickname.isEmpty { nicknameValidationType = .empty }
        isFormValid = false
    }
    
    func setProfile() {
        guard let school = selectedSchoolInfo?.school else { return }
        model = ProfileSetting(imageFile: selectedImageData ?? Data(),
                               nickname: nickname,
                               school: school)
        postProfileSetting()
    }
    
    func postNickname() {
        appState.serviceRoot.apimanager.request(.userService(.checkNicknameValid(nickname: nickname)),
                           decodingType: NicknameValidation.self)
        .compactMap(\.data)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { data in
                self.isNicknameDuplicated = data.isExist
                self.nicknameValidationType = self.isNicknameDuplicated ? .duplicated : .valid
            }
            .store(in: &bag)
    }
    
    func postProfileSetting() {
        guard let model = model else { return }
        var cancellable: AnyCancellable?
        cancellable = appState.serviceRoot.apimanager.request(.userService(.postProfileSetting(profile: model)),
                           decodingType: NoData.self)
            .sink { completion in
                print("끝남? \(completion)")
            } receiveValue: { response in
                self.appState.serviceRoot.auth.authState = .loggedIn
                cancellable?.cancel()
            }

    }
}
