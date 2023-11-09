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

struct ReviewView: View {
    @State private var selectedReviewType = ReviewType.all

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // TODO: - 후기가 존재할 시에만 나타나도록 처리하기
                sameSpendTypeReviewView
                    .padding(.top, 24)
                    .padding(.bottom, 20)
                    .padding(.leading, 24)
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
        .background(Color.background)
        .toolbarBackground(Color.background, for: .tabBar)
        .scrollIndicators(.hidden)
    }
}

extension ReviewView {

    private var sameSpendTypeReviewView: some View {
        VStack(spacing: 18) {
            HStack(spacing: 6) {
                SpendTypeLabel(spendType: .saving, usage: .standard)
                Text("나와 같은 성향의 소비 후기")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                Spacer()
            }
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ForEach(0..<3) { _ in
                        simpleReviewCell(title: "ACG 마운틴 플라이 살까 말까?",
                                         content: "어쩌고저쩌고저쩌고??????????????????????????")
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

    // TODO: - 데이터가 없을 때는 noReviewView를 보여주도록 처리
    private var noReviewView: some View {
        VStack(spacing: 16) {
            Image("imgNoReview")
                .padding(.bottom, 32)
            Text("아직 소비후기가 없어요.\n고민을 나눈 후 소비후기를 들려주세요.")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.subGray1)
                .multilineTextAlignment(.center)
            NavigationLink {
                VoteWriteView(viewModel: VoteWriteViewModel())
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
        }
    }

    @ViewBuilder
    private var reviewTypeView: some View {
        // TODO: - data fetch
        LazyVStack(spacing: 0) {
            switch selectedReviewType {
            case .all:
                ForEach(0..<6) { _ in
                    NavigationLink {
                        ReviewDetailView()
                    } label: {
                        VStack(spacing: 6) {
                            Divider()
                                .background(Color.dividerGray)
                            ReviewCardCell(isSearchResult: false, isPurchased: Bool.random())
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
                            ReviewCardCell(isSearchResult: false, isPurchased: true)
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
                            ReviewCardCell(isSearchResult: false, isPurchased: false)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    WoteTabView()
}
