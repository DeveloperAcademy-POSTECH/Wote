//
//  SettingViewModel.swift
//  TwoHoSun
//
//  Created by 관식 on 11/22/23.
//

import Combine
import SwiftUI

@Observable
class SettingViewModel {
    var loginStateManager: AppLoginState
    private var cancellable = Set<AnyCancellable>()
    
    init(loginStateManager: AppLoginState) {
        self.loginStateManager = loginStateManager
    }
    
    func requestLogOut() {
        loginStateManager.serviceRoot.apimanager.request(.userService(.requestLogout), decodingType: NoData.self)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { _ in
                KeychainManager.shared.deleteToken(key: "accessToken")
                KeychainManager.shared.deleteToken(key: "refreshToken")
                self.loginStateManager.serviceRoot.auth.authState = .none
            }
            .store(in: &cancellable)
    }
    
    func deleteUser() {
        loginStateManager.serviceRoot.apimanager.request(.userService(.deleteUser), decodingType: NoData.self)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { _ in
                KeychainManager.shared.deleteToken(key: "accessToken")
                KeychainManager.shared.deleteToken(key: "refreshToken")
                self.loginStateManager.serviceRoot.auth.authState = .none
            }
            .store(in: &cancellable)
    }
}
