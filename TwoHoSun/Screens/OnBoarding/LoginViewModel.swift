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

    func setAuthorizationCode(_ code: String) {
        self.authorization = code
    }

    func postAuthorCode() {
//        NewApiManager.shared.request(.postAuthorCode(authorization: authorization), responseType: Tokens.self) { response in
//            if let data = response.data {
//                KeychainManager.shared.saveToken(key: "accessToken", token: data.accessToken)
//                KeychainManager.shared.saveToken(key: "refreshToken", token: data.refreshToken)
//            }
//            if response.message == "UNREGISTERED_USER" {
//                    self.showSheet = true
//                } else {
//                    self.goMain = true
//                }
//            print(response)
//        } errorHandler: { err in
//            print(err)
//        }
        let requestDto = AuthCodeRequestDto(state: "test", code: authorization)
        NewNewApiManager.shared.request(.userService(.postAuthorCode(auth: requestDto)),
                                        responseType: Tokens.self) { response in
            if let data = response.data {
                KeychainManager.shared.saveToken(key: "accessToken", token: data.accessToken)
                KeychainManager.shared.saveToken(key: "refreshToken", token: data.refreshToken)
            }
            if response.message == "UNREGISTERED_USER" {
                    self.showSheet = true
                } else {
                    self.goMain = true
                }
            print(response)
        } errorHandler: { error in
            print(error)
        }
    }
}
