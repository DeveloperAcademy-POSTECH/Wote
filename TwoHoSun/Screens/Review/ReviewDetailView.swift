//
//  ReviewDetailView.swift
//  TwoHoSun
//
//  Created by 김민 on 11/7/23.
//

import SwiftUI

struct ReviewDetailView: View {
    // TODO: - Model 만들기 전이라 임의로 isPurchased를 만들어두었음
    @State private var isPurchased = true
    @State private var isDetailCommentShown = false

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
            CommentsView()
            .presentationDetents([.large,.fraction(0.9)])
                .presentationContentInteraction(.scrolls)
        }
    }
}

extension ReviewDetailView {

    private var menuButton: some View {
        Button {
            print("menu button")
        } label: {
            Image(systemName: "ellipsis")
                .foregroundStyle(Color.subGray1)
        }
    }

    private var detailHeaderView: some View {
        VStack(spacing: 11) {
            HStack(spacing: 8) {
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
                    // TODO: - screen transition
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
                // TODO: - screen transition
            } label: {
                VoteCardCell(cardType: .simple,
                             searchFilterType: .end,
                             isPurchased: Bool.random())
            }
        }
    }

    private var detailReviewCell: some View {
        VStack(alignment: .leading, spacing: 8) {
            SpendTypeLabel(spendType: .saving, size: .large)
                .padding(.bottom, 12)
            HStack(spacing: 4) {
                PurchaseLabel(isPurchased: isPurchased)
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
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(Color.disableGray, lineWidth: 1)
                .frame(maxWidth: .infinity)
                .aspectRatio(1.5, contentMode: .fill)
                .padding(.bottom, 28)
            HStack {
                Label("256명 조회", systemImage: "person.2.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.darkGray2)
                    .clipShape(RoundedRectangle(cornerRadius: 34))
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
            .padding(.bottom, 4)
            CommentPreview()
                .onTapGesture {
                    isDetailCommentShown.toggle()
                }
        }
    }
}

#Preview {
    NavigationStack {
        ReviewDetailView()
    }
}
