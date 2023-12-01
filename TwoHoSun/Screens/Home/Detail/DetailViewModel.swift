//
//  DetailViewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 11/21/23.
//

import Combine
import SwiftUI

final class DetailViewModel: ObservableObject {
    private var appLoginState: AppLoginState
    private var cancellables: Set<AnyCancellable> = []
    @Published var isMine = false
    @Published var error: NetworkError? 
    @Published var postDetail: PostDetailModel?
    @Published var agreeTopConsumerTypes = [ConsumerType]()
    @Published var disagreeTopConsumerTypes = [ConsumerType]()

    init(appLoginState: AppLoginState) {
        self.appLoginState = appLoginState
    }

    func searchPostIndex(with postId: Int) -> Int? {
        guard let index = appLoginState.appData.postManager.posts.firstIndex(where: { $0.id == postId }) else { return nil }
        return index
    }

    func searchMyPostIndex(with postId: Int) -> Int? {
        guard let index = appLoginState.appData.postManager.myPosts.firstIndex(where: { $0.id == postId }) else { return nil }
        return index
    }

    func fetchPostDetail(postId: Int) {
        appLoginState.serviceRoot.apimanager
            .request(.postService(.getPostDetail(postId: postId)),
                           decodingType: PostDetailModel.self)
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
            self.postDetail = data
            guard let isMine = data.post.isMine else { return }
            self.isMine = isMine
            self.setTopConsumerTypes()
        }
        .store(in: &cancellables)
    }

    func votePost(postId: Int,
                  choice: Bool,
                  index: Int?) {
        appLoginState.serviceRoot.apimanager
            .request(.postService(.votePost(postId: postId, choice: choice)),
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
            if let postIndex = index {
                self.updatePost(index: postIndex,
                                myChoice: choice,
                                voteCount: data)
            }
            self.fetchPostDetail(postId: postId)
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

    func updateMyPost(index: Int) {
        appLoginState.appData.postManager.myPosts[index].postStatus = PostStatus.closed.rawValue
    }

    func deletePost(postId: Int) {
        appLoginState.serviceRoot.apimanager
            .request(.postService(.deletePost(postId: postId)),
                            decodingType: NoData.self)
             .sink { completion in
                 switch completion {
                 case .finished:
                     break
                 case .failure(let error):
                     print("error: \(error)")
                 }
             } receiveValue: { _ in
//                 self.appLoginState.appData.postManager.deleteReviews(postId: postId)
//                 self.appLoginState.appData.postManager.removeCount += 1
                 NotificationCenter.default.post(name: NSNotification.voteStateUpdated, object: nil)
             }
             .store(in: &cancellables)
     }

     func closePost(postId: Int, index: (Int?, Int?)) {
         appLoginState.serviceRoot.apimanager
             .request(.postService(.closeVote(postId: postId)),
                            decodingType: NoData.self)
             .sink { completion in
                 switch completion {
                 case .finished:
                     break
                 case .failure(let error):
                     print("error: \(error)")
                 }
             } receiveValue: { _ in
                 if let postIndex = index.0 {
                     self.appLoginState.appData.postManager.posts[postIndex].postStatus
                            = PostStatus.closed.rawValue
                 }

                 if let myPostIndex = index.1 {
                     self.appLoginState.appData.postManager.myPosts[myPostIndex].postStatus
                            = PostStatus.closed.rawValue
                 }
                 self.fetchPostDetail(postId: postId)
             }
             .store(in: &cancellables)

     }

    func calculatVoteRatio(voteCounts: VoteCountsModel?) -> (agree: Double, disagree: Double) {
        guard let voteCounts = voteCounts else { return (0.0, 0.0) }
        let voteCount = voteCounts.agreeCount + voteCounts.disagreeCount

        guard voteCount != 0 else { return (0, 0) }
        let agreeRatio = Double(voteCounts.agreeCount) / Double(voteCount) * 100
        return (agreeRatio, 100 - agreeRatio)
    }

    private func setTopConsumerTypes() {
        guard let voteInfoList = postDetail?.post.voteInfoList else { return }
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
