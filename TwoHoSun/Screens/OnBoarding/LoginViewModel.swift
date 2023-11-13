//
//  LoginViewModel.swift
//  TwoHoSun
//
//  Created by 235 on 10/16/23.
//
import SwiftUI

import Alamofire
import Combine
import Moya

class LoginViewModel: ObservableObject {
    @Published var showSheet = false
    @Published var authorization: String = ""
    @Published var goMain = false
    private var bag = Set<AnyCancellable>()
    private var apimanager: NewApiManager

    func setAuthorizationCode(_ code: String) {
        self.authorization = code
    }
    init(apimanager: NewApiManager) {
        self.apimanager = apimanager
    }

    func postAuthorCode() {
        apimanager.request(.postAuthorCode(authorization: authorization), decodingType: Tokens.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let failure):
                    print(failure)
                }
            }) { response in
                if let data = response.data {
                    KeychainManager.shared.saveToken(key: "accessToken", token: data.accessToken)
                    KeychainManager.shared.saveToken(key: "refreshToken", token: data.refreshToken)
                }
                if response.message == "UNREGISTERED_USER" {
                    self.showSheet = true
                } else {
                    self.goMain = true
                }
            }
            .store(in: &bag)
    }
}
