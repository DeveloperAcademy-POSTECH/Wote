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
    var firstNickname = ""
    var firstSchool: SchoolInfoModel?

    private var appState: AppLoginState
    init(appState: AppLoginState) {
        self.appState = appState
    }
    var isSchoolFilled: Bool {
        return selectedSchoolInfo != nil
    }
    var isAllInputValid: Bool {
        return (nicknameValidationType == .valid
        && isSchoolFilled)
        || (selectedImageData != nil && nickname == firstNickname && selectedSchoolInfo?.school.schoolName == firstSchool?.school.schoolName)
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
    
    func checkSchoolRegisterDate(_ date: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: date) {
            if let datePlusSixMonths = Calendar.current.date(byAdding: .month, value: 6, to: date) {
                if Date() > datePlusSixMonths {
                    return false
                } else {
                    return true
                }
            }
        }
        return false
    }
    
    func setProfile(_ isRestricted: Bool, _ isRegsiter: Bool) {
        guard let school = selectedSchoolInfo?.school else { return }
        if isRestricted {
            model = ProfileSetting(imageFile: selectedImageData ?? Data(),
                                   nickname: nickname,
                                   school: nil)
        } else {
            model = ProfileSetting(imageFile: selectedImageData ?? Data(),
                                   nickname: nickname,
                                   school: school)
        }
        postProfileSetting(isRegister: isRegsiter)
    }
    
    func postNickname() {
        appState.serviceRoot.apimanager.request(.userService(.checkNicknameValid(nickname: nickname)),
                           decodingType: NicknameValidation.self)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { data in
                guard let isExist = data.data?.isExist else { return }
                self.isNicknameDuplicated = isExist
                self.nicknameValidationType = self.isNicknameDuplicated ? .duplicated : .valid
            }
            .store(in: &bag)
    }
    
    func postProfileSetting(isRegister: Bool = false) {
        guard let model = model else { return }
        var cancellable: AnyCancellable?
        cancellable = appState.serviceRoot.apimanager.request(.userService(.postProfileSetting(profile: model)),
                           decodingType: NoData.self)
            .sink { completion in
                print("끝남? \(completion)")
            } receiveValue: { _ in
                self.appState.serviceRoot.memberManager.fetchProfile()
                if isRegister {
                    self.appState.serviceRoot.auth.authState = .loggedIn
                }
                cancellable?.cancel()
            }
    }
}
