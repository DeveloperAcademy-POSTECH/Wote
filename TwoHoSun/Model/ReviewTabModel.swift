//
//  ReviewTabModel.swift
//  TwoHoSun
//
//  Created by 김민 on 11/19/23.
//

import Foundation

struct ReviewTabModel: Codable {
    let myConsumerType: String?
    var recentReviews: [SummaryPostModel]?
    var allReviews: [SummaryPostModel]
    var purchasedReviews: [SummaryPostModel]
    var notPurchasedReviews: [SummaryPostModel]
}

enum ReviewType: String, CaseIterable {
    case all = "ALL"
    case purchased = "PURCHASED"
    case notPurchased = "NOT_PURCHASED"

    var title: String {
        switch self {
        case .all:
            return "모두"
        case .purchased:
            return "샀다"
        case .notPurchased:
            return "안샀다"
        }
    }
}
