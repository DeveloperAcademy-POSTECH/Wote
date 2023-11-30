//
//  ConsiderationViewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 11/21/23.
//

import Combine
import SwiftUI

final class ConsiderationViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var error: NetworkError?
    @Published var currentVote = 0
    private var cancellables: Set<AnyCancellable> = []
    private var isLastPage = false
    private var page = 0
    private var appLoginState: AppLoginState

    init(appLoginState: AppLoginState) {
        self.appLoginState = appLoginState
    }

    func fetchPosts(page: Int = 0,
                    size: Int = 5,
                    visibilityScope: VisibilityScopeType,
                    isFirstFetch: Bool = true,
                    isRefresh: Bool = false) {
        if isFirstFetch {
            appLoginState.appData.postManager.posts.removeAll()
            isLastPage = false
            isLoading = true
            currentVote = 0
            self.page = 0
        }

        if isRefresh {
            appLoginState.appData.postManager.posts.removeAll()
            isLastPage = false
            self.page = 0
        }

        appLoginState.serviceRoot.apimanager
            .request(.postService(.getPosts(page: page,
                                            size: size,
                                            visibilityScope: visibilityScope.rawValue)),
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
            self.appLoginState.appData.postManager.posts.append(contentsOf: data)
            self.isLastPage = data.count < 5
            self.isLoading = false
        }
        .store(in: &cancellables)
    }

    func fetchMorePosts(_ visibilityScope: VisibilityScopeType) {
        guard !isLastPage else { return }

        page += 1
        fetchPosts(page: page,
                   visibilityScope: visibilityScope,
                   isFirstFetch: false)
    }

    func votePost(postId: Int,
                  choice: Bool,
                  index: Int) {
        appLoginState.serviceRoot.apimanager.request(.postService(.votePost(postId: postId,
                                                                            choice: choice)),
                                                     decodingType: VoteCountsModel.self)
        .compactMap(\.data)
        .receive(on: DispatchQueue.main)
        .sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let failure):
                if failure == .noMember || failure == .noPost {
                    self.error = failure
                }
            }
        } receiveValue: { data in
            self.updatePost(index: index,
                            myChoice: choice,
                            voteCount: data)
        }
        .store(in: &cancellables)
    }

    func updatePost(index: Int,
                    myChoice: Bool,
                    voteCount: VoteCountsModel) {
        appLoginState.appData.postManager.posts[index].myChoice = myChoice
        appLoginState.appData.postManager.posts[index].voteCounts = voteCount
        appLoginState.appData.postManager.posts[index].voteCount = voteCount.agreeCount + voteCount.disagreeCount
    }

    func calculatVoteRatio(voteCounts: VoteCountsModel?) -> (agree: Double, disagree: Double) {
        guard let voteCounts = voteCounts else { return (0.0, 0.0) }
        let voteCount = voteCounts.agreeCount + voteCounts.disagreeCount
        
        guard voteCount != 0 else { return (0, 0) }
        let agreeRatio = Double(voteCounts.agreeCount) / Double(voteCount) * 100
        return (agreeRatio, 100 - agreeRatio)
    }
}
