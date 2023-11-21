//
//  VoteDataManager.swift
//  TwoHoSun
//
//  Created by 김민 on 11/20/23.
//

import Combine
import SwiftUI

@Observable
final class VoteDataManager {
    var posts = [PostModel]()
    var isVoteMine = false
    private var apiManager: NewApiManager
    private var cancellables: Set<AnyCancellable> = []
    private var isLastPage = false
    private var page = 0
    var isFetching = true

    var dataPublisher = PassthroughSubject<PostDetailModel, Never>()

    init(apiManager: NewApiManager) {
        self.apiManager = apiManager
    }

    func resetPosts() {
        posts.removeAll()
        page = 0
        isLastPage = false
    }

    func fetchPosts(page: Int,
                    size: Int = 10,
                    visibilityScope: VisibilityScopeType,
                    isFirstFetch: Bool = true) {

        if isFirstFetch {
            isFetching = true
            resetPosts()
        }
        
        apiManager.request(.postService(.getPosts(page: page,
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
                    self.posts.append(contentsOf: data)
                    self.isLastPage = data.count < 10
                    self.isFetching = false
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
            self.dataPublisher.send(data)
        }
        .store(in: &cancellables)
    }

    func votePost(postId: Int, 
                  choice: Bool,
                  index: Int) {
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
            self.updatePost(index: index,
                            myChoice: choice,
                            voteCount: data)
            self.fetchPostDetail(postId: postId)
        }
        .store(in: &cancellables)
    }

    func updatePost(index: Int, myChoice: Bool, voteCount: VoteCountsModel) {
        posts[index].myChoice = myChoice
        posts[index].voteCounts = voteCount
        posts[index].voteCount = voteCount.agreeCount + voteCount.disagreeCount
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

    func closePost(postId: Int, index: Int) {
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
        self.fetchPostDetail(postId: postId)
    }
}
