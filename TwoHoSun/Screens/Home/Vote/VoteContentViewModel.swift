//
//  VoteContentViewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 10/21/23.
//

import Foundation

@Observable
final class VoteContentViewModel {
    var postId: Int // TODO: - 모델과 연결
    var isVoteCompleted = false

    init(postId: Int) {
        self.postId = postId
    }

    func postVoteCreate(_ voteType: VoteType) {
        APIManager.shared.requestAPI(type: .postVoteCreate(postId: postId, param: voteType)) { (response: GeneralResponse<NoData>) in
            if response.status == 401 {
                APIManager.shared.refreshAllTokens()
                self.postVoteCreate(voteType)
            } else {
                self.isVoteCompleted = true
                print("Vote Completed!")
            }
        }
    }
}
