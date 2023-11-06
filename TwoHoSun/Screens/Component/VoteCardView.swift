//
//  VoteCardView.swift
//  TwoHoSun
//
//  Created by 김민 on 11/6/23.
//

import SwiftUI

struct VoteCardView: View {
    var searchFilterType: SearchFilterType
    var isPurchased: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(spacing: 8) {
                Circle()
                    .frame(width: 32, height: 32)
                    .foregroundStyle(.gray)
                Text("얄루")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                Spacer()
                SpendTypeLabel(spendType: .saving, usage: .detailView)
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
                        Text("161,100원 · 64명 투표 · ")
                        Image(systemName: "message")
                        Text("245명")
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
                        Image(isPurchased ? "imgBuy" : "imgNotBuy")
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
    VoteCardView(searchFilterType: .end, isPurchased: false)
}
