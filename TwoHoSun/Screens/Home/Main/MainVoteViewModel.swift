//
//  VoteContentViewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 10/21/23.
//

import Foundation

@Observable
final class MainVoteViewModel {
    // TODO: - fetch data
//    let postData: PostModel
    var isVoted: Bool = true
    var agreeCount: Int = 33
    var disagreeCount: Int = 62

//    init(postData: PostModel) {
//        self.postData = postData
//        self.agreeCount = postData.voteCount.agreeCount
//        self.disagreeCount = postData.voteCount.disagreeCount
//        isVoted = postData.voted ? true : false
//    }

    var totalCount: Int {
        return agreeCount + disagreeCount
    }

    var buyCountRatio: Double {
        guard totalCount > 0 else { return 0.0 }
        return round(Double(agreeCount) / Double(totalCount) * 1000) / 10
    }

    var notBuyCountRatio: Double {
        return 100 - buyCountRatio
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
