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
    var isDuplicated: Bool = false
    var nickname = ""
    var nicknameInvalidType = NicknameValidationType.none
    private let forbiddenWord = ["금지어1", "금지어2"]
    private var cancellable: Set<AnyCancellable> = []

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
        if text.isEmpty {
            nicknameInvalidType = .empty
        } else if !isNicknameLengthValid(text) {
            nicknameInvalidType = .length
        } else if isNicknameIncludeForbiddenWord(text) {
            nicknameInvalidType = .forbiddenWord
        } else if isDuplicated {
            nicknameInvalidType = .duplicated
        } else {
            nicknameInvalidType = .none
            isDuplicated = false
        }
    }

    func postNickname() {
        let requestURL = URLConst.baseURL + "/api/profiles/isValidNickname"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(KeychainManager.shared.readToken(key: "accessToken"))"
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
                self.isDuplicated = isExist
                self.nicknameInvalidType = self.isDuplicated ? .duplicated : .valid
            }
            .store(in: &cancellable)
    }
}
