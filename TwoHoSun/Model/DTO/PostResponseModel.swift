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
    let postCategoryType: PostCategoryType
    let voted: Bool
    let mine: Bool
}

enum PostStatus: String, Codable {
    case active = "ACTIVE"
    case complete = "COMPLETE"
}

enum PostType: String, Codable {
    case allSchool = "ALL_SCHOOL"
    case mySchool = "MY_SCHOOL"
}
