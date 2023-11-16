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
    case testView
    case testIntroView
}
enum ReviewNavigation {
    case detailView
    case writeReview
}

enum AlertNavigation {
    case voteView(id: String)
    case reviewView(id: String)
}
enum AllNavigation {
    case writeReiview
    case detailView
    case reveiwView
    case makeVoteView
    case testIntroView
    case testView
    case settingView
    case mypageView
}

//@Observable
final class NavigationManager: ObservableObject {

    @Published var path = NavigationPath() {
        didSet {
            print("path는?\(path.count) 개수 \(path)")
        }
    }
    @Published var navigatePath = [AllNavigation]() {
        didSet {
            print("path는?\(navigatePath)")
        }
    }

    func popToRootView() {
        path.removeLast(path.count)
    }
    func printPath() {
        print(path)
    }

    func navigate(_ route: AllNavigation) {
        navigatePath.append(route)
    }
    func back() {
        navigatePath.removeLast()
    }
    func countPop(count: Int) {
        navigatePath.removeLast(count)
    }
    func countDeque(count: Int) {
        navigatePath.removeFirst(count)
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
