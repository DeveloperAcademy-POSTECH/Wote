//
//  TwoHoSunApp.swift
//  TwoHoSun
//
//  Created by 관식 on 10/15/23.
//

import SwiftUI
import Observation

@main
struct TwoHoSunApp: App {
    let appState = AppState()
    
    var body: some Scene {
        WindowGroup {
//            if appState.hasValidToken {
//                HomeView()
//            } else {
//                OnBoardingView()
//            }
            ProfileSettingsView(viewModel: SettingsViewModel())
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
