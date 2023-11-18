//
//  VoteContentViewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 10/21/23.
//

import SwiftUI

import Combine

final class VoteViewModel: ObservableObject {
    @Published var posts = [PostModel]()
    @Published var postData: PostDetailModel?
    @Published var isPostFetching = true
    @Published var pageOffset = 0
    @Published var isMine = false
    var agreeCount = 0
    var disagreeCount = 0
    var myChoice = true
    var agreeTopConsumerTypes = [ConsumerType]()
    var disagreeTopConsumerTypes = [ConsumerType]()
    var cancellables: Set<AnyCancellable> = []
    private let apiManager: NewApiManager
    private var page = 0
    private var isLastPage = false

    init(apiManager: NewApiManager) {
        self.apiManager = apiManager
        fetchPosts(visibilityScope: VisibilityScopeType.global.type)
    }

    func updatePost(index: Int) {
        posts[index].myChoice = myChoice
        posts[index].voteCount = agreeCount + disagreeCount
        posts[index].voteCounts = VoteCountsModel(agreeCount: agreeCount,
                                                  disagreeCount: disagreeCount)
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

    func votePost(postId: Int, choice: Bool, index: Int) {
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
            self.myChoice = choice
            self.updatePost(index: index)
            self.fetchPostDetail(postId: postId)
        }
        .store(in: &cancellables)
    }

    func fetchPostDetail(postId: Int) {
        apiManager.request(.postService(.getPostDetail(postId: postId)),
                           decodingType: PostDetailModel.self)
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
            self.postData = data
            guard let isMine = data.post.isMine else { return }
            self.isMine = isMine
            self.setTopConsumerTypes()
        }
        .store(in: &cancellables)
    }

    func deletePost(postId: Int, index: Int) {
        apiManager.request(.postService(.deletePost(postId: postId)),
                           decodingType: NoData.self)
            .compactMap(\.data)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("error: \(error)")
                }
            } receiveValue: { _ in
            }
            .store(in: &cancellables)

        posts.remove(at: index)
    }

    func closeVote(postId: Int, index: Int) {
        apiManager.request(.postService(.closeVote(postId: postId)),
                           decodingType: NoData.self)
            .compactMap(\.data)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("error: \(error)")
                }
            } receiveValue: { _ in
            }
            .store(in: &cancellables)

        posts[index].postStatus = PostStatus.closed.rawValue
    }

    func calculateVoteRatio(voteCount: Int,
                            agreeCount: Int,
                            disagreeCount: Int) -> (agree: Double, disagree: Double) {
        guard voteCount != 0 else { return (0, 0)}
        let agreeVoteRatio = Double(agreeCount) / Double(voteCount) * 100
        return (agreeVoteRatio, 100.0 - agreeVoteRatio)
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


