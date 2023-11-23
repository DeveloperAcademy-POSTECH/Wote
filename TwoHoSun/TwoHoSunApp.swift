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
        appState.serviceRoot.navigationManager.navigate(.detailView(postId: postId, index: 0, dirrectComments: isComment))
    }
}
class ServiceRoot {
    var auth = Authenticator()
    var navigationManager = NavigationManager()
    private var cancellable = Set<AnyCancellable>()
    lazy var apimanager: NewApiManager = {
        let manager = NewApiManager(authenticator: auth)
        return manager
    }()
    
    private func blockUser(memberId: Int) {
        apimanager.request(.userService(.blockUser(memberId: memberId)), decodingType: NoData.self)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { _ in
                print("block user successful!")
            }
            .store(in: &cancellable)
    }
}

@Observable
class AppData {
    var posts = [PostModel]()
    var notificationDatas = [NotificationModel]()
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
