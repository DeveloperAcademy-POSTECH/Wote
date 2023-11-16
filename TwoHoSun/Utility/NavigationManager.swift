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
enum AllNavigation {
    case mainView
    case detailView
    case alertView
    case searchView
    case reveiwView
    case makeVoteView
    case testView
    case mainTabView
    case profileView
}
enum MyPage {
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
    var navigationPath = [AllNavigation]()
    var mainPath = [MainNavigation]()
    var reviewPath = [ReviewNavigation]()

    func popToRootView(_ view: AllNavigation) {
        navigationPath.removeAll()
    }

    func navigate(route: MainNavigation) {
        mainPath.append(route)
    }

    func next(route: AllNavigation) {
        navigationPath.append(route)
    }
}
