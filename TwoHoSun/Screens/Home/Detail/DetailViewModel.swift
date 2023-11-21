//
//  DetailViewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 11/21/23.
//

import Combine
import SwiftUI

@Observable
final class DetailViewModel {
    private var apiManager: VoteDataManager
    var postData: PostDetailModel?
    var isMine = false
    var agreeTopConsumerTypes = [ConsumerType]()
    var disagreeTopConsumerTypes = [ConsumerType]()
    private var cancellables: Set<AnyCancellable> = []

    init(apiManager: VoteDataManager) {
        self.apiManager = apiManager
        setupDataSubscriber()
    }

    func setupDataSubscriber() {
        apiManager.dataPublisher
            .sink { [weak self] data in
                self?.postData = data
                guard let isVoteMine = data.post.isMine else { return }
                self?.isMine = isVoteMine
                self?.setTopConsumerTypes()
            }
            .store(in: &cancellables)
    }

    func fetchPostDetail(postId: Int) {
        apiManager.fetchPostDetail(postId: postId)

    }

    func votePost(postId: Int,
                  choice: Bool,
                  index: Int) {
        apiManager.votePost(postId: postId,
                            choice: choice,
                            index: index)
    }

    func closeVote(postId: Int, index: Int) {
        apiManager.closePost(postId: postId,
                             index: index)
    }

    func deleteVote(postId: Int, index: Int) {
        apiManager.deletePost(postId: postId,
                              index: index)
    }

    func calculatVoteRatio(voteCounts: VoteCountsModel?) -> (agree: Double, disagree: Double) {
        guard let voteCounts = voteCounts else { return (0.0, 0.0) }
        let voteCount = voteCounts.agreeCount + voteCounts.disagreeCount

        guard voteCount != 0 else { return (0, 0) }
        let agreeRatio = Double(voteCounts.agreeCount) / Double(voteCount) * 100
        return (agreeRatio, 100 - agreeRatio)
    }

    private func setTopConsumerTypes() {
        guard let voteInfoList = postData?.post.voteInfoList else { return }
        let (agreeVoteInfos, disagreeVoteInfos) = filterSelectedResult(voteInfoList: voteInfoList)
        agreeTopConsumerTypes = getTopConsumerTypes(for: agreeVoteInfos)
        disagreeTopConsumerTypes = getTopConsumerTypes(for: disagreeVoteInfos)
    }

    private func filterSelectedResult(voteInfoList: [VoteInfoModel]) -> (agree: [VoteInfoModel],
                                                                disagree: [VoteInfoModel]) {
        return (voteInfoList.filter { $0.isAgree }, voteInfoList.filter { !$0.isAgree })
    }

    private func getTopConsumerTypes(for votes: [VoteInfoModel]) -> [ConsumerType] {
        return Dictionary(grouping: votes, by: { $0.consumerType })
            .sorted { $0.value.count > $1.value.count }
            .prefix(2)
            .map { ConsumerType(rawValue: $0.key) }
            .compactMap { $0 }
    }
}
