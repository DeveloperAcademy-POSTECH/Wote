//
//  VoteContentViewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 10/21/23.
//

import SwiftUI

import Combine

final class ConsiderationViewModel: ObservableObject {
    // TODO: - fetch data
    var isVoted: Bool = true
    var agreeCount: Int = 33
    var disagreeCount: Int = 62
    private let apiManager: NewApiManager
    var cancellables: Set<AnyCancellable> = []
    var totalCount: Int {
        return agreeCount + disagreeCount
    }
    @Published var posts: [PostResponseDto] = []
    @Published var isLoading: Bool = false
    init(apiManager: NewApiManager) {
        self.apiManager = apiManager
    }
    var buyCountRatio: Double {
        guard totalCount > 0 else { return 0.0 }
        return round(Double(agreeCount) / Double(totalCount) * 1000) / 10
    }

    var notBuyCountRatio: Double {
        return 100 - buyCountRatio
    }

    func fetchPosts(page: Int = 0, size: Int = 10, visibilityScope: String) {
        apiManager.request(.postService(.getPosts(page: page,
                                                  size: size,
                                                  visibilityScope: visibilityScope)),
                           decodingType: [PostResponseDto].self)
        .receive(on: DispatchQueue.main)
        .sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let failure):
                print(failure)
            }
        } receiveValue: { response in
            if let data = response.data {
                self.posts.append(contentsOf: data)
            }
        }
        .store(in: &cancellables)
    }

}
