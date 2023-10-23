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
    let appState = AppState()
    @State private var path: [Route] = []

    var body: some Scene {
        WindowGroup {
//            NavigationStack(path: $path) {
                if appState.hasValidToken {
                    MainTabView()
                } else {
                    NavigationStack(path: $path) {
                        OnBoardingView(navigationPath: $path)
                    }
                }
//            }
        }
    }
}

@Observable
class AppState {
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
