//
//  MyPostModel.swift
//  TwoHoSun
//
//  Created by 관식 on 11/17/23.
//

import Foundation

struct MyPostModel: Codable {
    var createDate: String
    var modifiedDate: String
    var postId: Int
    var postStatus: String
    var voteResult: String
    var title: String
    var image: String
    var contents: String
    var price: Int
    var hasReview: Bool
}
