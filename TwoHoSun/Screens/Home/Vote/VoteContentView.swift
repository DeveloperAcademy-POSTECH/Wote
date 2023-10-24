//
//  VoteContentView.swift
//  TwoHoSun
//
//  Created by 김민 on 10/19/23.
//

import SwiftUI

import Kingfisher

struct VoteContentView: View {
    @State private var isImageDetailPresented = false
    @State private var isLinkWebViewPresented = false
    @State private var goNext = false
    let postData: PostModel
    var isMainCell: Bool
    private let viewModel: VoteContentViewModel
    
    init(postData: PostModel, isMainCell: Bool = true) {
        self.postData = postData
        self.isMainCell = isMainCell
        self.viewModel = VoteContentViewModel(postData: postData)
    }

    var body: some View {
        NavigationLink("", 
                       destination: OthersDetailView(viewModel: DetailViewModel(postId: postData.postId),
                                               postId: postData.postId),
                       isActive: $goNext)
        ZStack {
            Color.clear
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .onTapGesture {
                    if postData.voted && isMainCell {
                        goNext = true
                    }
                }
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                decorationBoxView
                    .padding(.top, 22)
                titleView
                    .padding(.top, 12)
                voteInfoView
                    .padding(.top, 10)
                contentTextView
                    .padding(.top, 20)
                voteImageView
                    .padding(.top, 12)
                voteView
                    .padding(.top, 10)
            }
            .padding(.horizontal, 26)
            ChartView()
                .padding(.top, 20)
            buttonsBar
            informationLabels
            dividerBlock
        }
        }
        .fullScreenCover(isPresented: $isImageDetailPresented) {
            NavigationView {
                ImageDetailView(imageURL: postData.image, externalURL: postData.externalURL)
            }
        }
        .fullScreenCover(isPresented: $isLinkWebViewPresented) {
            NavigationView {
                LinkView(externalURL: postData.externalURL)
            }
        }

    }
}

extension VoteContentView {

    private var decorationBoxView: some View {
        Rectangle()
            .frame(width: 18, height: 3)
            .foregroundStyle(.gray)
    }

