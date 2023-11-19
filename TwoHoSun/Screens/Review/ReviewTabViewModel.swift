//
//  ReviewTabViewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 11/19/23.
//

import Combine
import SwiftUI

final class ReviewTabViewModel: ObservableObject {
    @Published var consumerType: ConsumerType? = nil
    @Published var reviews: ReviewTabModel? = nil
    @Published var isFetching = true
    private var apiManager: NewApiManager
    private var cancellable = Set<AnyCancellable>()

    init(apiManger: NewApiManager) {
        self.apiManager = apiManger
        fetchReviews(for: .global)
    }

    func fetchReviews(for visibilityScope: VisibilityScopeType) {
        isFetching = true

        apiManager.request(.postService(.getReviews(visibilityScope: visibilityScope.rawValue)), decodingType: ReviewTabModel.self)
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
}
