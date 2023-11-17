//
//  MyPageViewModel.swift
//  TwoHoSun
//
//  Created by 관식 on 11/17/23.
//

import SwiftUI

@Observable
final class MyPageViewModel {
    var posts: [MyPostModel] = [MyPostModel(id: 0, createDate: "2021-05-30T14:00:00Z", modifiedDate: "2021-05-30T14:00:00Z", postStatus: "ClOSED", voteResult: "BUY", title: "ACG 마운틴 플라이", image: "https://picsum.photos/200", contents: "어쩌고저쩌고 50자 미만 어쩌고저쩌고 50자 미만 어쩌고저쩌고 50자 미만", price: 1000, hasReview: false)]
    let apiManager: NewApiManager
    
    init(apiManager: NewApiManager) {
        self.apiManager = apiManager
    }
}
