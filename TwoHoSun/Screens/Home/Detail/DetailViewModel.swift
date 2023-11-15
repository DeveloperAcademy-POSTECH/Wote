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
//    var detailPostData: PostModel?
    var postId: Int
    var isSendMessage: Bool = false
    private var appState: AppLoginState

    init(postId: Int, appState: AppLoginState) {
        self.postId = postId
        self.appState = appState
    }

    func getNicknameForComment(commentId: Int) -> String? {
        if let comment = commentsDatas.first(where: { $0.commentId == commentId }) {
            return comment.author.nickname
        }
        return nil
    }
    

}
