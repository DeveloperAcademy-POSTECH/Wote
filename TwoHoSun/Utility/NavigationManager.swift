//
//  NavigationManager.swift
//  TwoHoSun
//
//  Created by 235 on 11/15/23.
//

import SwiftUI

enum AllNavigation: Hashable, Decodable {
    case writeReiview
    case detailView(postId: Int, dirrectComments: Bool = false, isShowingItems: Bool = true)
    case reveiwView
    case makeVoteView
    case testIntroView
    case testView
    case settingView
    case mypageView
    case searchView
    case notiView
    case reviewDetailView(postId: Int?, reviewId: Int?, isShowingItems: Bool = true)
}

@Observable
final class NavigationManager {
    var navigatePath = [AllNavigation]()

    func navigate(_ route: AllNavigation) {
        guard !navigatePath.contains(route) else {
            return
        }
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
}
