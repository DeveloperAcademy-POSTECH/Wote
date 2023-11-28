//
//  Authenticator.swift
//  TwoHoSun
//
//  Created by 235 on 11/13/23.
//
import Combine
import SwiftUI

import Moya

@Observable
class Authenticator {
    enum TokenState {
        case none, allexpired, loggedIn, unfinishRegister
    }

    var authState: TokenState = .none {
        didSet {
            authStateSubject.send(authState)
        }
    }

    var accessToken: String? {
        return KeychainManager.shared.readToken(key: "accessToken")
    }
    var refreshToken: String? {
       return KeychainManager.shared.readToken(key: "refreshToken")
    }
    
    var relogin: (() -> Void)?
    private var authStateSubject = CurrentValueSubject<TokenState, Never>(.none)
    init() {
         authStateSubject = CurrentValueSubject<TokenState, Never>(authState)
     }

    var authStatePublisher: AnyPublisher<TokenState, Never> {
         return authStateSubject
            .eraseToAnyPublisher()
     }

    func saveTokens(_ token: Tokens) {
        KeychainManager.shared.saveToken(key: "accessToken", token: token.accessToken)
        KeychainManager.shared.saveToken(key: "refreshToken", token: token.refreshToken)
    }

    func deleteTokens() {
        KeychainManager.shared.deleteToken(key: "accessToken")
        KeychainManager.shared.deleteToken(key: "refreshToken")
    }
}
