//
//  ReviewCardCell.swift
//  TwoHoSun
//
//  Created by 김민 on 11/7/23.
//

import SwiftUI

enum ReviewCardCellType {
    case search
    case myReview
    case otherReview
}

struct ReviewCardCell: View {
    var cellType: ReviewCardCellType
    var post: SummaryPostModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if cellType != .myReview {
                HStack(spacing: 8) {
                    Circle()
                        .frame(width: 32, height: 32)
                        .foregroundStyle(.gray)
                    Text("얄루")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                    Spacer()
                    ConsumerTypeLabel(consumerType: .budgetKeeper, usage: .cell)
                }
                .padding(.top, 24)
            }
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 4) {
                        if let isPurchased = post.isPurchased {
                            PurchaseLabel(isPurchased: isPurchased)
                        }
                        Text(post.title)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.white)
                            .lineLimit(1)
                    }
                    Text(post.contents ?? "")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .padding(.bottom, 9)
                    HStack(spacing: 0) {
                        if let price = post.price {
                            Text("가격: \(price)원")
                            Text(" · ")
                        }
                        Text(post.createDate.convertToStringDate() ?? "")
                    }
                    .font(.system(size: 14))
                    .foregroundStyle(Color.gray100)
                }
                Spacer()
                if let image = post.image {
                    CardImageView(imageURL: image)
                }
            }
            .padding(.top, cellType == .myReview ? 28 : 18)
            .padding(.bottom, 24)
        }
        .padding(.horizontal, 16)
        .background(cellType == .search ? Color.disableGray : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
