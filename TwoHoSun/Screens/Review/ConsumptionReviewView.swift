//
//  ConsumptionReviewView.swift
//  TwoHoSun
//
//  Created by 김민 on 11/6/23.
//

import SwiftUI

enum ReviewType: Int, CaseIterable {
    case all, purchased, notPurchased

    var title: String {
        switch self {
        case .all:
            return "모두"
        case .purchased:
            return "샀다"
        case .notPurchased:
            return "안샀다"
        }
    }
}

struct ConsumptionReviewView: View {
    @State private var selectedReviewType = ReviewType.all

    var body: some View {
        ZStack {
            Color.background
            VStack(alignment: .leading, spacing: 0) {
                reviewFilterView
                    .padding(.top, 23)
                    .padding(.leading, 24)
                Spacer()
            }
        }
    }
}

extension ConsumptionReviewView {

    private var reviewFilterView: some View {
        HStack(spacing: 8) {
            ForEach(ReviewType.allCases, id: \.self) { reviewType in
                FilterButton(title: reviewType.title,
                             isSelected: selectedReviewType == reviewType,
                             selectedBackgroundColor: Color.white,
                             selectedForegroundColor: Color.black) {
                    selectedReviewType = reviewType
                }
            }
            Spacer()
        }
    }
}

#Preview {
    WoteTabView()
}
