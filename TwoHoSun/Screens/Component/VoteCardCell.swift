//
//  VoteCardView.swift
//  TwoHoSun
//
//  Created by 김민 on 11/6/23.
//

import SwiftUI

enum VoteCardType {
    case standard
    case simple
}

enum VoteResultType {
    case buy, draw, notBuy
}

struct VoteCardCell: View {
    var cardType: VoteCardType
    var searchFilterType: SearchFilterType
    var voteResultType: VoteResultType?

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            if cardType == .standard {
                HStack(spacing: 8) {
                    Circle()
                        .frame(width: 32, height: 32)
                        .foregroundStyle(.gray)
                    Text("얄루")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                    Spacer()
                    SpendTypeLabel(spendType: .saving, size: .large)
                }
            }
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 4) {
                        if searchFilterType == .end {
                            Text("종료")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(.white)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 5)
                                .background(Color.black200)
                                .clipShape(RoundedRectangle(cornerRadius: 3))
                        }
                        Text("ACG 마운틴 플라이 살까 말까?sdffdsfsdfsdf")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.white)
                            .lineLimit(1)
                    }
                    Text("어쩌고저쩌고50자미만임~~asdfasadsafsdadsf")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .padding(.bottom, 9)
                    HStack(spacing: 0) {
                        Text("가격: 120,000원")
                        Text(" · ")
                        Text("2020년 3월 12일")
                    }
                    .font(.system(size: 14))
                    .foregroundStyle(Color.gray100)
                }
                Spacer()
                ZStack {
                    // TODO: Rectangle -> image 변경 필요
                    Rectangle()
                        .frame(width: 66, height: 66)
                        .foregroundStyle(.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .opacity(searchFilterType == .end ? 0.5 : 1.0)
                    if searchFilterType == .end {
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
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
        .background(Color.disableGray)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    Group {
        VoteCardCell(cardType: .simple, 
                     searchFilterType: .progressing,
                     voteResultType: nil)
        VoteCardCell(cardType: .simple,
                     searchFilterType: .end,
                     voteResultType: .buy)
        VoteCardCell(cardType: .simple,
                     searchFilterType: .end,
                     voteResultType: .draw)
        VoteCardCell(cardType: .simple,
                     searchFilterType: .end,
                     voteResultType: .notBuy)
    }
}
