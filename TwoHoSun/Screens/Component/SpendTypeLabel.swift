//
//  SpendTypeLabel.swift
//  TwoHoSun
//
//  Created by 235 on 11/1/23.
//

import SwiftUI
struct SpendTypeLabel: View {
    let spendType: SpendTItleType
    var body: some View {
        Text(spendType.title)
            .font(.system(size: 14))
            .foregroundStyle(spendType.textColor)
            .padding(.horizontal, 12)
            .padding(.vertical, 5.5)
            .background(spendType.backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 35))
    }
}
