//
//  SearchTextFieldState.swift
//  TwoHoSun
//
//  Created by 김민 on 11/5/23.
//

import SwiftUI

enum SearchTextFieldState {
    case inactive, active, submitted

    var placeholderColor: Color {
        switch self {
        case .submitted:
            return Color.subGray1
        default:
            return Color.placeholderGray
        }
    }

    var backgroundColor: Color {
        switch self {
        case .inactive:
            return .clear
        case .active:
            return .activeBlack
        case .submitted:
            return .fixedGray
        }
    }

    var foregroundColor: Color {
        switch self {
        case .submitted:
            return Color.subGray1
        default:
            return Color.placeholderGray
        }
    }

    var strokeColor: Color {
        switch self {
        case .inactive:
            return Color.darkBlue
        case .active:
            return Color.darkBlueStroke
        case .submitted:
            return Color.clear
        }
    }
}
