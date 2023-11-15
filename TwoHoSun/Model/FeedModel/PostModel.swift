//
//  PostModel.swift
//  TwoHoSun
//
//  Created by 김민 on 10/20/23.
//

import Foundation

struct PostModel: Identifiable {
    let id = UUID()
    let postId: Int
    let date: String
//    let postType: PostType
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
    let voteInfoList: [VoteInfo]
    let voted: Bool
    let mine: Bool

//    init(from postResponse: PostResponse) {
//        self.postId = postResponse.postId
//        self.date = postResponse.createDate
//        self.postType = postResponse.postType
//        self.postStatus = postResponse.postStatus
//        self.author = AuthorModel(userNickname: postResponse.author.userNickname ?? "",
//                                  userProfileImage: postResponse.author.userProfileImage ?? "")
//        self.title = postResponse.title
//        self.contents = postResponse.contents
//        self.image = postResponse.image
//        self.externalURL = postResponse.externalURL
//        self.likeCount = postResponse.likeCount
//        self.viewCount = postResponse.viewCount
//        self.commentCount = postResponse.commentCount
//        self.voteCount = VoteCountModel(agreeCount: postResponse.voteCounts.agreeCount,
//                                        disagreeCount: postResponse.voteCounts.disagreeCount)
//        self.voted = postResponse.voted
//        self.voteInfoList = postResponse.voteInfoList ?? []
//        self.mine = postResponse.mine
//        self.postCategoryType = postResponse.postCategoryType
//    }
}

struct AuthorModel {
    let userNickname: String
    let userProfileImage: String
}

struct VoteCountModel {
    let agreeCount: Int
    let disagreeCount: Int
}
