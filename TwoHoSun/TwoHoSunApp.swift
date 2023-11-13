//
//  TwoHoSunApp.swift
//  TwoHoSun
//
//  Created by 관식 on 10/15/23.
//

import SwiftUI
import Observation

enum Route {
    case mainTabView
    case profileView
}

@main
struct TwoHoSunApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var appState = AppLoginState()    
    var body: some Scene {
        WindowGroup {
            switch appState.loginState {
            case .none, .allexpired, .unregister:
                OnBoardingView(viewModel: LoginViewModel(apimanager: appState.serviceRoot.apimanager), loginState: appState)
            case .loggedIn:
                NavigationStack {
                    WoteTabView(path: .constant([]))
                }
                
            }
        }
    }
}

class ServiceRoot {
    let auth = Authenticator()
    lazy var apimanager: NewApiManager = {
        let manager = NewApiManager(authenticator: auth)
        return manager
    }()
}

@Observable
class AppLoginState {
    var loginState: TokenState = .none
    let serviceRoot: ServiceRoot
    init() {
        serviceRoot = ServiceRoot()
        loginState = serviceRoot.auth.authState
        checkTokenValidity()
        serviceRoot.auth.relogin = relogin
    }

    private func relogin() {
        DispatchQueue.main.async {
            self.loginState = .none
        }
    }

    private func checkTokenValidity() {
        if KeychainManager.shared.readToken(key: "accessToken") != nil {
            loginState = .loggedIn
        } else {
            loginState = .none
        }
    }
}

