//
//  CommentsModel.swift
//  TwoHoSun
//
//  Created by 235 on 10/22/23.
//

import Foundation

struct CommentsModel: Codable {
    let commentId: Int
    let createDate: String
    let modifiedDate: String
    let content: String
    let subComments: [CommentsModel]?
    let isMine: Bool
    let author: AuthorModel?
}
