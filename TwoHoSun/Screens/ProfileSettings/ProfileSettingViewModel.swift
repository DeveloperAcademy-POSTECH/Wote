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
class ProfileSettingViewModel {
    var isDuplicated: Bool = false
    private var cancellable: Set<AnyCancellable> = []
    
    func postNickname(nickname: String) {
        let requestURL = URLConst.baseURL + "/api/profiles/isValidNickname"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(KeychainManager.shared.readToken(key: "accessToken"))"
        ]
        let body: [String: String] = ["userNickname": nickname]
        
        AF.request(requestURL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
            .publishDecodable(type: NicknameResponse.self)
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
                self.isDuplicated = data.isExist
                print("Nickname is duplicated: \(data.isExist)")
            }
    }
        .store(in: &cancellable)
}
