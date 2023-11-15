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
   
    @State private var appState = AppLoginState()

    var body: some Scene {
        WindowGroup {
            switch appState.serviceRoot.auth.authState {
            case .none, .allexpired, .unfinishRegister:
                OnBoardingView(viewModel: LoginViewModel(appState: appState))
                    .environment(appState)
            case .loggedIn:
                NavigationStack(path: $appState.serviceRoot.pathManager.navigationPath) {
                    WoteTabView(path: .constant([]))
                        .environment(appState)
                }
            }
        }
    }
}

class ServiceRoot {
    var auth = Authenticator()
    lazy var apimanager: NewApiManager = {
        let manager = NewApiManager(authenticator: auth)
        return manager
    }()
    var pathManager = NavigationManager()
}

enum TokenState {
    case none, allexpired, loggedIn, unfinishRegister
}

@Observable
class AppLoginState {
    var serviceRoot: ServiceRoot

    init() {
        serviceRoot = ServiceRoot()
        checkTokenValidity()
        serviceRoot.auth.relogin = relogin
    }
    
    private func relogin() {
        DispatchQueue.main.async {
            self.serviceRoot.auth.authState = .none
        }
    }
    
    private func checkTokenValidity() {
        if serviceRoot.apimanager.authenticator.accessToken != nil {
            serviceRoot.auth.authState = .loggedIn
        } else {
            serviceRoot.auth.authState = .none
        }
    }
}
