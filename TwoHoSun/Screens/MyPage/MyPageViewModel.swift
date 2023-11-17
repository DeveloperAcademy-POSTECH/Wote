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
    var posts: [SummaryPostModel] = []
    var cacellabels: Set<AnyCancellable> = []
    private var page: Int = 0
    private var isLastPage: Bool = false
    
    init(apiManager: NewApiManager) {
        self.apiManager = apiManager
    }
    
    func fetchPosts(myVoteCategoryType: String, isFirstFetch: Bool = true) {
        if isFirstFetch {
            posts.removeAll()
            page = 0
            isLastPage = false
        }
        
        apiManager.request(.postService(.getMyPosts(page: page, size: 10, myVoteCategoryType: myVoteCategoryType)), decodingType: MyPostModel.self)
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
                if data.posts.isEmpty || self.posts.count % 10 != 0 {
                    self.isLastPage = true
                }
            }
            .store(in: &cacellabels)
    }
    
    func fetchMorePosts(_ myVoteCategoryType: String) {
        guard !isLastPage else { return }
        page += 1
        fetchPosts(myVoteCategoryType: myVoteCategoryType, isFirstFetch: false)
    }
}
