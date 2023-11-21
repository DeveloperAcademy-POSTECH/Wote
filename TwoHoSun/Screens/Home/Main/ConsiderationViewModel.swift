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
    private var apiManager: VoteDataManager
    private var cancellables: Set<AnyCancellable> = []

    init(apiManager: VoteDataManager) {
        self.apiManager = apiManager
    }

    func fetchPosts(page: Int = 0,
                    size: Int = 10,
                    visibilityScope: VisibilityScopeType) {
        apiManager.fetchPosts(page: page,
                              size: size,
                              visibilityScope: visibilityScope)
    }

    func fetchMorePosts(visibilityScope: VisibilityScopeType) {
        apiManager.fetchMorePosts(visibilityScope)
    }

    func votePost(postId: Int,
                  choice: Bool,
                  index: Int) {
        apiManager.votePost(postId: postId,
                            choice: choice,
                            index: index)
    }

    func calculatVoteRatio(voteCounts: VoteCountsModel?) -> (agree: Double, disagree: Double) {
        guard let voteCounts = voteCounts else { return (0.0, 0.0) }
        let voteCount = voteCounts.agreeCount + voteCounts.disagreeCount
        
        guard voteCount != 0 else { return (0, 0) }
        let agreeRatio = Double(voteCounts.agreeCount) / Double(voteCount) * 100
        return (agreeRatio, 100 - agreeRatio)
    }
}
