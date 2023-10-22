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
    var postId: Int
    var isSendMessage: Bool = false

    init(postId: Int) {
        self.postId = postId
    }

    func getComments() {
        APIManager.shared.requestAPI(type: .getComments(postId: postId)) { (response: GeneralResponse<[CommentsModel]>) in
            switch response.status {
            case 200:
                guard let data = response.data else {return}
                self.commentsDatas = data
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
                self.isSendMessage = false
            default:
                print("error")
            }
        }
    }

    

    
}
