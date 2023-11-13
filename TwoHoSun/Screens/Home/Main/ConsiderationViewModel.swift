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
    @Published var isLoading = false
    @Published var pageOffset = 0
    private let apiManager = NewApiManager()
    private var page = 0
    var cancellables: Set<AnyCancellable> = []

    func fetchMorePosts(_ visibilityScope: String) {
        page += 1
        fetchPosts(page: page,
                   visibilityScope: visibilityScope,
                   isFirstFetch: false)
    }

    func fetchPosts(page: Int = 0,
                    size: Int = 5,
                    visibilityScope: String,
                    isFirstFetch: Bool = true) {
        if isFirstFetch { isLoading = true }
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
                self.votes.append(contentsOf: data)
            }
            self.pageOffset = self.votes.count
            if isFirstFetch { self.isLoading = false }
        }
        .store(in: &cancellables)
    }

//    func postVoteCreate(_ voteType: String) {
//        APIManager.shared.requestAPI(type: .postVoteCreate(postId: postData.postId, param: voteType)) { (response: GeneralResponse<VoteCounts>) in
//            if response.status == 401 {
//                APIManager.shared.refreshAllTokens()
//                self.postVoteCreate(voteType)
//            } else {
//                guard let data = response.data else {return}
//                self.isVoted = true
//                self.agreeCount = data.agreeCount
//                self.disagreeCount = data.disagreeCount
//                print("Vote Completed!")
//            }
//        }
//    }
}
