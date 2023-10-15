//
//  LoginViewModel.swift
//  TwoHoSun
//
//  Created by 235 on 10/16/23.
//
import Alamofire
import SwiftUI
import Observation

@Observable
class LoginViewModel {
    var accessToken = ""
    var refreshToken = ""
    func postAuthorCode(authorizationCode: String) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
        ]
        let parameters = [
            "state" : "test",
            "code" : authorizationCode
        ]
        let url = "https://test.hyunwoo.tech/login/oauth2/code/apple"
        AF.request(url,method: .post,parameters: parameters,encoding: URLEncoding.httpBody, headers: headers)
            .responseDecodable(of: LoginModel.self) { response in
                switch response.result {
                case .success(let data):
                    print(data.data.accessToken)
                case .failure(let err):
                    print(err)
                }
            }
    }
}
