//
//  MyPostModel.swift
//  TwoHoSun
//
//  Created by 관식 on 11/17/23.
//

import Foundation

struct MyPostModel: Codable, Identifiable {
    var id: Int
    var createDate: String
    var modifiedDate: String
    var postStatus: String
    var voteResult: String
    var title: String
    var image: String
    var contents: String
    var price: Int
    var hasReview: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "postId"
        case createDate, modifiedDate, postStatus, voteResult, title, image, contents, price, hasReview
    }
}
