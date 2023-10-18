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
    var nicknameInvalidType = NicknameValidationType.none
    var selectedSchoolInfo: SchoolInfoModel?
    var selectedGrade: String?
    var isNicknameDuplicated = false
    var isFormValid = true
    let grades = ["1학년", "2학년", "3학년"]
    private let forbiddenWord = ["금지어1", "금지어2"]
    private var cancellable: Set<AnyCancellable> = []

    var isSchoolValid: Bool {
        return selectedSchoolInfo != nil
    }

    var isGradeValid: Bool {
        return selectedGrade != nil
    }

    func isNicknameLengthValid(_ text: String) -> Bool {
        let pattern = #"^.{1,10}$"#
        if let range = text.range(of: pattern, options: .regularExpression) {
            return text.distance(from: range.lowerBound, to: range.upperBound) == text.count
        }
        return false
    }

    func isNicknameIncludeForbiddenWord(_ text: String) -> Bool {
        for word in forbiddenWord where text.contains(word) {
            return true
        }
        return false
    }

    func checkNicknameValidation(_ text: String) {
        isNicknameDuplicated = false

        if !isNicknameLengthValid(text) {
            nicknameInvalidType = .length
        } else if isNicknameIncludeForbiddenWord(text) {
            nicknameInvalidType = .forbiddenWord
        } else {
            nicknameInvalidType = .none
        }
    }

    func isDuplicateButtonEnabled() -> Bool {
        guard isNicknameLengthValid(nickname), !isNicknameIncludeForbiddenWord(nickname) else {
            return false
        }
        return true
    }

    func checkAllInputValid() {
        guard isGradeValid,
              isSchoolValid,
              nicknameInvalidType == .valid else {
            if nickname.isEmpty { nicknameInvalidType = .empty }
            isFormValid = false
            return
        }

        print("profile setting api ")
    }

    func postNickname() {
        let requestURL = URLConst.baseURL + "/api/profiles/isValidNickname"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(KeychainManager.shared.readToken(key: "accessToken")!)"
        ]
        let body: [String: String] = ["userNickname": nickname]

        AF.request(requestURL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
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
                self.nicknameInvalidType = self.isNicknameDuplicated ? .duplicated : .valid
            }
            .store(in: &cancellable)
    }
    
    func postProfileSetting(userProfileImage: String, userNickname: String, school: SchoolModel, grade: Int) {
        let requestURL = URLConst.baseURL + "/api/profiles"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(KeychainManager.shared.readToken(key: "accessToken")!)"
        ]
        let body: [String: Any] = [
            "userProfileImage": userProfileImage,
            "userNickname": userNickname,
            "school": [
                "schoolName": school.schoolName,
                "schoolRegion": school.schoolRegion,
                "schoolType": school.schoolType
            ],
            "grade": grade
        ]
        
        AF.request(requestURL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
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
