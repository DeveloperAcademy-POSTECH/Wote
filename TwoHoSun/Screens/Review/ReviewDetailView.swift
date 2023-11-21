//
//  ReviewDetailView.swift
//  TwoHoSun
//
//  Created by 김민 on 11/7/23.
//

import SwiftUI

struct ReviewDetailView: View {
    @Environment(AppLoginState.self) private var loginState
    @State private var isDetailCommentShown = false
    @State private var showCustomAlert = false
    @State private var applyComplaint = false
    @State var viewModel: ReviewDetailViewModel
    var isShowingHeader = true
    var postId: Int?
    var reviewId: Int?

    var body: some View {
        ScrollView {
            if let data = viewModel.reviewData {
                VStack(spacing: 0) {
                    if isShowingHeader {
                        detailHeaderView(data.originalPost)
                            .padding(.top, 24)
                            .padding(.horizontal, 24)
                        Divider()
                            .background(Color.disableGray)
                            .padding(.horizontal, 12)
                            .padding(.top, 12)
                    }
                    detailReviewCell(data.reviewPost)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 30)
                }
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.gray100))
                    .scaleEffect(1.3, anchor: .center)
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.background)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("상세보기")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(.white)
            }

            ToolbarItem(placement: .topBarTrailing) {
                menuButton
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .sheet(isPresented: $isDetailCommentShown) {
            CommentsView(showComplaint: $showCustomAlert,
                         applyComplaint: $applyComplaint,
                         viewModel: CommentsViewModel(apiManager: loginState.serviceRoot.apimanager,
                                                      postId: postId ?? 0))
            .presentationDetents([.large,.fraction(0.9)])
                .presentationContentInteraction(.scrolls)
        }
        .onAppear {
            if let reviewId = reviewId {
                viewModel.fetchReviewDetail(reviewId: reviewId)
            }

            if let postId = postId {
                viewModel.fetchReviewDetail(postId: postId)
            }
        }
    }
}

extension ReviewDetailView {

    private var menuButton: some View {
        Button {
            print("open menu")
        } label: {
            Image(systemName: "ellipsis")
                .foregroundStyle(Color.subGray1)
        }
    }

    private func detailHeaderView(_ data: SummaryPostModel) -> some View {
        VStack(spacing: 11) {
            HStack(spacing: 3) {
                ProfileImageView(imageURL: data.author?.profileImage)
                    .frame(width: 32, height: 32)
                    .padding(.trailing, 7)
                Text(data.author?.nickname ?? "")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Color.woteWhite)
                Text("님의 소비 고민")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.woteWhite)
                Spacer()
                NavigationLink {
//                    DetailView(viewModel: DetailViewModel(voteDataManager: loginState.serviceRoot.voteManager),
//                               isShowingHeader: false,
//                               postId: 0,
//                               index: 0)
//                    DetailView(viewModel: DetailViewModel(appLoginState: loginState),
//                               postId: <#T##Int#>,
//                               index: <#T##Int#>)
                } label: {
                    HStack(spacing: 2) {
                        Text("바로가기")
                        Image(systemName: "chevron.right")
                    }
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color.accentBlue)
                }
            }
            NavigationLink {
//                DetailView(viewModel: DetailViewModel(voteDataManager: loginState.serviceRoot.voteManager),
//                           isShowingHeader: false,
//                           postId: 0,
//                           index: 0)
            } label: {
                VoteCardCell(cellType: .simple,
                             progressType: .end,
                             data: data)
            }
        }
    }

    private func detailReviewCell(_ data: PostModel) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            ConsumerTypeLabel(consumerType: ConsumerType(rawValue: data.author.consumerType) ?? .adventurer,
                              usage: .cell)
                .padding(.bottom, 12)
            HStack(spacing: 4) {
                if let isPurchased = data.isPurchased {
                    PurchaseLabel(isPurchased: isPurchased)
                }
                Text(data.title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Color.white)
            }
            .padding(.bottom, 5)
            Text(data.contents ?? "")
                .lineLimit(3)
                .multilineTextAlignment(.leading)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.whiteGray)
                .padding(.bottom, 8)
            HStack(spacing: 0) {
                if let price = data.price {
                    Text("가격: \(price)원")
                    Text(" · ")
                }
                Text(data.createDate.convertToStringDate() ?? "")
            }
            .font(.system(size: 14))
            .foregroundStyle(Color.gray100)
            .padding(.bottom, 20)
            shareButton
                .padding(.bottom, 4)
            if let image = data.image {
                ImageView(imageURL: image)
                    .padding(.bottom, 28)
            }
            CommentPreview()
                .onTapGesture {
                    isDetailCommentShown.toggle()
                }
        }
    }

    private var shareButton: some View {
        HStack {
            Spacer()
            Button {
                print("이야 공유하자")
            } label: {
                Label("공유", systemImage: "square.and.arrow.up")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.lightBlue)
                    .clipShape(RoundedRectangle(cornerRadius: 34))
            }
        }
    }
}

#Preview {
    NavigationStack {
        @Environment(AppLoginState.self) var loginState

        ReviewDetailView(viewModel: ReviewDetailViewModel(apiManager: loginState.serviceRoot.apimanager), 
                         reviewId: 3030)
            .environment(AppLoginState())
    }
}
