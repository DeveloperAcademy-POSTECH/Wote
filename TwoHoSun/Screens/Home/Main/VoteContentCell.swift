//
//  VoteContentCell.swift
//  TwoHoSun
//
//  Created by 김민 on 11/9/23.
//

import SwiftUI

import Kingfisher

struct VoteContentCell: View {
    @State var postData: PostModel
    @Environment(AppLoginState.self) private var loginState

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                ProfileImageView(imageURL: postData.author.profileImage)
                    .frame(width: 32, height: 32)
                Text(postData.author.nickname)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                Spacer()
                ConsumerTypeLabel(consumerType: ConsumerType(rawValue: postData.author.consumerType) ?? .adventurer,
                               usage: .standard)
            }
            .padding(.bottom, 10)
            HStack(spacing: 4) {
                if postData.postStatus == PostStatus.closed.rawValue {
                    Text("종료")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.white)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 5)
                        .background(Color.disableGray)
                        .clipShape(RoundedRectangle(cornerRadius: 3))
                }
                Text(postData.title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
            }
            Text(postData.contents ?? "")
                .font(.system(size: 14))
                .foregroundStyle(.white)
                .padding(.bottom, 8)
            HStack(spacing: 0) {
                if let price = postData.price {
                    Text("가격: \(price)원")
                    Text(" · ")
                }
                Text(postData.createDate.convertToStringDate() ?? "")
            }
            .font(.system(size: 14))
            .foregroundStyle(Color.gray100)
            .padding(.bottom, 10)
            HStack {
                voteInfoButton(label: "\(postData.voteCount)명 투표", icon: "person.2.fill")
                Spacer()
                voteInfoButton(label: "댓글 \(postData.commentCount)개", icon: "message.fill")
            }
            .padding(.bottom, 2)
            voteImageView
            VStack(spacing: 10) {
                VoteView(postStatus: postData.postStatus,
                         myChoice: postData.myChoice,
                         voteCount: postData.voteCount,
                         voteCounts: postData.voteCounts)
                detailResultButton
            }
            .padding(.top, 2)
        }
        .padding(.horizontal, 24)
    }
}

extension VoteContentCell {
    
    private var endLabel: some View {
        Text("종료")
            .font(.system(size: 12, weight: .medium))
            .foregroundStyle(.white)
            .padding(.vertical, 4)
            .padding(.horizontal, 5)
            .background(Color.disableGray)
            .clipShape(RoundedRectangle(cornerRadius: 3))
    }

    @ViewBuilder
    private var voteImageView: some View {
        if let imageURL = postData.image {
            ImageView(imageURL: imageURL)
        } else {
            Image("imgDummyVote\(postData.id % 3 + 1)")
                .resizable()
                .frame(maxWidth: .infinity)
                .aspectRatio(1.5, contentMode: .fit)
                .clipShape(.rect(cornerRadius: 16))
        }
    }

    private func voteInfoButton(label: String, icon: String) -> some View {
        HStack(spacing: 2) {
            Image(systemName: icon)
            Text(label)
        }
        .font(.system(size: 14))
        .foregroundStyle(.white)
        .padding(.vertical, 7)
        .padding(.horizontal, 10)
        .background(Color.darkGray2)
        .clipShape(.rect(cornerRadius: 34))
    }

    private var detailResultButton: some View {
        NavigationLink {
//            DetailView(viewModel: DetailViewModel(apiManager: loginState.serviceRoot.apimanager),
//                       postId: postData.id))
            DetailView(viewModel: DetailViewModel(apiManager: loginState.serviceRoot.apimanager),
                       postId: postData.id)
        } label: {
            Text("상세보기")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(Color.blue100)
                .clipShape(Capsule())
        }
    }
}
