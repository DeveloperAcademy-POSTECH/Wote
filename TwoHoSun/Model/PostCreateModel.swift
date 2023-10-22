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
    let postCategoryType: String
}

enum PostCategoryType: String, CaseIterable {
    case purchaseConsideration = "PURCHASE_CONSIDERATION"
    case actionConsideration = "ACTION_CONSIDERATION"
    case foodConsideration = "FOOD_CONSIDERATION"

    var title: String {
        switch self {
        case .purchaseConsideration:
            return "살까 말까?"
        case .actionConsideration:
            return "할까 말까?"
        case .foodConsideration:
            return "먹을까 말까?"
        }
    }
}
