//
//  ReviewTabViewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 11/19/23.
//

import Combine
import SwiftUI

final class ReviewTabViewModel: ObservableObject {
    @Published var recentReviews = [SummaryPostModel]()
    @Published var reviews = [SummaryPostModel]()
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
        // TODO: - type들 rawValue로 할 거니... type으로 할 거니 하나만 정해
        apiManager.request(.postService(.getReviews(visibilityScope: visibilityScope.type,
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
            self.isFetching = false
        }
        .store(in: &cancellable)
    }
}
