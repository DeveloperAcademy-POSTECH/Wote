//
//  LoginViewModel.swift
//  TwoHoSun
//
//  Created by 235 on 10/16/23.
//
import SwiftUI

import Alamofire
import Observation

@Observable
class LoginViewModel {
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
            .responseDecodable(of: LoginModel.self) { response in
                switch response.result {
                case .success(let data):
                    KeychainManager.shared.saveToken(key: "accessToken", token: data.data.accessToken)
                    KeychainManager.shared.saveToken(key: "refreshToken", token: data.data.refreshToken)
                case .failure(let err):
                    print(err)
                }
            }
    }
}