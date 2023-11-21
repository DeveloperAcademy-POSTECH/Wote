//
//  ConsiderationViewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 11/21/23.
//

import Combine
import SwiftUI

@Observable
final class ConsiderationViewModel {
    private var appLoginState: AppLoginState
    var isLastPage = false
    var page = 0
    var isLoading = true
    private var cancellables: Set<AnyCancellable> = []

    init(appLoginState: AppLoginState) {
        self.appLoginState = appLoginState
    }

    func fetchPosts(page: Int = 0,
                    size: Int = 10,
                    visibilityScope: VisibilityScopeType,
                    isFirstFetch: Bool = true,
                    isRefresh: Bool = false) {

        if isFirstFetch && !isRefresh {
            self.appLoginState.appData.posts.removeAll()
            isLoading = true
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
            self.appLoginState.appData.posts.append(contentsOf: data)
            self.isLastPage = data.count < 10
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
                print(failure)
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
        appLoginState.appData.posts[index].myChoice = myChoice
        appLoginState.appData.posts[index].voteCounts = voteCount
        appLoginState.appData.posts[index].voteCount = voteCount.agreeCount + voteCount.disagreeCount
    }

    func calculatVoteRatio(voteCounts: VoteCountsModel?) -> (agree: Double, disagree: Double) {
        guard let voteCounts = voteCounts else { return (0.0, 0.0) }
        let voteCount = voteCounts.agreeCount + voteCounts.disagreeCount
        
        guard voteCount != 0 else { return (0, 0) }
        let agreeRatio = Double(voteCounts.agreeCount) / Double(voteCount) * 100
        return (agreeRatio, 100 - agreeRatio)
    }
}
