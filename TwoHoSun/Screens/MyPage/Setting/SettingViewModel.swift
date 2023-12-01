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
    var blockUsersList: [BlockUserModel] = []
    
    init(loginStateManager: AppLoginState) {
        self.loginStateManager = loginStateManager
    }
    
    func requestLogOut() {
        var cancellable: AnyCancellable?
        cancellable =  loginStateManager.serviceRoot.apimanager
            .request(.userService(.requestLogout(deviceToken: KeychainManager.shared.readToken(key: "deviceToken")!)),
                                                                                     decodingType: NoData.self)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { _ in
                self.loginStateManager.serviceRoot.auth.deleteTokens()
                self.loginStateManager.serviceRoot.navigationManager.countPop(count: 1)
                self.loginStateManager.serviceRoot.auth.authState = .none
                cancellable?.cancel()
            }
    }
    
    func deleteUser() {
        loginStateManager.serviceRoot.apimanager.request(.userService(.deleteUser), decodingType: NoData.self)
            .debounce(for: 1, scheduler: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { _ in
                self.loginStateManager.serviceRoot.navigationManager.gotoMain()
                self.loginStateManager.serviceRoot.auth.deleteTokens()
                self.loginStateManager.serviceRoot.auth.authState = .none
                self.loginStateManager.serviceRoot.memberManager.profile = nil
            }
            .store(in: &cancellable)
    }
    
    func getBlockUsers() {
        loginStateManager.serviceRoot.apimanager.request(.userService(.getBlockUsers), decodingType: [BlockUserModel].self)
            .compactMap(\.data)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { data in
                self.blockUsersList.append(contentsOf: data)
            }
            .store(in: &cancellable)
    }
    
    func deleteBlockUser(memberId: Int) {
        loginStateManager.serviceRoot.apimanager.request(.userService(.deleteBlockUser(memberId: memberId)), decodingType: NoData.self)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { _ in
                print("delte block user(\(memberId)) successful!")
                NotificationCenter.default.post(name: NSNotification.userBlockStateUpdated, object: nil)
            }
            .store(in: &cancellable)
    }
}
