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
    private var apiManager: NewApiManager
    private var cancellable = Set<AnyCancellable>()

    init(apiManager: NewApiManager) {
        self.apiManager = apiManager
    }

    func fetchReviewDetail(reviewId: Int) {
        apiManager.request(.postService(.getReviewDetailWithReviewId(reviewId: reviewId)),
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
            self.isMine = data.isMine
        }
        .store(in: &cancellable)
    }

    func fetchReviewDetail(postId: Int) {
        apiManager.request(.postService(.getReviewDetailWithPostId(postId: postId)),
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
            self.isMine = data.isMine
        }
        .store(in: &cancellable)
    }

    func deleteReview(postId: Int) {
        apiManager.request(.postService(.deleteReviewWithPostId(postId: postId)), decodingType: NoData.self)
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
    }
}
