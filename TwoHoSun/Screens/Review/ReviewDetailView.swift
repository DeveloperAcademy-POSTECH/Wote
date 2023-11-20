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
    var postId: Int

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                detailHeaderView
                    .padding(.top, 24)
                    .padding(.horizontal, 24)
                Divider()
                    .background(Color.disableGray)
                    .padding(.horizontal, 12)
                    .padding(.top, 12)
                detailReviewCell
                    .padding(.horizontal, 24)
                    .padding(.vertical, 30)
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
            CommentsView(showComplaint: $showCustomAlert, applyComplaint: $applyComplaint)
            .presentationDetents([.large,.fraction(0.9)])
                .presentationContentInteraction(.scrolls)
        }
        .onAppear {
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

    private var detailHeaderView: some View {
        VStack(spacing: 11) {
            HStack {
                Image("defaultProfile")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .padding(.trailing, 2)
                Text("얄루")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.woteWhite)
                Text("님의 소비 고민")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.woteWhite)
                Spacer()
                NavigationLink {
                    // TODO: - postId 알맞게 변경
                    DetailView(viewModel: VoteViewModel(apiManager: loginState.serviceRoot.apimanager),
                               postId: 5205)
                } label: {
                    HStack(spacing: 2) {
                        Text("바로가기")
                        Image(systemName: "chevron.right")
                    }
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.accentBlue)
                }
            }
            NavigationLink {
                // TODO: - postId 알맞게 변경
                DetailView(viewModel: VoteViewModel(apiManager: loginState.serviceRoot.apimanager),
                           postId: 5205)
            } label: {
                // TODO: - 모델 넘겨주기
                VoteCardCell(cellType: .simple,
                             progressType: .end,
                             post: SummaryPostModel(id: 313,
                                                    createDate: "2023-11-19T07:13:22.281617",
                                                    modifiedDate: "2023-11-19T07:13:22.281617",
                                                    postStatus: "CLOSED",
                                                    title: "제목"))
            }
        }
    }

    private var detailReviewCell: some View {
        VStack(alignment: .leading, spacing: 8) {
            ConsumerTypeLabel(consumerType: .budgetKeeper, usage: .cell)
                .padding(.bottom, 12)
            HStack(spacing: 4) {
                PurchaseLabel(isPurchased: Bool.random())
                Text("ACG 마운틴 플라이 결국 샀다 ㅋ")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Color.white)
            }
            .padding(.bottom, 5)
            Text("안뇽안뇽내용임내용임")
                .lineLimit(3)
                .multilineTextAlignment(.leading)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.whiteGray)
                .padding(.bottom, 8)
            HStack(spacing: 0) {
                Text("가격: 120,000원")
                Text(" · ")
                Text("2020년 3월 12일")
            }
            .font(.system(size: 14))
            .foregroundStyle(Color.gray100)
            .padding(.bottom, 24)
            ImageView(imageURL: "https://picsum.photos/200")
                .padding(.bottom, 28)
            shareButton
            .padding(.bottom, 4)
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
        ReviewDetailView(postId: 3030)
            .environment(AppLoginState())
    }
}
