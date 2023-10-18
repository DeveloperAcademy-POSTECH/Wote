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

        postProfileSetting(ProfileSetting(userProfileImage: "",
                           userNickname: nickname,
                           school: school,
                            grade: Int(String(grade))!))
    }

    func postNickname() {
        let requestURL = URLConst.baseURL + "/api/profiles/isValidNickname"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(KeychainManager.shared.readToken(key: "accessToken")!)"
        ]
        let body: [String: String] = ["userNickname": nickname]

        AF.request(requestURL, 
                   method: .post,
                   parameters: body,
                   encoding: JSONEncoding.default,
                   headers: headers)
            .publishDecodable(type: GeneralResponse<NicknameValidation>.self)
            .value()
            .map(\.data)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                }
            } receiveValue: { data in
                guard let isExist = data?.isExist else { return }
                self.isNicknameDuplicated = isExist
                self.nicknameValidationType = self.isNicknameDuplicated ? .duplicated : .valid
            }
            .store(in: &cancellable)
    }

    private func postProfileSetting(_ model: ProfileSetting) {
        let requestURL = URLConst.baseURL + "/api/profiles"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(KeychainManager.shared.readToken(key: "accessToken")!)"
        ]
        let body: [String: Any] = [
            "userProfileImage": model.userProfileImage,
            "userNickname": model.userNickname,
            "school": [
                "schoolName": model.school.schoolName,
                "schoolRegion": model.school.schoolRegion,
                "schoolType": model.school.schoolType
            ],
            "grade": model.grade
        ]

        AF.request(requestURL, 
                   method: .post,
                   parameters: body,
                   encoding: JSONEncoding.default,
                   headers: headers)
            .publishDecodable(type: GeneralResponse<NoData>.self)
            .value()
            .map(\.message)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                }
            } receiveValue: { message in
                print("The result of posting profile: \(message)")
            }
            .store(in: &cancellable)
    }
}
