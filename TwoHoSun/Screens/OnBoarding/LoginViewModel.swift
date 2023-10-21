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
    @Published var authorization: String = ""
    
    func setAuthorizationCode(_ code: String) {
        self.authorization = code
    }
    
    func postAuthorCode() {
        APIManager.shared.requestAPI(type: .postAuthorCode(authorization)) { (response: GeneralResponse<Tokens>) in
            if response.status == 401 {
                APIManager.shared.refreshAllTokens()
                self.postAuthorCode()
            } else {
                if let data = response.data {
                    KeychainManager.shared.saveToken(key: "accessToken", token: data.accessToken)
                    KeychainManager.shared.saveToken(key: "refreshToken", token: data.refreshToken)
                }
                if response.message == "UNREGISTERED_USER" {
                    self.showSheet = true
                } else {
                    self.navigationPath.append(.mainTabView)
                }
            }
        }
    }
}
