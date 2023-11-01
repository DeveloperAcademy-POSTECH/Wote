//
//  DetailViewModel.swift
//  TwoHoSun
//
//  Created by 235 on 10/22/23.
//

import SwiftUI
import Observation

@Observable
class DetailViewModel {
    var commentsDatas: [CommentsModel] = []
    var detailPostData: PostModel?
    var postId: Int
    var isSendMessage: Bool = false

    init(postId: Int) {
        self.postId = postId
    }

    func getNicknameForComment(commentId: Int) -> String? {
        if let comment = commentsDatas.first(where: { $0.commentId == commentId }) {
            return comment.author.userNickname
        }
        return nil
    }
    
    func fetchVoteDetailPost() {
        APIManager.shared.requestAPI(type: .getDetailPost(postId: postId)) { (response: GeneralResponse<PostResponse>) in
            switch response.status {
            case 200:
                print("상세 조회 성공")
                guard let data = response.data else { return }
                self.detailPostData = PostModel(from: data)
            case 401:
                APIManager.shared.refreshAllTokens()
                self.fetchVoteDetailPost()
            default:
                print("error")
            }
        }
    }

    func getComments() {
        APIManager.shared.requestAPI(type: .getComments(postId: postId)) { (response: GeneralResponse<[CommentsModel]>) in
            switch response.status {
            case 200:
                guard let data = response.data else {return}
                self.commentsDatas = data
                self.isSendMessage = false
                print("data가져옴")
            default:
                print("error")
            }
        }
    }

    func postComments(commentPost: CommentPostModel) {
        APIManager.shared.requestAPI(type: .postComments(commentPost: commentPost)) { (response: GeneralResponse<NoData>) in
            switch response.status {
            case 401:
                APIManager.shared.refreshAllTokens()
                self.postComments(commentPost: commentPost)
            case 200:
                print("post 잘됨.")
                self.getComments()

            default:
                print("error")
            }
        }
    }

    func deleteComments(postId: Int, commentId: Int) {
        APIManager.shared.requestAPI(type: .deleteComments(postId: postId, commentId: commentId)) { (response: GeneralResponse<NoData>) in
            switch response.status {
            case 401:
                APIManager.shared.refreshAllTokens()
                self.deleteComments(postId: postId, commentId: commentId)
            case 200:
                print("delete 잘됨.")
                self.isSendMessage = false
            default:
                print("error")
            }
        }
    }
}
