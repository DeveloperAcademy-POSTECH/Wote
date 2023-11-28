//
//  PostDetailModel.swift
//  TwoHoSun
//
//  Created by 김민 on 11/18/23.
//

import Foundation

struct PostDetailModel: Codable {
    var post: PostModel
    let commentCount: Int?
    let commentPreview: String?
    let commentPreviewImage: String?
}
