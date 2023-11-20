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
            return 4
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

    var iconSize: CGFloat {
        switch self {
        case .comments:
            16
        default:
            20
        }
    }
}

struct ConsumerTypeLabel: View {
    let consumerType: ConsumerType
    let usage: LabelTypeUsage

    var body: some View {
        HStack(spacing: 4) {
            consumerType.icon
                .resizable()
                .frame(width: usage.iconSize, height: usage.iconSize)
            Text(consumerType.title)
                .font(.system(size: usage.fontSize, weight: .semibold))
        }
        .foregroundStyle(consumerType.textColor)
        .padding(.horizontal, usage.horizontalPadding)
        .padding(.vertical, usage.verticalPadding)
        .background(
            Group {
                switch usage {
                case .cell:
                    consumerType.lightBackgroundColor
                default:
                    consumerType.darkBackgroundColor
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
            ConsumerTypeLabel(consumerType: .adventurer, usage: .cell)
            ConsumerTypeLabel(consumerType: .adventurer, usage: .standard)
            ConsumerTypeLabel(consumerType: .adventurer, usage: .comments)
        }
    }
}
