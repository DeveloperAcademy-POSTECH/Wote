//
//  VoteContentViewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 10/21/23.
//

import SwiftUI

import Combine

final class ConsiderationViewModel: ObservableObject {
    @Published var posts = [PostModel]()
    @Published var isPostFetching = true
    @Published var pageOffset = 0
    @Published var voteCount: Int?
    private let apiManager: NewApiManager
    private var page = 0
    private var isLastPage = false
    var agreeCount = 0
    var disagreeCount = 0
    var cancellables: Set<AnyCancellable> = []

    var agreeRatio: Double {
        guard let voteCount else { return 1.0 }
        return Double(agreeCount) / Double(voteCount) * 100
    }

    var disagreeRatio: Double {
        return 100.0 - agreeRatio
    }

    init(apiManager: NewApiManager) {
        self.apiManager = apiManager
        fetchPosts(visibilityScope: VisibilityScopeType.global.type)
    }

    func calculateVoteRatio(voteCount: Int,
                            agreeCount: Int,
                            disagreeCount: Int) -> (agree: Double, disagree: Double) {
        guard voteCount != 0 else { return (0, 0)}
        let agreeVoteRatio = Double(agreeCount) / Double(voteCount) * 10
        return (agreeVoteRatio, 100.0 - agreeVoteRatio)
    }

    func resetPosts() {
        posts.removeAll()
        page = 0
        isLastPage = false
        isPostFetching = true
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
            resetPosts()
        }

        apiManager.request(.postService(.getPosts(page: page,
                                                  size: size,
                                                  visibilityScope: visibilityScope)),
                           decodingType: [PostModel].self)
        .compactMap(\.data)
        .receive(on: DispatchQueue.main)
        .sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let failure):
                print(failure)
            }
        } receiveValue: { data in
            self.posts.append(contentsOf: data)

            if data.isEmpty || self.posts.count % 5 != 0 {
                self.isLastPage = true
            }

            if isFirstFetch {
                self.isPostFetching = false
            }
        }
        .store(in: &cancellables)

    }

    func votePost(postId: Int, choice: Bool) {
        apiManager.request(.postService(.votePost(postId: postId, choice: choice)),
                           decodingType: VoteCountsModel.self)
        .compactMap(\.data)
        .receive(on: DispatchQueue.main)
        .sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let failure):
                print(failure)
            }
        } receiveValue: { data in
            self.agreeCount = data.agreeCount
            self.disagreeCount = data.disagreeCount
            self.voteCount = self.agreeCount + self.disagreeCount
        }
        .store(in: &cancellables)
    }
}
