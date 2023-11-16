//
//  NavigationManager.swift
//  TwoHoSun
//
//  Created by 235 on 11/15/23.
//

import SwiftUI

enum LoginNavigation {
    case mainTabView
    case profileView
}
enum AlertNavigation {
    case voteView(id: String)
    case reviewView(id: String)
}
enum AllNavigation: Hashable, Decodable {
    case writeReiview
    case detailView(postId: Int)
    case reveiwView
    case makeVoteView
    case testIntroView
    case testView
    case settingView
    case mypageView
}

final class NavigationManager: ObservableObject {
    @Published var navigatePath = [AllNavigation]() {
        didSet {
            print("path는?\(navigatePath)")
        }
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
}