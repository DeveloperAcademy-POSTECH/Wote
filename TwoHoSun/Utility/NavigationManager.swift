//
//  NavigationManager.swift
//  TwoHoSun
//
//  Created by 235 on 11/15/23.
//

import SwiftUI

//enum MainNavigation {
//    case mainView
//    case detailView
//    case alertView
//    case searchView
//    case reveiwView
//    case makeVoteView
//    case testView
//}
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
//enum LoginNavigation {
//    case mainTabView
//    case profileView
//}
@Observable
final class NavigationManager {

    var navigationPath = [AllNavigation]()
    func popToRootView(_ view: AllNavigation) {
        navigationPath.removeAll()

    }
}
