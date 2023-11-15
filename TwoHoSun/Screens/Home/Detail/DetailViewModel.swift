//
//  DetailViewModel.swift
//  TwoHoSun
//
//  Created by 235 on 10/22/23.
//

import Combine
import SwiftUI
import Observation

@Observable
final class DetailViewModel {
    var postDetailData: PostModel?
    var commentsDatas: [CommentsModel] = []
    var isSendMessage: Bool = false
    private let apiManager: NewApiManager
    var cancellables: Set<AnyCancellable> = []

    init(apiManager: NewApiManager) {
        self.apiManager = apiManager
    }

    func fetchPostDetail(postId: Int) {
        apiManager.request(.postService(.getPostDetail(postId: postId)),
                           decodingType: PostModel.self)
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
                self.postDetailData = data
            }
            .store(in: &cancellables)
    }

    func filterSelectedResult(voteInfoList: [VoteInfoModel], isAgree: Bool) -> [VoteInfoModel] {
        return voteInfoList.filter { $0.isAgree == isAgree }
    }

    func calculateVoteRatio(for voteCount: Int, voteInfoListCount: Int) -> Double {
        return Double(voteCount) / Double(voteInfoListCount)
    }

    func setTopConsumerTypes(for votes: [VoteInfoModel]) -> [ConsumerType] {
        let groupedConsumerTypes = Dictionary(grouping: votes, by: { $0.consumerType })
        let topConsumerTypes = groupedConsumerTypes
                                    .sorted { $0.value.count > $1.value.count }
                                    .prefix(2)
                                    .map { ConsumerType(rawValue: $0.key) }
                                    .compactMap { $0 }

        return topConsumerTypes
    }

//    func getNicknameForComment(commentId: Int) -> String? {
//        if let comment = commentsDatas.first(where: { $0.commentId == commentId }) {
//            return comment.author.nickname
//        }
//        return nil
//    }
//
//    func fetchVoteDetailPost() {
//        APIManager.shared.requestAPI(type: .getDetailPost(postId: postId)) { (response: GeneralResponse<PostResponseDto>) in
//            switch response.status {
//            case 200:
//                print("상세 조회 성공")
//                guard response.data != nil else { return }
////                self.detailPostData = PostModel(from: data)
//            case 401:
//                APIManager.shared.refreshAllTokens()
//                self.fetchVoteDetailPost()
//            default:
//                print("error")
//            }
//        }
//    }
//
//    func getComments() {
//        APIManager.shared.requestAPI(type: .getComments(postId: postId)) { (response: GeneralResponse<[CommentsModel]>) in
//            switch response.status {
//            case 200:
//                guard let data = response.data else {return}
//                self.commentsDatas = data
//                self.isSendMessage = false
//                print("data가져옴")
//            default:
//                print("error")
//            }
//        }
//    }
//
//    func postComments(commentPost: CommentPostModel) {
//        APIManager.shared.requestAPI(type: .postComments(commentPost: commentPost)) { (response: GeneralResponse<NoData>) in
//            switch response.status {
//            case 401:
//                APIManager.shared.refreshAllTokens()
//                self.postComments(commentPost: commentPost)
//            case 200:
//                print("post 잘됨.")
//                self.getComments()
//
//            default:
//                print("error")
//            }
//        }
//    }
//
//    func deleteComments(postId: Int, commentId: Int) {
//        APIManager.shared.requestAPI(type: .deleteComments(postId: postId, commentId: commentId)) { (response: GeneralResponse<NoData>) in
//            switch response.status {
//            case 401:
//                APIManager.shared.refreshAllTokens()
//                self.deleteComments(postId: postId, commentId: commentId)
//            case 200:
//                print("delete 잘됨.")
//                self.isSendMessage = false
//            default:
//                print("error")
//            }
//        }
//    }
}