    private var titleView: some View {
        HStack {
            Text(postData.title)
                .font(.system(size: 20, weight: .bold))
            Spacer()
            if isMainCell {
                NavigationLink {
                    OthersDetailView(viewModel: DetailViewModel(postId: postData.postId), postId: postData.postId)
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16))
                        .foregroundStyle(.gray)
                }
            }
        }
    }

    private var voteInfoView: some View {
        HStack(spacing: 0) {
            Image(systemName: "timer")
                .padding(.trailing, 3)
            Text("6시간 후")
                .padding(.trailing, 12)
            Image(systemName: "person.fill")
                .padding(.trailing, 3)
            Text("\(postData.voteCount.agreeCount + postData.voteCount.disagreeCount)")
        }
        .font(.system(size: 12))
        .foregroundStyle(.gray)
    }

    private var contentTextView: some View {
        Text(postData.contents)
            .font(.system(size: 16))
    }

    private var tagView: some View {
        HStack {
            ForEach(1..<3) { index in
                tag("\(index)")
            }
        }
    }

    @ViewBuilder
    private var voteImageView: some View {
        if !postData.image.isEmpty {
            ZStack(alignment: .bottomTrailing) {
                KFImage(URL(string: postData.image)!)
                    .placeholder {
                        ProgressView()
                    }
                    .onFailure { error in
                        print(error.localizedDescription)
                    }
                    .cancelOnDisappear(true)
                    .resizable()
                    .frame(width: 200, height: 200)
                linkButton
                    .padding(.trailing, 12)
                    .padding(.bottom, 16)
            }
            .onTapGesture {
                isImageDetailPresented = true
            }
        }
    }

    private var linkButton: some View {
        Button {
            isLinkWebViewPresented = true
        } label: {
            HStack(spacing: 2) {
                Image(systemName: "link")
                Text("링크")
            }
            .font(.system(size: 14))
            .foregroundStyle(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background(Color.gray)
            .clipShape(RoundedRectangle(cornerRadius: 15))
        }
    }

    @ViewBuilder
    private var voteView: some View {
        if viewModel.isVoted {
            completedVoteView
        } else {
            defaultVoteView
        }
    }

    private var completedVoteView: some View {
        ZStack {
            HStack(spacing: 0) {
                voteResultView(voteType: .agree,
                               postCategoryType: postData.postCategoryType,
                               viewModel.buyCountRatio)
                voteResultView(voteType: .disagree,
                               postCategoryType: postData.postCategoryType,
                               viewModel.notBuyCountRatio)
            }
            .frame(width: 338, height: 60)
            vsLabel
                .offset(x: 169 - (338 * (100 - viewModel.buyCountRatio) / 100))
                .opacity(viewModel.buyCountRatio > 95 || viewModel.notBuyCountRatio > 95 ? 0.0 : 1.0)
        }
    }

    private func voteResultView(voteType: VoteType, postCategoryType: PostCategoryType, _ voteRatio: Double) -> some View {
        ZStack {
            Rectangle()
                .foregroundStyle(voteType.color)
                .frame(width: 338 * voteRatio / 100)
            if voteRatio >= 20 {
                VStack(spacing: 0) {
                    Text(voteType == .agree ? postCategoryType.agree : postCategoryType.disagree)
                        .font(.system(size: 16))
                    Text("(" + String(format: getFirstDecimalNum(voteRatio) == 0 ? "%.0f" : "%.1f", voteRatio) + "%)")
                        .font(.system(size: 12))
                }
            }
        }
    }

    private var defaultVoteView: some View {
        ZStack {
            HStack(spacing: 0) {
                Button {
                    print("buy button tap")
                    viewModel.postVoteCreate(VoteType.agree.rawValue)
                } label: {
                    Text(postData.postCategoryType.agree)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.black)
                        .frame(width: 169, height: 60)
                        .background(Color.orange)
                }
                Button {
                    print("not buy button tap")
                    viewModel.postVoteCreate(VoteType.disagree.rawValue)
                } label: {
                    Text(postData.postCategoryType.disagree)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.black)
                        .frame(width: 169, height: 60)
                        .background(Color.pink)
                }
            }
            vsLabel
        }
    }

    private var vsLabel: some View {
        Text("vs")
            .frame(width: 33, height: 17)
            .background(Color.gray)
            .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private var likeButton: some View {
        Button {
            print("like button did tap")
        } label: {
            Image(systemName: "heart")
                .font(.system(size: 24))
                .foregroundStyle(.gray)
        }
    }

    private var commentButton: some View {
        Button {
            print("like button did tap")
        } label: {
            Image(systemName: "message")
                .font(.system(size: 24))
                .foregroundStyle(.gray)
        }
    }

    private var shareButton: some View {
        Button {
            print("share button did tap")
        } label: {
            Image(systemName: "square.and.arrow.up")
                .font(.system(size: 24))
                .foregroundStyle(.gray)
        }
    }

    @ViewBuilder
    private var likeCountingLabel: some View {
        if postData.likeCount != 0 {
            HStack {
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.gray)
                Text("김아무개님 외 \(postData.likeCount)명이 좋아합니다")
                    .font(.system(size: 14, weight: .medium))
            }
        }
    }

    @ViewBuilder
    private var commentCountButton: some View {
        if postData.commentCount != 0 && isMainCell {
            Button {
                print("comment button did tap")
            } label: {
                Text("댓글 \(postData.commentCount)개 모두 보기")
                    .font(.system(size: 14))
                    .foregroundStyle(.gray)
            }
        }
    }

    private var uploadTimeLabel: some View {
        Text("2분전")
            .font(.system(size: 14))
            .foregroundStyle(.gray)
    }

    private func getFirstDecimalNum(_ voteRatio: Double) -> Int {
        return Int((voteRatio * 10).truncatingRemainder(dividingBy: 10))
    }
    
    private var buttonsBar: some View {
        HStack(spacing: 0) {
            likeButton
                .padding(.trailing, 10)
            commentButton
            Spacer()
            shareButton
        }
        .padding(.leading, 20)
        .padding(.trailing, 26)
        .padding(.top, 12)
    }
    
    private var informationLabels: some View {
        VStack(alignment: .leading, spacing: 0) {
            likeCountingLabel
                .padding(.top, 10)
            commentCountButton
                .padding(.top, 8)
            uploadTimeLabel
                .padding(.top, 8)
                .padding(.bottom, 20)
        }
        .padding(.leading, 26)
    }
    
    private var dividerBlock: some View {
        Rectangle()
            .frame(height: 10)
            .foregroundStyle(Color(.secondarySystemBackground))
    }
}
