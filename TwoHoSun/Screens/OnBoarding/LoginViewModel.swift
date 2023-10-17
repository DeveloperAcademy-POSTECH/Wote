//
//  LoginViewModel.swift
//  TwoHoSun
//
//  Created by 235 on 10/16/23.
//
import SwiftUI

import Alamofire
import Combine

class LoginViewModel: ObservableObject {
    
    @Published var showSheet = false
    @Published var navigationPath: [Route] = []
    private var cancellables: Set<AnyCancellable> = []
    func postAuthorCode(_ authorizationCode: String) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
        ]
        let parameters = [
            "state": "test",
            "code": authorizationCode
        ]
        let url = "https://test.hyunwoo.tech/login/oauth2/code/apple"
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers)
            .publishDecodable(type: GeneralResponse<Tokens>.self)
            .value()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: { data in
                print(data)
                if let data = data.data {
                    KeychainManager.shared.saveToken(key: "accessToken", token: data.accessToken)
                    KeychainManager.shared.saveToken(key: "refreshToken", token: data.refreshToken)
                }
                if data.message == "UNREGISTERED_USER" {
                    self.showSheet = true
                } else {
                    self.navigationPath.append(.mainView)
                }
            })
            .store(in: &cancellables)
    }
}
