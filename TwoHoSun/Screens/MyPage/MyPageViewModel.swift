//
//  MyPageViewModel.swift
//  TwoHoSun
//
//  Created by 관식 on 11/17/23.
//

import Combine
import SwiftUI

@Observable
final class MyPageViewModel {
    var posts: [MyPostModel] = [MyPostModel(id: 0, createDate: "2021-05-30T14:00:00Z", modifiedDate: "2021-05-30T14:00:00Z", postStatus: "ClOSED", voteResult: "BUY", title: "ACG 마운틴 플라이", image: "https://picsum.photos/200", contents: "어쩌고저쩌고 50자 미만 어쩌고저쩌고 50자 미만 어쩌고저쩌고 50자 미만", price: 1000, hasReview: false)]
    let apiManager: NewApiManager
    var cacellabels: Set<AnyCancellable> = []
    
    init(apiManager: NewApiManager) {
        self.apiManager = apiManager
    }
    
    func fetchPosts(myVoteCategoryType: String) {
        apiManager.request(.postService(.getMyPosts(page: 0, size: 10, myVoteCategoryType: myVoteCategoryType)), decodingType: MyPostModel.self)
            .compactMap(\.data)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { data in
                self.posts.append(data)
            }
            .store(in: &cacellabels)
    }
}
