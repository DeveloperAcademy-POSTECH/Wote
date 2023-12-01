//
//  TwoHoSunApp.swift
//  TwoHoSun
//
//  Created by 관식 on 10/15/23.
//

import Combine
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
        switch notiModel.postStatus {
        case "REVIEW":
            appState.serviceRoot.navigationManager.navigate(.reviewDetailView(
                postId: nil, reviewId: notiModel.postid, directComments: notiModel.isComment))
        case "CLOSED":
            appState.serviceRoot.navigationManager.navigate(
                .reviewDetailView(postId: notiModel.postid,
                                  reviewId: nil, directComments: notiModel.isComment))
        default:
            appState.serviceRoot.navigationManager.navigate(.detailView(postId: notiModel.postid, dirrectComments: notiModel.isComment))
        }
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
    lazy var memberManager = MemberManager(authenticator: auth)
}

@Observable
class AppData {
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
        serviceRoot.memberManager.fetchProfile()
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
