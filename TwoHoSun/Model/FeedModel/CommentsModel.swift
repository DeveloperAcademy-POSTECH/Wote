//
//  CommentsModel.swift
//  TwoHoSun
//
//  Created by 235 on 10/22/23.
//

import Foundation

struct CommentsModel: Codable, Identifiable {
    let id = UUID()
    let commentId: Int
    let createDate: String
    let modifiedDate: String
    let contents: String
    let author: Author
    let childComments: [CommentsModel?]

    enum CodingKeys: String, CodingKey {
        case commentId = "comment_id"
        case createDate
        case modifiedDate
        case contents
        case author
        case childComments
    }
}
