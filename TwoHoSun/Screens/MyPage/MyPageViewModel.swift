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
    var selectedMyPageListType = MyPageListType.myVote
    var selectedMyVoteCategoryType = MyVoteCategoryType.all
    var selectedMyReviewCategoryType = MyReviewCategoryType.all
    let apiManager: NewApiManager
    var posts: [SummaryPostModel] = []
    var profile: ProfileModel?
    var cacellabels: Set<AnyCancellable> = []
    private var page: Int = 0
    private var isLastPage: Bool = false
    
    init(apiManager: NewApiManager) {
        self.apiManager = apiManager
        self.fetchProfile()
    }
    
    func requestPosts(postType: PostService) {
        apiManager.request(.postService(postType), decodingType: MyPostModel.self)
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
    
    func fetchPosts(isFirstFetch: Bool = true) {
        if isFirstFetch {
            posts.removeAll()
            page = 0
            isLastPage = false
        }
        
        switch selectedMyPageListType {
        case .myVote:
            requestPosts(postType: .getMyPosts(page: page, size: 10, myVoteCategoryType: selectedMyVoteCategoryType.parameter))
        case .myReview:
            requestPosts(postType: .getMyReviews(page: page, size: 10, myReviewCategoryType: selectedMyReviewCategoryType.parameter))
        }
    }
    
    func fetchMorePosts() {
        guard !isLastPage else { return }
        page += 1
        fetchPosts(isFirstFetch: false)
    }
    
    func fetchProfile() {
        apiManager.request(.userService(.getProfile), decodingType: ProfileModel.self)
            .compactMap(\.data)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { data in
                self.profile = data
            }
            .store(in: &cacellabels)
    }
}
