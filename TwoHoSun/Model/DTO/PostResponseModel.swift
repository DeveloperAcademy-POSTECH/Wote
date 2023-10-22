//
//  PostResponseModel.swift
//  TwoHoSun
//
//  Created by 김민 on 10/20/23.
//

import Foundation

struct PostResponse: Codable {
    let postId: Int
    let createDate, modifiedDate: String
    let postType: PostType
    let postStatus: PostStatus
    let author: Author
    let title, contents, image, externalURL: String
    let likeCount, viewCount, commentCount: Int
    let voteCounts: VoteCounts
    let voteInfoList: [VoteInfo]
    let postCategoryType: PostCategoryType
    let voted: Bool
    let mine: Bool
}

struct Author: Codable {
    let id: Int
    let userNickname: String?
    let userProfileImage: String?
}

struct VoteCounts: Codable {
    let agreeCount: Int
    let disagreeCount: Int
}

enum PostStatus: String, Codable {
    case active = "ACTIVE"
    case complete = "COMPLETE"
}

enum PostType: String, Codable {
    case allSchool = "ALL_SCHOOL"
    case mySchool = "MY_SCHOOL"
}

enum PostCategoryType: String, Codable {
    case purchase = "PURCHASE_CONSIDERATION"
    case action = "ACTION_CONSIDERATION"
    case food = "FOOD_CONSIDERATION"
}
