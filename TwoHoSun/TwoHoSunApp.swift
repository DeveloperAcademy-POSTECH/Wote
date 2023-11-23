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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var appState = AppLoginState()

    var body: some Scene {
        WindowGroup {
            switch appState.serviceRoot.auth.authState {
            case .none, .allexpired, .unfinishRegister:
                OnBoardingView(viewModel: LoginViewModel(appState: appState))
                    .environment(appState)
            case .loggedIn:
                    WoteTabView()
                        .environment(appState)
                        .onAppear {
                            appDelegate.app = self
                        }
            }
        }
    }

}

extension TwoHoSunApp {
    func handleDeepPush(postId: Int, _ isComment: Bool) async {
        appState.serviceRoot.navigationManager.navigate(.detailView(postId: postId, dirrectComments: isComment))
    }
}
class ServiceRoot {
    var auth = Authenticator()

    lazy var apimanager: NewApiManager = {
        let manager = NewApiManager(authenticator: auth)
        return manager
    }()
    var navigationManager = NavigationManager()
}

@Observable
class AppData {
    var posts = [PostModel]()
    var notificationDatas = [NotificationModel]()
    var reviewManager = ReviewManager()
    var postManager = PostManager()
}

@Observable
class AppLoginState {
    var serviceRoot: ServiceRoot
    var appData: AppData

    init() {
        appData = AppData()
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
