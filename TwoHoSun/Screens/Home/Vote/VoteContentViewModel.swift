//
//  VoteContentViewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 10/21/23.
//

import Foundation

@Observable
final class VoteContentViewModel {
    let postData: PostModel
    var isVoteCompleted = false

    init(postData: PostModel) {
        self.postData = postData
    }

    var buyCountRatio: Double {
        if postData.voteCount.agreeCount == 0 || postData.viewCount == 0 {
               return 0.0
        } else {
            let ratio = Double(postData.voteCount.agreeCount) / Double(postData.viewCount) * 100
            return Double(Int(ratio * 10)) / 10.0
        }
    }

    var notBuyCountRatio: Double {
        return 100 - buyCountRatio
    }

    func postVoteCreate(_ voteType: String) {
        APIManager.shared.requestAPI(type: .postVoteCreate(postId: postData.postId, param: voteType)) { (response: GeneralResponse<NoData>) in
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
