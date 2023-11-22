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
    @Published var consumerType: ConsumerType?
    @Published var isFetching = true
    private var loginState: AppLoginState
    private var cancellable = Set<AnyCancellable>()
    private var allTypePagination = PaginationState()
    private var purchasedTypePagination = PaginationState()
    private var notPurchasedTypePagination = PaginationState()

    init(loginState: AppLoginState) {
        self.loginState = loginState
    }

    func resetReviews() {
        allTypePagination.resetPagination()
        purchasedTypePagination.resetPagination()
        notPurchasedTypePagination.resetPagination()
        loginState.appData.reviewManager.reviews?.allReviews.removeAll()
        loginState.appData.reviewManager.reviews?.purchasedReviews.removeAll()
        loginState.appData.reviewManager.reviews?.notPurchasedReviews.removeAll()
    }

    func fetchReviews(for visibilityScope: VisibilityScopeType) {
        isFetching = true
        resetReviews()
        
        loginState.serviceRoot.apimanager
            .request(.postService(.getReviews(visibilityScope: visibilityScope.rawValue)),
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
                self.consumerType = ConsumerType(rawValue: data.myConsumerType
                                                 ?? ConsumerType.adventurer.rawValue)
                self.loginState.appData.reviewManager.reviews = data
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

        loginState.serviceRoot.apimanager
            .request(.postService(.getMoreReviews(visibilityScope: visibilityScope.rawValue,
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
                    self.loginState.appData.reviewManager
                        .reviews?.allReviews.append(contentsOf: data)
                case .purchased:
                    self.loginState.appData.reviewManager
                        .reviews?.purchasedReviews.append(contentsOf: data)
                case .notPurchased:
                    self.loginState.appData.reviewManager
                        .reviews?.notPurchasedReviews.append(contentsOf: data)
                }

                state.currentPage += 1
                state.isLastPage = data.count < 5
            }
            .store(in: &cancellable)
    }
}
