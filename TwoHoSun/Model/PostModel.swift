//
//  PostModel.swift
//  TwoHoSun
//
//  Created by 김민 on 10/20/23.
//

import Foundation

struct PostModel {
    let date: String
    let postType: PostType
    let postStatus: PostStatus
    let author: AuthorModel
    let title: String
    let contents: String
    var image: String
    let externalURL: String
    let likeCount: Int
    let viewCount: Int
    let commentCount: Int
    let voteCount: VoteCountModel
}

struct AuthorModel {
    let userNickname: String
    let userProfileImage: String
}

struct VoteCountModel {
    let agreeCount: Int
    let disagreeCount: Int
}
