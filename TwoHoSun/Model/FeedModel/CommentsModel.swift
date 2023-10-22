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
    let content: String
    let author: Author
    let childComments: [CommentsModel]?

 
}
