//
//  NavigationManager.swift
//  TwoHoSun
//
//  Created by 235 on 11/15/23.
//

import SwiftUI

enum MainNavigation {
    case mainView
    case detailView
    case alertView
    case searchView
    case reveiwView
    case makeVoteView
    case testView
}
enum TabNavigation {
    case myPage(route: MyPageNavigation)
    case mainNavigation(route: MainNavigation)
    case reviewNavigation(route: ReviewNavigation)
}
enum LoginNavigation {
    case mainTabView
    case profileView
}
enum MyPageNavigation {
    case settingView
//    case 
}
enum ReviewNavigation {
    case searchView
    case alertView
    case detailView
    case writeReview
}

@Observable
final class NavigationManager {
    var navigationPath = [TabNavigation]()
    var mainPath = [MainNavigation]()
    var reviewPath = [ReviewNavigation]()
    var loginPath = [LoginNavigation]()
    var mypagePath = [MyPageNavigation]()

    func popToRootView(route: TabNavigation) {
        navigationPath.removeAll()
        switch route {
        case .myPage:
            mypagePath.removeAll()
        case .mainNavigation:
            mainPath.removeAll()
        case .reviewNavigation:
            reviewPath.removeAll()
        }
    }

    func navigate(route: TabNavigation) {
        switch route {
        case .myPage(let route):
            mypagePath.append(route)
        case .mainNavigation(let route):
            mainPath.append(route)
        case .reviewNavigation(let route):
            reviewPath.append(route)
        }
    }


}
