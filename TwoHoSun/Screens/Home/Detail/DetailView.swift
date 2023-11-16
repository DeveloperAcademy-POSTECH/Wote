//
//  DetailView.swift
//  TwoHoSun
//
//  Created by 235 on 10/19/23.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showDetailComments = false
    @State private var showconfirm = false
    @State private var backgroundColor: Color = .background
    @State private var showCustomAlert = false
    @State private var applyComplaint = false
    var viewModel: DetailViewModel
    var postId: Int
    var isMine = false

    enum VoteType {
        case agree, disagree

        var isAgree: Bool {
            switch self {
            case .agree:
                return true
            case .disagree:
                return false
            }
        }

        var title: String {
            switch self {
            case .agree:
                return "추천"
            case .disagree:
                return "비추천"
            }
        }

        var subtitle: String {
            switch self {
            case .agree:
                return "사는"
            case .disagree:
                return "사지 않는"
            }
        }
    }

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()

            if let data = viewModel.postDetailData {
                ScrollView {
                    VStack(spacing: 0) {
                        DetailHeaderView(author: data.author,
                                         postStatus: PostStatus(rawValue: data.postStatus) ?? PostStatus.closed,
                                         isMine: data.isMine,
                                         hasReview: data.hasReview)
                            .padding(.top, 18)
                        Divider()
                            .background(Color.disableGray)
                            .padding(.horizontal, 12)
                        DetailContentView(postDetailData: data)
                            .padding(.top, 27)
                        VoteView(postStatus: data.postStatus,
                                 myChoice: data.myChoice,
                                 voteCount: data.voteCount,
                                 voteCounts: data.voteCounts)
                            .padding(.horizontal, 24)
                        commentPreview
                            .padding(.horizontal, 24)
                            .padding(.vertical, 48)
                            .padding(.bottom, 34)
                        if data.voteCount != 0 {
                            if data.postStatus == "CLOSED" || data.myChoice != nil {
                                voteResultView(.agree,
                                               postDetailData: data,
                                               topConsumerTypes: viewModel.agreeTopConsumerTypes)
                                    .padding(.bottom, 34)
                                voteResultView(.disagree,
                                               postDetailData: data,
                                               topConsumerTypes: viewModel.disagreeTopConsumerTypes)
                            } else {
                                hiddenResultView(for: .agree, 
                                                 topConsumerTypesCount: viewModel.agreeTopConsumerTypes.count)
                                    .padding(.bottom, 34)
                                hiddenResultView(for: .disagree,
                                                 topConsumerTypesCount: viewModel.disagreeTopConsumerTypes.count)
                            }
                        }
                        Spacer()
                            .frame(height: 56)
                    }
                }
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.gray100))
                    .scaleEffect(1.3, anchor: .center)
            }

            if showDetailComments {
                Color.black.opacity(0.7)
            }
            if showCustomAlert {
                ZStack {
                    Color.black.opacity(0.7)
                        .ignoresSafeArea()
                    CustomAlertModalView(alertType: .ban(nickname: "선호"), isPresented: $showCustomAlert) {
                        print("신고접수됐습니다.")
                    }
                }
            }

            if applyComplaint {
                    Color.black.opacity(0.7)
                        .ignoresSafeArea()
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.lightBlue)
                            .frame(width: 283, height: 36)

                        Text("신고해주셔서 감사합니다.")
                            .foregroundStyle(.white)
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .onTapGesture {
                        applyComplaint.toggle()
                    }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("상세보기")
                    .foregroundStyle(Color.white)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    showconfirm.toggle()
                }, label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(Color.subGray1)
                })
            }
        }
        .toolbarBackground(Color.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .sheet(isPresented: $showDetailComments) {
                CommentsView(showComplaint: $showCustomAlert, applyComplaint: $applyComplaint)
                    .presentationDetents([.large,.fraction(0.9)])
                    .presentationContentInteraction(.scrolls)
        }
        .onAppear {
            viewModel.fetchPostDetail(postId: postId)
        }
    }
}

extension DetailView {

    var commentPreview: some View {
        CommentPreview()
            .onTapGesture {
                showDetailComments.toggle()
            }
    }

