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
    @ObservedObject var viewModel = LoginViewModel()
    @State private var path: [Route] = []

    var body: some Scene {
        WindowGroup {
//            if appState.hasValidToken {
//                MainTabView()
//            } else {
//            OnBoardingView()
//            }
            NavigationStack(path: $path) {

                OnBoardingView(navigationPath: $path)
            }
//
//            OnBoardingView()
//            SchoolSearchView(selectedSchoolInfo: .constant(.none))
            MainTabView()
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
