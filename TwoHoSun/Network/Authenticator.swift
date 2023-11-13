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
    var authState: TokenState = .none {
        didSet {
            authStateSubject.send(authState)
        }
    }

    var accessToken: String? {
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
    private let queue = DispatchQueue(label: "Authenticator")
    private var refreshPublisher: AnyPublisher<Tokens, NetworkError>?
    var relogin: (() -> Void)?
    private var authStateSubject = CurrentValueSubject<TokenState, Never>(.none)
    init() {
         authStateSubject = CurrentValueSubject<TokenState, Never>(authState)
     }

    var authStatePublisher: AnyPublisher<TokenState, Never> {
         return authStateSubject
            .eraseToAnyPublisher()
     }

    func updateAuthState(_ newState: TokenState) {
        authState = newState
        authStateSubject.send(newState)
    }

    func saveTokens(_ token: Tokens) {
        KeychainManager.shared.saveToken(key: "accessToken", token: token.accessToken)
        KeychainManager.shared.saveToken(key: "refreshToken", token: token.refreshToken)
    }
}
