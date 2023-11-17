//
//  VoteCardView.swift
//  TwoHoSun
//
//  Created by 김민 on 11/6/23.
//

import SwiftUI

enum VoteCardCellType {
    case standard
    case simple
    case myVote
}

enum VoteResultType {
    case buy, draw, notBuy
}

enum VoteProgressType {
    case progressing, end
}

struct VoteCardCell: View {
    var cellType: VoteCardCellType
    var progressType: VoteProgressType
    var voteResultType: VoteResultType?
    var post: SummaryPostModel

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            if cellType == .standard {
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
            }
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 4) {
                        if progressType == .end {
                            Text("종료")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(.white)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 5)
                                .background(Color.black200)
                                .clipShape(RoundedRectangle(cornerRadius: 3))
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
                        Text(post.createDate)
                    }
                    .font(.system(size: 14))
                    .foregroundStyle(Color.gray100)
                }
                Spacer()
                ZStack {
                    CardImageView(imageURL: post.image)
                        .opacity(progressType == .end ? 0.5 : 1.0)
                    if progressType == .end {
                        Group {
                            switch voteResultType {
                            case .buy:
                                Image("imgBuy")
                            case .draw:
                                Image("imgDraw")
                            case .notBuy:
                                Image("imgNotBuy")
                            case .none:
                                EmptyView()
                            }
                        }
                        .offset(x: -10, y: 10)
                    }
                }
            }

            // TODO: - 후기를 작성한 투표라면 숨기기
            if progressType == .end && cellType == .myVote {
                NavigationLink {
                    ReviewWriteView()
                } label: {
                    Text("후기 작성하기")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.lightBlue)
                        .frame(height: 52)
                        .frame(maxWidth: .infinity)
                        .clipShape(.rect(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(Color.lightBlue, lineWidth: 1)
                        )
                        .padding(.top, 6)
                        .padding(.bottom, -6)
                }

            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
        .background(cellType != .myVote ? Color.disableGray : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
