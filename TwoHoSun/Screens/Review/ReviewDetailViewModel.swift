//
//  ReviewDetailViewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 11/20/23.
//

import Combine
import SwiftUI

final class ReviewDetailViewModel: ObservableObject {
    @Published var reviewData: ReviewDetailModel?
    @Published var postId = 0
    @Published var isMine = false
    @Published var reviewId = 0
    @Published var error: NetworkError?
    private var loginState: AppLoginState
    private var cancellable = Set<AnyCancellable>()
    private var reviewPostId = 0

    init(loginState: AppLoginState) {
        self.loginState = loginState
    }

    func fetchReviewDetail(reviewId: Int) {
        loginState.serviceRoot.apimanager
            .request(.postService(.getReviewDetailWithReviewId(reviewId: reviewId)),
                     decodingType: ReviewDetailModel.self)
            .compactMap(\.data)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let failure):
                    if failure == .noMember || failure == .noPost {
                        self.error = failure
                    }
                }
            } receiveValue: { data in
                self.reviewData = data
                self.reviewId = data.reviewPost.id
                self.postId = data.originalPost.id
                self.reviewPostId = data.reviewPost.id
                self.isMine = data.isMine
            }
            .store(in: &cancellable)
    }

    func fetchReviewDetail(postId: Int) {
        loginState.serviceRoot.apimanager
            .request(.postService(.getReviewDetailWithPostId(postId: postId)),
                     decodingType: ReviewDetailModel.self)
            .compactMap(\.data)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let failure):
                    if failure == .noMember || failure == .noPost {
                        self.error = failure
                    }
                }
            } receiveValue: { data in
                self.reviewData = data
                self.reviewId = data.reviewPost.id
                self.postId = data.originalPost.id
                self.reviewPostId = data.reviewPost.id
                self.isMine = data.isMine
            }
            .store(in: &cancellable)
    }

    func deleteReview(postId: Int) {
        loginState.serviceRoot.apimanager
            .request(.postService(.deleteReviewWithPostId(postId: postId)), 
                     decodingType: NoData.self)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let failure):
                    print(failure)
                }
            } receiveValue: { _ in
                NotificationCenter.default.post(name: NSNotification.reviewStateUpdated, object: nil)
            }
            .store(in: &cancellable)
    }
}
