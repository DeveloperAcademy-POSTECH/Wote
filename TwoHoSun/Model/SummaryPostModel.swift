//
//  MyPostModel.swift
//  TwoHoSun
//
//  Created by 관식 on 11/17/23.
//

import Foundation

struct MyPostModel: Codable {
    var total: Int
    var posts: [SummaryPostModel]
}

struct SummaryPostModel: Codable, Identifiable,
                            Hashable {
    var id: Int
    var createDate: String
    var modifiedDate: String
    var author: AuthorModel?
    var postStatus: String
    var viewCount: Int?
    var voteCount: Int?
    var commentCount: Int?
    var voteResult: String?
    var title: String
    var image: String?
    var contents: String?
    var price: Int?
    var isPurchased: Bool?
    var hasReview: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id = "postId"
        case createDate, modifiedDate, author, postStatus, viewCount, 
             voteCount, commentCount, voteResult, title, image, contents,
             price, isPurchased, hasReview
    }
}

extension SummaryPostModel: Equatable {
    static func == (lhs: SummaryPostModel, rhs: SummaryPostModel) -> Bool {
        return lhs.id == rhs.id &&
               lhs.createDate == rhs.createDate &&
               lhs.modifiedDate == rhs.modifiedDate &&
               lhs.author == rhs.author &&
               lhs.postStatus == rhs.postStatus &&
               lhs.viewCount == rhs.viewCount &&
               lhs.voteCount == rhs.voteCount &&
               lhs.commentCount == rhs.commentCount &&
               lhs.voteResult == rhs.voteResult &&
               lhs.title == rhs.title &&
               lhs.image == rhs.image &&
               lhs.contents == rhs.contents &&
               lhs.price == rhs.price &&
               lhs.isPurchased == rhs.isPurchased &&
               lhs.hasReview == rhs.hasReview
    }
}
