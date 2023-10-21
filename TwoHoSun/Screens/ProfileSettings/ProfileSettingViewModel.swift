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

@Observable
final class ProfileSettingViewModel {
    var nickname = ""
    var selectedSchoolInfo: SchoolInfoModel?
    var selectedGrade: String?    
    var nicknameValidationType = NicknameValidationType.none
    var isNicknameDuplicated = false
    var isFormValid = true
    var model: ProfileSetting? = nil
    private let forbiddenWord = ["금지어1", "금지어2"]
    private var cancellable: Set<AnyCancellable> = []

    var isSchoolFilled: Bool {
        return selectedSchoolInfo != nil
    }

    var isGradeFilled: Bool {
        return selectedGrade != nil
    }

    var isAllInputValid: Bool {
        return nicknameValidationType == .valid
                && isGradeFilled && isSchoolFilled
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
        guard let school = selectedSchoolInfo?.school,
              let grade = selectedGrade?.first else { return }
        model = ProfileSetting(userProfileImage: "",
                               userNickname: nickname,
                               school: school,
                               grade: Int(String(grade))!)
        postProfileSetting()
    }

    func postNickname() {
        APIManager.shared.requestAPI(type: .postNickname(nickname)) { (response: GeneralResponse<NicknameValidation>) in
            if response.status == 401 {
                APIManager.shared.refreshAllTokens()
                self.postNickname()
            } else {
                guard let data = response.data else { return }
                self.isNicknameDuplicated = data.isExist
                self.nicknameValidationType = self.isNicknameDuplicated ? .duplicated : .valid
            }
        }
    }
    
    func postProfileSetting() {
        guard let model = model else { return }
        APIManager.shared.requestAPI(type: .postProfileSetting(model)) { (response: GeneralResponse<NoData>) in
            if response.status == 401 {
                APIManager.shared.refreshAllTokens()
                self.postProfileSetting()
            } else {
                print("The result of posting profile: \(response.message)")
            }
        }
    }
}
