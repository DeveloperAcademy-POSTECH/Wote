//
//  SpendTypeLabel.swift
//  TwoHoSun
//
//  Created by 235 on 11/1/23.
//

import SwiftUI

enum LabelTypeSize {
    case small, large

    var horizontalPadding: CGFloat {
        switch self {
        case .small:
            return 8
        case .large:
            return 12
        }
    }

    var verticalPadding: Double {
        switch self {
        case .small:
            return 3
        case .large:
            return 6
        }
    }

    var fontSize: CGFloat {
        switch self {
        case .small:
            return 12
        case .large:
            return 14
        }
    }
}

struct SpendTypeLabel: View {
    let spendType: SpendTItleType
    let size: LabelTypeSize

    var body: some View {
        Text(spendType.title)
            .font(.system(size: size.fontSize))
            .foregroundStyle(spendType.textColor)
            .padding(.horizontal, size.horizontalPadding)
            .padding(.vertical, size.verticalPadding)
            .background(spendType.backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 35))
    }
}
