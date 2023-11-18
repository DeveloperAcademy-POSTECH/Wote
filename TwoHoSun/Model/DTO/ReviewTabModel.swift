//
//  ReviewTabModel.swift
//  TwoHoSun
//
//  Created by 김민 on 11/19/23.
//

import Foundation

struct ReviewTabModel: Codable {
    let recentReviews: [SummaryPostModel]
    let reviewType: String
    let reviews: [SummaryPostModel]
}

enum ReviewType: String, CaseIterable {
    case all = "ALL"
    case purchased = "PURCHASED"
    case notPurchased = "NOTPURCHASED"

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
