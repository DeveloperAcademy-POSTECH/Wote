//
//  ConsumptionReviewView.swift
//  TwoHoSun
//
//  Created by 김민 on 11/6/23.
//

import SwiftUI

struct ReviewView: View {
    @Binding var visibilityScope: VisibilityScopeType
    @State private var reviewType = ReviewType.all
    @StateObject var viewModel: ReviewTabViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                if !viewModel.isFetching {
                    sameSpendTypeReviewView(datas: viewModel.reviews?.recentReviews,
                                            consumerType: viewModel.reviews?.myConsumerType)
                        .padding(.top, 24)
                        .padding(.bottom, 20)
                        .padding(.leading, 24)
                    ScrollViewReader { proxy in
                        LazyVStack(pinnedViews: .sectionHeaders) {
                            Section {
                                reviewListView(for: reviewType)
                                    .padding(.leading, 16)
                                    .padding(.trailing, 8)
                            } header: {
                                reviewFilterView
                            }
                            .id("reviewTypeSection")
                        }
                        .onChange(of: reviewType) { _, _ in
                            proxy.scrollTo("reviewTypeSection", anchor: .top)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.background)
        .toolbarBackground(Color.background, for: .tabBar)
        .scrollIndicators(.hidden)
        .refreshable {
            viewModel.fetchReviews(for: visibilityScope)
        }
        .onChange(of: visibilityScope) { _, newScope in
            viewModel.fetchReviews(for: newScope)
            reviewType = .all
        }
    }
}

extension ReviewView {

    @ViewBuilder
    private func sameSpendTypeReviewView(datas: [SummaryPostModel]?,
                                         consumerType: String?) -> some View {
        if let datas = datas, let consumerType = consumerType {
            VStack(spacing: 18) {
                HStack(spacing: 6) {
                    ConsumerTypeLabel(consumerType: ConsumerType(rawValue: consumerType) ?? .adventurer,
                                      usage: .standard)
                    Text("나와 같은 성향의 소비 후기")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                    Spacer()
                }
                ScrollView(.horizontal) {
                    HStack(spacing: 10) {
                        ForEach(datas) { data in
                            NavigationLink {
                                // TODO: Post Id 연결
                                ReviewDetailView(postId: 3030)
                            } label: {
                                simpleReviewCell(title: data.title,
                                                 content: data.contents,
                                                 isPurchased: data.isPurchased)
                            }
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
        }
    }

    private func simpleReviewCell(title: String,
                                  content: String?,
                                  isPurchased: Bool?) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 4) {
                PurchaseLabel(isPurchased: isPurchased ?? false)
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                Spacer() 
            }
            .padding(.horizontal, 20)
            Text(content ?? "")
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
                             isSelected: self.reviewType == reviewType,
                             selectedBackgroundColor: Color.white,
                             selectedForegroundColor: Color.black) {
                    self.reviewType = reviewType
                }
            }
            Spacer()
        }
        .padding(.vertical, 12)
        .padding(.leading, 24)
        .background(Color.background)
    }

    @ViewBuilder
    private func reviewListView(for filter: ReviewType) -> some View {
        let datas = switch filter {
                    case .all:
                    viewModel.reviews?.allReviews ?? []
                    case .purchased:
                    viewModel.reviews?.purchasedReviews ?? []
                    case .notPurchased:
                    viewModel.reviews?.notPurchasedReviews ?? []
                    }
        if datas.isEmpty {
            NoReviewView()
                .padding(.top, 70)
        } else {
            ForEach(Array(zip(datas.indices, datas)), id: \.0) { index, data in
                NavigationLink {
                    // TODO: - postId 연결
                    ReviewDetailView(postId: 3030)
                } label: {
                    VStack(spacing: 6) {
                        Divider()
                            .background(Color.dividerGray)
                        ReviewCardCell(cellType: .otherReview,
                                       data: data)
                    }
                    .onAppear {
                        if index == datas.count - 2 {
                            viewModel.fetchMoreReviews(for: visibilityScope,
                                                       filter: filter)
                        }
                    }
                }
            }
        }
    }
}
