//
//  SpendTypeLabel.swift
//  TwoHoSun
//
//  Created by 235 on 11/1/23.
//

import SwiftUI
enum LabelTypeUsage {
    case comments, detailView
    var horizontalPadding: CGFloat {
        switch self {
        case .comments:
            return 8
        case .detailView:
            return 12
        }
    }
    var verticalPadding: Double {
        switch self {
        case .comments:
            return 3
        case .detailView:
            return 5.5
        }
    }
    var fontSize: CGFloat {
        switch self {
        case .comments:
            return 12
        case .detailView:
            return 14
        }
    }
}
struct SpendTypeLabel: View {
    let spendType: SpendTItleType
    let usage: LabelTypeUsage
    var body: some View {
        Text(spendType.title)
            .font(.system(size: usage.fontSize))
            .foregroundStyle(spendType.textColor)
            .padding(.horizontal, usage.horizontalPadding)
            .padding(.vertical, usage.verticalPadding)
            .background(spendType.backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 35))
    }
}
