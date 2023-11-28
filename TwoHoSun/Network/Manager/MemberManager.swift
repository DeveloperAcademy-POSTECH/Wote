//
//  MemberManager.swift
//  TwoHoSun
//
//  Created by 관식 on 11/24/23.
//

import Combine
import SwiftUI

@Observable
final class MemberManager: NewApiManager {
    var profile: ProfileModel?
    var cancellables: Set<AnyCancellable> = []
    
    func fetchProfile() {
        request(.userService(.getProfile), decodingType: ProfileModel.self)
            .compactMap(\.data)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { data in
                self.profile = data
            }
            .store(in: &cancellables)
    }
    
    func blockUser(memberId: Int) {
        request(.userService(.blockUser(memberId: memberId)), decodingType: NoData.self)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { _ in
                print("block user successful!")
                NotificationCenter.default.post(name: NSNotification.userBlockStateUpdated, object: nil)
            }
            .store(in: &cancellables)
    }
}
