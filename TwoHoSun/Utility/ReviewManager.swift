//
//  ReviewManager.swift
//  TwoHoSun
//
//  Created by 김민 on 11/23/23.
//

import SwiftUI

@Observable
final class ReviewManager {
    var reviews: ReviewTabModel?
    var myReviews = [SummaryPostModel]()
    var removeCount = 0

    var recentReviews: [SummaryPostModel] {
        reviews?.recentReviews ?? []
    }

    var allReviews: [SummaryPostModel] {
        reviews?.allReviews ?? []
    }

    var purchasedReviews: [SummaryPostModel] {
        reviews?.purchasedReviews ?? []
    }

    var notPurchasedReviews: [SummaryPostModel] {
        reviews?.notPurchasedReviews ?? []
    }

    func deleteReviews(postId: Int) {
        reviews?.allReviews.removeAll { $0.id == postId }
        reviews?.recentReviews?.removeAll { $0.id == postId }
        reviews?.purchasedReviews.removeAll { $0.id == postId}
        reviews?.notPurchasedReviews.removeAll { $0.id == postId}
        myReviews.removeAll { $0.id == postId }
    }
}
