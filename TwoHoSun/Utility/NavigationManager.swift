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
    case reveiwView
    case makeVoteView
    case testView
}
//enum TabNavigation {
//    case myPage(route: MyPageNavigation)
//    case mainNavigation(route: MainNavigation)
//    case reviewNavigation(route: ReviewNavigation)
//}
enum LoginNavigation {
    case mainTabView
    case profileView
}
enum MyPageNavigation {
    case settingView
//    case 
}
enum ReviewNavigation {
    case detailView
    case writeReview
}

enum AlertNavigation {
    case voteView(id: String)
    case reviewView(id: String)
}

@Observable
final class NavigationManager {
    var path = NavigationPath()

    func popToRootView() {
        path.removeLast(path.count)
    }
    func printPath() {
        print(path)
    }

//    func navigate(route: TabNavigation) {
//        switch route {
//        case .myPage(let route):
//            mypagePath.append(route)
//        case .mainNavigation(let route):
//            mainPath.append(route)
//        case .reviewNavigation(let route):
//            reviewPath.append(route)
//        }
//    }


}
