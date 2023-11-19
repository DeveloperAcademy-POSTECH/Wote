//
//  ConsumptionReviewView.swift
//  TwoHoSun
//
//  Created by 김민 on 11/6/23.
//

import SwiftUI

struct ReviewView: View {
    @State private var selectedReviewType = ReviewType.all
    @StateObject var viewModel: ReviewTabViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                if !viewModel.recentReviews.isEmpty {
                    sameSpendTypeReviewView(datas: viewModel.recentReviews)
                        .padding(.top, 24)
                        .padding(.bottom, 20)
                        .padding(.leading, 24)
                }
                ScrollViewReader { proxy in
                    LazyVStack(pinnedViews: .sectionHeaders) {
                        Section {
                            reviewTypeView
                                .padding(.leading, 16)
                                .padding(.trailing, 8)
                        } header: {
                            reviewFilterView
                        }
                        .id("reviewTypeSection")
                    }
                    .onChange(of: selectedReviewType) { _, _ in
                        proxy.scrollTo("reviewTypeSection", anchor: .top)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.background)
        .toolbarBackground(Color.background, for: .tabBar)
        .scrollIndicators(.hidden)
    }
}

extension ReviewView {

    private func sameSpendTypeReviewView(datas: [SummaryPostModel]) -> some View {
        VStack(spacing: 18) {
            HStack(spacing: 6) {
                ConsumerTypeLabel(consumerType: .beautyLover, usage: .standard)
                Text("나와 같은 성향의 소비 후기")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                Spacer()
            }
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ForEach(datas) { data in
                        NavigationLink {
                            // TODO: - isPurchased 수정
                            ReviewDetailView(isPurchased: Bool.random())
                        } label: {
                            simpleReviewCell(title: data.title,
                                             content: data.contents ?? "")
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
    }

    private func simpleReviewCell(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 4) {
                PurchaseLabel(isPurchased: Bool.random())
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                Spacer() 
            }
            .padding(.horizontal, 20)
            Text(content)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.white)
                .lineLimit(1)
                .padding(.horizontal, 20)
        }
        .frame(width: 268)
        .padding(.vertical, 20)
        .background(Color.disableGray)
        .clipShape(.rect(cornerRadius: 12))
    }

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
        .padding(.vertical, 12)
        .padding(.leading, 24)
        .background(Color.background)
    }

    @ViewBuilder
    private var reviewTypeView: some View {
        // TODO: - data fetch
        switch selectedReviewType {
        case .all:
            ForEach(0..<6) { _ in
                NavigationLink {
                    ReviewDetailView()
                } label: {
                    VStack(spacing: 6) {
                        Divider()
                            .background(Color.dividerGray)
                        ReviewCardCell(cellType: .otherReview, isPurchased: Bool.random())
                    }
                }
            }
        case .purchased:
            ForEach(0..<10) { _ in
                NavigationLink {
                    ReviewDetailView()
                } label: {
                    VStack(spacing: 6) {
                        Divider()
                            .background(Color.dividerGray)
                        ReviewCardCell(cellType: .otherReview, isPurchased: true)
                    }
                }
            }
        case .notPurchased:
            ForEach(0..<3) { _ in
                NavigationLink {
                    ReviewDetailView()
                } label: {
                    VStack(spacing: 6) {
                        Divider()
                            .background(Color.dividerGray)
                        ReviewCardCell(cellType: .otherReview, isPurchased: false)
                    }
                }
            }
        }
    }
}
