//
//  CommentPostModel.swift
//  TwoHoSun
//
//  Created by 235 on 10/23/23.
//

import Foundation
struct CommentPostModel: Codable {
    let content: String
    let parentId: Int?
    let postId: Int
}
