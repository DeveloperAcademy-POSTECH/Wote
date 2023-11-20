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
    var hasReview: Bool?

    enum CodingKeys: String, CodingKey {
        case id = "postId"
        case createDate, modifiedDate, visibilityScope, 
             postStatus, author, title, contents, image,
             externalURL, voteCount, commentCount, price,
             myChoice, voteCounts, isMine, isNotified, isPurchased, hasReview, voteInfoList
    } 
}

struct VoteInfoModel: Codable, Hashable {
    let isAgree: Bool
    let consumerType: String
}

enum PostStatus: String, Codable, CaseIterable {
    case active = "ACTIVE"
    case closed = "CLOSED"
    case review = "REVIEW"

    var filterTitle: String {
        switch self {
        case .active:
            return "진행중인 투표"
        case .closed:
            return "종료된 투표"
        case .review:
            return "후기"
        }
    }
}

enum VisibilityScopeType: Codable {
    case all, global, school

    var title: String {
        switch self {
        case .all:
            return "전체"
        case .global:
            return "전국 투표"
        case .school:
            return "OO고등학교 투표"
        }
    }

    var type: String {
        switch self {
        case .all:
            return "ALL"
        case .global:
            return "GLOBAL"
        case .school:
            return "SCHOOL"
        }
    }
}
