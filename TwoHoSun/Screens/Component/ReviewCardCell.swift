//
//  ReviewCardCell.swift
//  TwoHoSun
//
//  Created by 김민 on 11/7/23.
//

import SwiftUI

struct ReviewCardCell: View {
    var isPurchased: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Divider()
                .background(Color.dividerGray)
                .padding(.bottom, 6)
            HStack(spacing: 8) {
                Circle()
                    .frame(width: 32, height: 32)
                    .foregroundStyle(.gray)
                Text("얄루")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                Spacer()
                SpendTypeLabel(spendType: .saving, usage: .cell)
            }
            .padding(.horizontal, 8)
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 4) {
                        PurchaseLabel(isPurchased: isPurchased)
                        Text("ACG 마운틴 플라이 살까 말까?sdffdsfsdfsdasdf")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.white)
                            .lineLimit(1)
                    }
                    Text("어쩌고저쩌고50자미만임~~asdfasadsafsdfasdf")
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
                if isPurchased {
                    // TODO: Rectangle -> image 변경 필요
                    Rectangle()
                        .frame(width: 66, height: 66)
                        .foregroundStyle(.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 24)
        }
    }
}

#Preview {
    Group {
        ReviewCardCell(isPurchased: true)
        ReviewCardCell(isPurchased: false)
    }
}
