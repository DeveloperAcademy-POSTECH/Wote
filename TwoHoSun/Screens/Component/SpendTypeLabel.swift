//
//  SpendTypeLabel.swift
//  TwoHoSun
//
//  Created by 235 on 11/1/23.
//

import SwiftUI

enum LabelTypeUsage {
    case comments, standard, cell

    var horizontalPadding: CGFloat {
        switch self {
        case .comments:
            return 6
        default:
            return 10
        }
    }

    var verticalPadding: Double {
        switch self {
        case .comments:
            return 2
        default:
            return 5
        }
    }

    var fontSize: CGFloat {
        switch self {
        case .comments:
            return 12
        default:
            return 14
        }
    }
}

struct SpendTypeLabel: View {
    let spendType: ConsumerType
    let usage: LabelTypeUsage

    var body: some View {
        HStack(spacing: 4) {
            spendType.icon
                .resizable()
                .frame(width: 20, height: 20)
            Text(spendType.title)
                .font(.system(size: usage.fontSize, weight: .semibold))
        }
        .foregroundStyle(spendType.textColor)
        .padding(.horizontal, usage.horizontalPadding)
        .padding(.vertical, usage.verticalPadding)
        .background(
            Group {
                switch usage {
                case .cell:
                    spendType.lightBackgroundColor
                default:
                    spendType.darkBackgroundColor
                }
            }
        )
        .clipShape(Capsule())
    }
}

#Preview {
    ZStack {
        Color.background
        VStack {
            SpendTypeLabel(spendType: .adventurer, usage: .cell)
            SpendTypeLabel(spendType: .adventurer, usage: .standard)
            SpendTypeLabel(spendType: .adventurer, usage: .comments)
        }
    }
}
