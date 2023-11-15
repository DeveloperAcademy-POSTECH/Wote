//
//  VoteContentViewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 10/21/23.
//

import SwiftUI

import Combine

final class ConsiderationViewModel: ObservableObject {
    @Published var votes = [PostResponseDto]()
    @Published var isPostFetching = true
    @Published var pageOffset = 0
    private let apiManager = NewApiManager()
    private var page = 0
    var cancellables: Set<AnyCancellable> = []
    private var isLastPage = false

    init() {
        fetchPosts(visibilityScope: VisibilityScopeType.global.type)
    }

    func fetchMorePosts(_ visibilityScope: String) {
        guard !isLastPage else { return }

        page += 1
        fetchPosts(page: page,
                   visibilityScope: visibilityScope,
                   isFirstFetch: false)
    }

    func fetchPosts(page: Int = 0,
                    size: Int = 5,
                    visibilityScope: String,
                    isFirstFetch: Bool = true) {

        if isFirstFetch {
            self.isLastPage = false
            self.page = 0
            self.votes.removeAll()
            self.isPostFetching = true
        }

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
        } receiveValue: { [self] response in
            if let data = response.data {
                self.votes.append(contentsOf: data)
            }

            if isFirstFetch {
                isPostFetching = false
            }
        }
        .store(in: &cancellables)

        if self.votes.count % 5 != 0 {
            isLastPage = true
        }
    }
}
