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
    private var loginState: AppLoginState
    var posts: [SummaryPostModel] = []
    var profile: ProfileModel?
    var cacellabels: Set<AnyCancellable> = []
    var total = 0
    private var votePage = 0
    private var reviewPage = 0
    private var isLastPage: Bool = false

    init(loginState: AppLoginState) {
        self.loginState = loginState
        self.fetchProfile()
    }

    func requestPosts(postType: PostService) {
        loginState.serviceRoot.apimanager
            .request(.postService(postType), decodingType: MyPostModel.self)
            .compactMap(\.data)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { data in
                switch self.selectedMyPageListType {
                case .myVote:
                    self.posts.append(contentsOf: data.posts)
                case .myReview:
                    self.loginState.appData.reviewManager.myReviews.append(contentsOf: data.posts)
                }
                if data.posts.isEmpty || self.posts.count % 10 != 0 {
                    self.isLastPage = true
                }
                self.total = data.total
            }
            .store(in: &cacellabels)
    }
    
    func fetchPosts(isFirstFetch: Bool = true) {
        if isFirstFetch {
            loginState.appData.reviewManager.myReviews.removeAll()
            votePage = 0
            reviewPage = 0
            isLastPage = false
        }
        
        switch selectedMyPageListType {
        case .myVote:
            requestPosts(postType: .getMyPosts(page: votePage,
                                               size: 10,
                                               myVoteCategoryType: selectedMyVoteCategoryType.parameter))
        case .myReview:
            requestPosts(postType: .getMyReviews(page: reviewPage,
                                                 size: 10,
                                                 myReviewCategoryType: selectedMyReviewCategoryType.parameter))
        }
    }
    
    func fetchMorePosts() {
        guard !isLastPage else { return }
        switch selectedMyPageListType {
        case .myVote:
            votePage += 1
        case .myReview:
            reviewPage += 1
        }
        fetchPosts(isFirstFetch: false)
    }

    func fetchProfile() {
        loginState.serviceRoot.apimanager
            .request(.userService(.getProfile), decodingType: ProfileModel.self)
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
