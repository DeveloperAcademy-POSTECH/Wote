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

struct SummaryPostModel: Codable, Identifiable {
    var id: Int
    var createDate: String
    var modifiedDate: String
    var author: Author?
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
        case createDate, modifiedDate, postStatus, voteResult, title, image, contents, price, hasReview
    }
}
