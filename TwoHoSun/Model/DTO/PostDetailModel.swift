//
//  PostResponseDto.swift
//  TwoHoSun
//
//  Created by 김민 on 10/20/23.
//

import Foundation

struct PostDetailModel: Codable, Identifiable {
    var id: Int
    var createDate: String
    var modifiedDate: String
    var visibilityScope: String
    var postStatus: String
    var author: Author
    var title: String
    var contents: String?
    var image: String?
    var externalURL: String?
    var voteCount: Int
    var commentCount: Int
    var price: Int?
    var myChoice: Bool?
    var voteCounts: VoteCounts
    var voteInfoList: [VoteInfoModel]?
    var isMine: Bool?
    var isNotified: Bool?
    var isPurchased: Bool?

    enum CodingKeys: String, CodingKey {
        case id = "postId"
        case createDate, modifiedDate, visibilityScope, postStatus,
             author, title, contents, image, externalURL, voteCount,
             commentCount, price, myChoice, voteCounts, voteInfoList,
             isMine, isNotified, isPurchased
    }
}

struct VoteInfoModel: Codable, Hashable {
    let isAgree: Bool
    let consumerType: String
}
