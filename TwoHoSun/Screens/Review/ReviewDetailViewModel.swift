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
                    print(failure)
                }
            } receiveValue: { data in
                self.reviewData = data
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
                    print(failure)
                }
            } receiveValue: { data in
                self.reviewData = data
                self.postId = data.originalPost.id
                self.reviewPostId = data.reviewPost.id
                self.isMine = data.isMine
            }
            .store(in: &cancellable)
    }

    // 투표 포스트 아이디 - 5760, 후기 포스트 아이디 - 5762
    func deleteReview(postId: Int) {
        loginState.serviceRoot.apimanager
            .request(.postService(.deleteReviewWithPostId(postId: postId)), 
                     decodingType: NoData.self)
            .compactMap(\.data)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let failure):
                    print(failure)
                }
            } receiveValue: { _ in
            }
            .store(in: &cancellable)

        // 지금 postid 5760임, 얘는 리뷰 아이디로 삭제해야 함
        loginState.appData.reviewManager.deleteReviews(with: reviewPostId)
    }
}
