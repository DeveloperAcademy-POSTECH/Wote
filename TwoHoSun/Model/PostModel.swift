//
//  PostResponseDto.swift
//  TwoHoSun
//
//  Created by 김민 on 10/20/23.
//

import Foundation

struct PostModel: Codable, Identifiable {
    var id: Int
    var createDate: String
    var modifiedDate: String
    var visibilityScope: String?
    var postStatus: String
    var author: AuthorModel
    var title: String
    var contents: String?
    var image: String?
    var externalURL: String?
    var voteCount: Int?
    var commentCount: Int?
    var price: Int?
    var myChoice: Bool?
    var voteCounts: VoteCountsModel?
    var voteInfoList: [VoteInfoModel]?
    var isMine: Bool?
    var isNotified: Bool?
    var isPurchased: Bool?
    var hasReview: Bool?

    enum CodingKeys: String, CodingKey {
        case id = "postId"
        case createDate, modifiedDate, visibilityScope, 
             postStatus, author, title, contents, image,
             externalURL, voteCount, commentCount, price,
             myChoice, voteCounts, isMine, isNotified, isPurchased, hasReview, voteInfoList
    } 
}

struct AuthorModel: Codable, Hashable {
    let id: Int
    let nickname: String
    let profileImage: String?
    let consumerType: String
    let isBlocked: Bool?
    let isBaned: Bool?
}

extension AuthorModel: Equatable {
    static func == (lhs: AuthorModel, rhs: AuthorModel) -> Bool {
        return lhs.id == rhs.id &&
               lhs.nickname == rhs.nickname &&
               lhs.profileImage == rhs.profileImage &&
               lhs.consumerType == rhs.consumerType
    }
}

struct VoteInfoModel: Codable, Hashable {
    let isAgree: Bool
    let consumerType: String
}

struct VoteCountsModel: Codable {
    let agreeCount: Int
    let disagreeCount: Int
}
