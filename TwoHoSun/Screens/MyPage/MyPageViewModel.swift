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
    var profile: ProfileModel?
    var cacellabels: Set<AnyCancellable> = []
    var total = 0
    private var votePage = 0
    private var reviewPage = 0
    private var isVoteLastPage = false
    private var isReviewLastPage = false

//    var postCount: Int {
//        let removeCount = switch selectedMyPageListType {
//                          case .myVote:
//                                loginState.appData.postManager.removeCount
//                          case .myReview:
//                                loginState.appData.reviewManager.removeCount
//                          }
//        return total - removeCount
//    }

    init(loginState: AppLoginState) {
        self.loginState = loginState
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
                    self.loginState.appData.postManager.myPosts.append(contentsOf: data.posts)
                case .myReview:
                    self.loginState.appData.reviewManager.myReviews.append(contentsOf: data.posts)
                }

                if data.posts.isEmpty || data.posts.count % 10 != 0 {
                    switch self.selectedMyPageListType {
                    case .myVote:
                        self.isVoteLastPage = true
                    case .myReview:
                        self.isReviewLastPage = true
                    }
                }
                self.total = data.total
            }
            .store(in: &cacellabels)
    }

    func fetchPosts(isFirstFetch: Bool = true) {
        if isFirstFetch {
            loginState.appData.reviewManager.myReviews.removeAll()
            loginState.appData.postManager.myPosts.removeAll()
//            loginState.appData.postManager.removeCount = 0
//            loginState.appData.reviewManager.removeCount = 0
            votePage = 0
            reviewPage = 0
            isVoteLastPage = false
            isReviewLastPage = false
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
        switch selectedMyPageListType {
        case .myVote:
            guard !isVoteLastPage else { return }
            votePage += 1
        case .myReview:
            guard !isReviewLastPage else { return }
            reviewPage += 1
        }
        fetchPosts(isFirstFetch: false)
    }
}
