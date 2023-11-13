//
//  PostResponseDto.swift
//  TwoHoSun
//
//  Created by 김민 on 10/20/23.
//

import Foundation

struct PostResponseDto: Codable, Identifiable {
    var id: Int
    var createDate: String
    var modifiedDate: String
    var visibilityScope: String
    var postStatus: String
    var author: Author
    var title: String
    var contents: String?
    var image: String? = "empty"
    var externalURL: String?
    var voteCount: Int
    var commentCount: Int
    var price: Int
    var isVoted: Bool?
    var voteCounts: VoteCounts

    enum CodingKeys: String, CodingKey {
        case id = "postId"
        case createDate, modifiedDate, visibilityScope, postStatus,
             author, title, contents, image, externalURL, voteCount,
             commentCount, price, isVoted, voteCounts
    }
}

struct VoteInfoList: Codable {
    let isAgree: Bool
    let consumerType: String
}

enum PostStatus: String, Codable {
    case active = "ACTIVE"
    case closed = "CLOSED"
    case review = "REVIEW"
}
