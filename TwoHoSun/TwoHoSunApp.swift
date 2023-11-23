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
    @StateObject private var dataController = DataController()

    var body: some Scene {
        WindowGroup {
            switch appState.serviceRoot.auth.authState {
            case .none, .allexpired, .unfinishRegister:
                OnBoardingView(viewModel: LoginViewModel(appState: appState))
                    .environment(appState)
            case .loggedIn:
                WoteTabView(notiManager: dataController)
                    .environment(appState)
                    .onAppear {
                        appDelegate.app = self
                    }
            }
        }
    }

}

extension TwoHoSunApp {
    func handleDeepPush(notiModel: NotiDecodeModel) async {
        if notiModel.isComment {
            await savePush(notiModel: notiModel)
            NotificationCenter.default.post(name: Notification.Name("showComment"), object: nil)
        }
        appState.serviceRoot.navigationManager.navigate(.detailView(postId: notiModel.postid, index: 0, dirrectComments: notiModel.isComment))
    }
    func savePush(notiModel: NotiDecodeModel) async {
        if notiModel.isComment {
            dataController.addNotificationData(model: notiModel)
        }
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
    var notificationDatas = [NotiDecodeModel]() 
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
