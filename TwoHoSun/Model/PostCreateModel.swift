//
//  PostCreateModel.swift
//  TwoHoSun
//
//  Created by 김민 on 10/22/23.
//

import Foundation

struct PostCreateModel: Codable {
    let postType: String
    let title: String
    let contents: String
    let image: String
    let externalURL: String
    let postTagList: [String]
}
