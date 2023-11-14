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

    let appState = AppLoginState()
//    @State private var path: [Route] = []

    var body: some Scene {
        WindowGroup {
////            if appState.hasValidToken {
            NavigationStack {
                WoteTabView(path: .constant([Route.mainTabView]))
            }
////            } else {
//                OnBoardingView()
////            }
////                NavigationStack(path: $path) {
////                    OnBoardingView(navigationPath: $path)
////                }
////                .tint(Color.accentBlue)
////            }
        }
    }
}

@Observable
class AppLoginState {
    var hasValidToken: Bool = false

    init() {
        checkTokenValidity()
    }

    private func checkTokenValidity() {
        if KeychainManager.shared.readToken(key: "accessToken") != nil {
            hasValidToken = true
        } else {
            hasValidToken = false
        }
    }
}