    private func hiddenResultView(for type: VoteType, topConsumerTypesCount: Int) -> some View {
        VStack(spacing: 16) {
            Text("투표 후 구매 \(type.title) 의견을 선택한 유형을 확인해봐요!")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.white)
            HStack {
                ForEach(0..<topConsumerTypesCount, id: \.self) { _ in
                    hiddenTypeLabel
                }
            }
            ProgressView(value: type.isAgree ? 1.0 : 0.0, total: 1.0)
                .progressViewStyle(CustomProgressStyle(foregroundColor: type.isAgree ? Color.lightBlue : Color.gray200,
                                                       height: 8))
        }
    }

    private var hiddenTypeLabel: some View {
        HStack(spacing: 4) {
            Image(systemName: "questionmark")
                .font(.system(size: 14))
                .foregroundStyle(.white)
            Text("??????????")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.priceGray)
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .background(Color.gray200)
        .clipShape(Capsule())
    }

    private func voteResultView(_ type: VoteType, postDetailData: PostModel, topConsumerTypes: [ConsumerType]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("구매 \(type.title) 의견")
                .font(.system(size: 14))
                .foregroundStyle(Color.priceGray)
            HStack {
                ForEach(topConsumerTypes, id: \.self) { consumerType in
                    ConsumerTypeLabel(consumerType: consumerType, usage: .standard)
                }
            }
            let ratio = type.isAgree ? viewModel.agreeRatio : viewModel.disagreeRatio
            let isAgreeHigher = viewModel.isAgreeHigher && type.isAgree
            let isDisagreeHigher = !viewModel.isAgreeHigher && !type.isAgree

            Text(String(format: ratio.getFirstDecimalNum == 0 ? "%.0f" : "%.1f", ratio)
                 + "%의 친구들이 \(type.subtitle) 것을 추천했어요!")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.white)
            ProgressView(value: ratio, total: 100.0)
                .progressViewStyle(CustomProgressStyle(foregroundColor: isAgreeHigher || isDisagreeHigher ? 
                                                       Color.lightBlue : Color.gray200,
                                                       height: 8))
        }
        .padding(.horizontal, 24)
    }
}

struct DetailContentView: View {
    var postDetailData: PostModel

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 13) {
                ConsumerTypeLabel(consumerType: ConsumerType(rawValue: postDetailData.author.consumerType) ?? .adventurer, 
                               usage: .standard)
                Text(postDetailData.title)
                    .foregroundStyle(Color.white)
                    .font(.system(size: 18, weight: .bold))
                if let contents = postDetailData.contents {
                    Text(contents)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Color.whiteGray)
                }
                HStack(spacing: 0) {
                    if let price = postDetailData.price {
                        Text("가격: \(price)원")
                        Text(" · ")
                    }
                    Text(postDetailData.modifiedDate.convertToStringDate() ?? "")
                }
                .foregroundStyle(Color.priceGray)
                .font(.system(size: 14))
                .padding(.top, 3)
            }
            .padding(.bottom, 16)

            HStack {
                Label("\(postDetailData.voteCount)명 투표", systemImage: "person.2.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.white)
                    .frame(width: 94, height: 29)
                    .background(Color.darkGray2)
                    .clipShape(RoundedRectangle(cornerRadius: 34))
                Spacer()
                Button {
                    print("이야 공유하자")
                } label: {
                    Label("공유", systemImage: "square.and.arrow.up")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.white)
                        .frame(width: 63, height: 29)
                        .background(Color.lightBlue)
                        .clipShape(RoundedRectangle(cornerRadius: 34))
                }
            }
            .padding(.bottom, 4)

            if let externalURL = postDetailData.externalURL {
                Link(destination: URL(string: externalURL)!, label: {
                    Text(externalURL)
                        .tint(Color.white)
                        .font(.system(size: 16))
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.leading)
                        .truncationMode(.tail)
                        .lineLimit(1)
                        .padding(.vertical,10)
                        .padding(.horizontal,14)
                        .background(Color.lightGray)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                })
            }

            Group {
                if let imageURL = postDetailData.image {
                    ImageView(imageURL: imageURL)
                } else {
                    Image("imgDummyVote\((postDetailData.id) % 3 + 1)")
                        .resizable()
                        .frame(maxWidth: .infinity)
                        .aspectRatio(1.5, contentMode: .fit)
                        .clipShape(.rect(cornerRadius: 16))
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 8)
    }
}
