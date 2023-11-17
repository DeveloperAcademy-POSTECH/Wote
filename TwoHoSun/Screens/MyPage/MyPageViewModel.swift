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
    let apiManager: NewApiManager
    var posts: [MyPosts] = []
    var cacellabels: Set<AnyCancellable> = []
    var isLoading: Bool = false
    
    init(apiManager: NewApiManager) {
        self.apiManager = apiManager
    }
    
    func fetchPosts(myVoteCategoryType: String) {
        isLoading = true
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
                self.posts.append(contentsOf: data.posts)
                self.isLoading = false
            }
            .store(in: &cacellabels)
    }
}
