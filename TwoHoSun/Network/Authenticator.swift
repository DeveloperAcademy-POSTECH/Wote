//
//  Authenticator.swift
//  TwoHoSun
//
//  Created by 235 on 11/13/23.
//
import Combine
import SwiftUI

import Moya


enum TokenState {
    case none, allexpired, loggedIn, unregister
}

@Observable
class Authenticator {
    var authState: TokenState = .none
    private var accessToken: String? {
        if let accessToken = KeychainManager.shared.readToken(key: "accessToken") {
            return accessToken
        }
        return nil
    }
    private var refreshToken: String? {
        if let refreshToken = KeychainManager.shared.readToken(key: "refreshToken") {
            return refreshToken
        }
        return nil
    }
    private let queue = DispatchQueue(label: "Authenticator.")
    private var refreshPublisher: AnyPublisher<Tokens, NetworkError>?
    var provider = MoyaProvider<APIService>(plugins: [NetworkLoggerPlugin()])
    var relogin: (() -> Void)?

//    func validToken(_ shouldRefresh: Bool = false) -> AnyPublisher<Tokens, NetworkError> {
//        return queue.sync { [weak self] in
//            // 이미 새로운 토큰을 로딩중일때
//            if let publisher = self?.refreshPublisher {
//                return publisher
//            }
//            // 액세스토큰이 없을때 로그인으로 가도록
//            guard let token = self?.accessToken else {
//                return Fail(error: NetworkError.shouldgoLogin)
//                    .eraseToAnyPublisher()
//            }
//            //need new token
//            ㄱㄷ셔
//        }
//    }


}
