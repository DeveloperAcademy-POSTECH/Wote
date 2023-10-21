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
    var isVoteCompleted: Bool
    var agreeCount = 0
    var disagreeCount = 0
    init(postData: PostModel) {
        self.postData = postData
        isVoteCompleted =  postData.voted ? true : false
    }

    var totalCount: Int {
        return agreeCount + disagreeCount
    }

    var buyCountRatio: Double {
        if totalCount == 0 {
               return 0.0
        } else {
            let ratio = Double(agreeCount) / Double(totalCount) * 100
            return Double(Int(ratio * 10)) / 10.0
        }
    }

    var notBuyCountRatio: Double {
        return 100 - buyCountRatio
    }

    func postVoteCreate(_ voteType: String) {
        APIManager.shared.requestAPI(type: .postVoteCreate(postId: postData.postId, param: voteType)) { (response: GeneralResponse<VoteCounts>) in
            if response.status == 401 {
                APIManager.shared.refreshAllTokens()
                self.postVoteCreate(voteType)
            } else {
                guard let data = response.data else {return}
                self.isVoteCompleted = true
                self.agreeCount = data.agreeCount
                self.disagreeCount = data.disagreeCount
                print("Vote Completed!")
            }
        }
    }
}
