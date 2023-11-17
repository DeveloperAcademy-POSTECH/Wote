//
//  CommentsModel.swift
//  TwoHoSun
//
//  Created by 235 on 10/22/23.
//

import Foundation

struct CommentsModel: Codable, Identifiable {
    var id = UUID()
    let commentId: Int
    let createDate: String
    let modifiedDate: String
    let contents: String
    let author: Author
    let subComments: [CommentsModel]?
}
