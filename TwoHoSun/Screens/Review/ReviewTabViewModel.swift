//
//  ReviewTabViewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 11/19/23.
//

import Combine
import SwiftUI

final class ReviewTabViewModel: ObservableObject {
    @Published var reviews = [SummaryPostModel]()
    @Published var recentReviews = [SummaryPostModel]()
    @Published var isFetching = true
    private var apiManager: NewApiManager
    private var cancellable = Set<AnyCancellable>()

    init(apiManger: NewApiManager) {
        self.apiManager = apiManger
        fetchReviews(for: .global, type: .all)
    }

    func fetchReviews(for visibilityScope: VisibilityScopeType,
                      type reviewType: ReviewType,
                      page: Int = 0,
                      size: Int = 5) {
        reviews.removeAll()
        recentReviews.removeAll()
        isFetching = true

        apiManager.request(.postService(.getReviews(visibilityScope: visibilityScope.rawValue,
                                                    reviewType: reviewType.rawValue,
                                                    page: page,
                                                    size: size)),
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
            self.recentReviews.append(contentsOf: data.recentReviews)
            self.reviews.append(contentsOf: data.reviews)
            self.isFetching = false
        }
        .store(in: &cancellable)
    }
}
