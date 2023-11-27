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
    var data: SummaryPostModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if cellType != .myReview {
                reviewHeaderView
                    .padding(.top, 24)
            }
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 4) {
                        if let isPurchased = data.isPurchased {
                            PurchaseLabel(isPurchased: isPurchased)
                        }
                        Text(data.title)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.white)
                            .lineLimit(1)
                    }
                    Text(data.contents ?? "")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .padding(.bottom, 9)
                    HStack(spacing: 0) {
                        if let isPurchased = data.isPurchased,
                           let price = data.price,
                           isPurchased {
                            Text("가격: \(price)원")
                            Text(" · ")
                        }
                        Text(data.createDate.convertToStringDate() ?? "")
                    }
                    .font(.system(size: 14))
                    .foregroundStyle(Color.gray100)
                }
                Spacer()
                if let isPurchased = data.isPurchased, isPurchased {
                    if let image = data.image {
                        ImageView(imageURL: image,
                                  ratio: 1.0,
                                  cornerRadius: 8)
                            .frame(width: 66, height: 66)
                    }
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

extension ReviewCardCell {

    @ViewBuilder
    private var reviewHeaderView: some View {
        if let author = data.author {
            HStack {
                ProfileImageView(imageURL: author.profileImage)
                    .frame(width: 32, height: 32)
                Text(author.nickname)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                Spacer()
                ConsumerTypeLabel(consumerType: ConsumerType(rawValue: author.consumerType) ?? .adventurer,
                                  usage: .cell)
            }
        }
    }
}
