//
//  VoteContentViewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 10/21/23.
//

import Foundation

@Observable
final class ConsiderationViewModel {
    // TODO: - fetch data
    var isVoted: Bool = true
    var agreeCount: Int = 33
    var disagreeCount: Int = 62
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

//    func getPosts(_ size: Int = 10, first: Bool = false) {
//        APIManager.shared.requestAPI(type: .getPosts(page: nextIndex, size: size)) { (response: GeneralResponse<[PostResponse]>) in
//            switch response.status {
//            case 200:
//                guard let data = response.data else {return}
//                let postModels = data.map { PostModel(from: $0)}
//                self.datalist = first ? postModels : self.datalist + postModels
//                self.lastPage = data.count < 10 ? true : false
//                self.nextIndex += 1
//                self.loading = false
//            case 401:
//                APIManager.shared.refreshAllTokens()
//                self.getPosts(size)
//            default:
//                print("error서버문제 바구니에게 문의하세요")
//            }
//        }
//    }
}
