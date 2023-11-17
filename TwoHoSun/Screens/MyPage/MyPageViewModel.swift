//
//  MyPageViewModel.swift
//  TwoHoSun
//
//  Created by 관식 on 11/17/23.
//

import SwiftUI

@Observable
final class MyPageViewModel {
    var post: [MyPostModel] = []
    let apiManager: NewApiManager
    
    init(apiManager: NewApiManager) {
        self.apiManager = apiManager
    }
}
