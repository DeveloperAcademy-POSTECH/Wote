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
                noReviewView
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

    // TODO: - 데이터가 없을 때는 noReviewView를 보여주도록 처리
    private var noReviewView: some View {
        HStack {
            Spacer()
            VStack(spacing: 16) {
                Spacer()
                Image("imgNoReview")
                    .padding(.bottom, 32)
                Text("아직 소비후기가 없어요.\n고민을 나눈 후 소비후기를 들려주세요.")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.subGray1)
                    .multilineTextAlignment(.center)
                NavigationLink {
                    WriteView(viewModel: WriteViewModel())
                } label: {
                    Text("고민 등록하러 가기")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.lightBlue)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(Color.lightBlue, lineWidth: 1)
                        }
                }
                Spacer()
            }
            Spacer()
        }
    }
}

#Preview {
    WoteTabView()
}
