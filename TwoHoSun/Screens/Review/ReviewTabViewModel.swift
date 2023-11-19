//
//  ReviewTabViewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 11/19/23.
//

import Combine
import SwiftUI

class PaginationState {
    var currentPage = 1
    var isLastPage = false

    func resetPagination() {
        currentPage = 1
        isLastPage = false
    }
}

final class ReviewTabViewModel: ObservableObject {
    @Published var consumerType: ConsumerType? = nil
    @Published var reviews: ReviewTabModel? = nil
    @Published var isFetching = true
    private var apiManager: NewApiManager
    private var cancellable = Set<AnyCancellable>()
    private var allTypePagination = PaginationState()
    private var purchasedTypePagination = PaginationState()
    private var notPurchasedTypePagination = PaginationState()

    init(apiManger: NewApiManager) {
        self.apiManager = apiManger
        fetchReviews(for: .global)
    }

    func resetReviews() {
        allTypePagination.resetPagination()
        purchasedTypePagination.resetPagination()
        notPurchasedTypePagination.resetPagination()
        reviews?.allReviews.removeAll()
        reviews?.purchasedReviews.removeAll()
        reviews?.notPurchasedReviews.removeAll()
    }

    func fetchReviews(for visibilityScope: VisibilityScopeType) {
        isFetching = true
        resetReviews()
        
        apiManager.request(.postService(.getReviews(visibilityScope: visibilityScope.rawValue)),
                           decodingType: ReviewTabModel.self)
        .compactMap(\.data)
        .sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print(error)
            }
        } receiveValue: { data in
            self.reviews = data
            self.isFetching = false
        }
        .store(in: &cancellable)
    }

    func fetchMoreReviews(for visibilityScope: VisibilityScopeType,
                          filter reviewType: ReviewType) {

        var state: PaginationState

        switch reviewType {
        case .all:
            state = allTypePagination
        case .purchased:
            state = purchasedTypePagination
        case .notPurchased:
            state = notPurchasedTypePagination
        }

        guard !state.isLastPage else {
            return
        }

        apiManager.request(.postService(.getMoreReviews(visibilityScope: visibilityScope.rawValue,
                                                        page: state.currentPage,
                                                        size: 5,
                                                        reviewType: reviewType.rawValue)),
                           decodingType: [SummaryPostModel].self)
        .compactMap(\.data)
        .sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print(error)
            }
        } receiveValue: { data in
            switch reviewType {
            case .all:
                self.reviews?.allReviews.append(contentsOf: data)
            case .purchased:
                self.reviews?.purchasedReviews.append(contentsOf: data)
            case .notPurchased:
                self.reviews?.notPurchasedReviews.append(contentsOf: data)
            }

            state.currentPage += 1
            state.isLastPage = data.count < 5
        }
        .store(in: &cancellable)
    }
}
