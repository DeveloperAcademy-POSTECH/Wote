//
//  ProfileSettingViewModel.swift
//  TwoHoSun
//
//  Created by 관식 on 10/17/23.
//

import Alamofire
import Combine
import Observation
import SwiftUI

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
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                }
            } receiveValue: { response in
                switch response.result {
                case .success(let nicknameResponse):
                    self.isDuplicated = nicknameResponse.data.isExist
                    print("Nickname is duplicated: \(nicknameResponse.data.isExist)")
                case .failure(let error):
                    print("Decoding Error: \(error)")
                }
            }
            .store(in: &cancellable)
    }
}
