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

@Observable
class LoginViewModel: ObservableObject {
    var showSheet = false
    var authorization: String = ""
    var goMain = false
    private var bag = Set<AnyCancellable>()
    private var appState: AppLoginState

    init(appState: AppLoginState) {
        self.appState = appState
    }

    func setAuthorizationCode(_ code: String) {
        self.authorization = code
    }

    func postAuthorCode() {
        appState.serviceRoot.apimanager
            .requestLogin(authorization: authorization)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let failure):
                    print(failure)
                }
            }) {response in
                if let data = response.data {
                    self.appState.serviceRoot.auth.saveTokens(data)
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
