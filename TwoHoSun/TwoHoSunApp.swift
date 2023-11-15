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
    @State private var pathManager = NavigationManager()

    var body: some Scene {
        WindowGroup {
            switch appState.serviceRoot.auth.authState {
            case .none, .allexpired, .unfinishRegister:
                OnBoardingView(viewModel: LoginViewModel(appState: appState))
                    .environment(appState)
                    .environment(pathManager)
            case .loggedIn:
                NavigationStack(path: $pathManager.navigationPath) {
                    WoteTabView(path: .constant([]))
                        .environment(appState)
                        .environment(pathManager)

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

enum TokenState {
    case none, allexpired, loggedIn, unfinishRegister
}

@Observable
class AppLoginState {
    let serviceRoot: ServiceRoot

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
