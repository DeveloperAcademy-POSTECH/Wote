//
//  VoteContentCell.swift
//  TwoHoSun
//
//  Created by 김민 on 11/9/23.
//

import SwiftUI

import Kingfisher

struct VoteContentCell: View {
    @Environment(AppLoginState.self) private var loginState
    @State private var isButtonTapped = false
    @State private var isAlertShown = false
    @AppStorage("haveConsumerType") var haveConsumerType: Bool = false
    var viewModel: ConsiderationViewModel
    var data: PostModel
    var index: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                ProfileImageView(imageURL: data.author.profileImage)
                    .frame(width: 32, height: 32)
                Text(data.author.nickname)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                Spacer()
                ConsumerTypeLabel(consumerType: ConsumerType(rawValue: data.author.consumerType) ?? .adventurer,
                                  usage: .standard)
            }
            .padding(.bottom, 10)
            HStack(spacing: 4) {
                if data.postStatus == PostStatus.closed.rawValue {
                    EndLabel()
                }
                Text(data.title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
            }
            Text(data.contents ?? "")
                .font(.system(size: 14))
                .foregroundStyle(.white)
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
            .padding(.bottom, 10)
            HStack {
                InfoButton(label: "\(data.voteCount ?? 0)명 투표", icon: "person.2.fill")
                Spacer()
                voteInfoButton(label: "댓글 \(data.commentCount ?? 0)개", icon: "message.fill")
            }
            .padding(.bottom, 2)
            if let imageURL = data.image {
                ImageView(imageURL: imageURL)
            } else {
                Image("imgDummyVote\(data.id % 3 + 1)")
                    .resizable()
                    .frame(maxWidth: .infinity)
                    .aspectRatio(1.5, contentMode: .fit)
                    .clipShape(.rect(cornerRadius: 16))
            }
            VStack(spacing: 10) {
                VStack {
                    if data.postStatus == "CLOSED" || data.myChoice != nil {
                        let (agreeRatio, disagreeRatio) = viewModel.calculatVoteRatio(voteCounts: data.voteCounts)
                        VoteResultView(myChoice: data.myChoice,
                                       agreeRatio: agreeRatio,
                                       disagreeRatio: disagreeRatio)

                    } else {
                        IncompletedVoteButton(choice: .agree) {
                            votePost(choice: true)
                        }
                        IncompletedVoteButton(choice: .disagree) {
                            votePost(choice: false)
                        }
                    }
                }
                detailResultButton
            }
            .padding(.top, 2)
        }
        .padding(.horizontal, 24)
        .alert(isPresented: $isAlertShown) {
            Alert(title: Text("투표는 1번만 가능합니다."))
        }
    }
}

extension VoteContentCell {

    private func voteInfoButton(label: String, icon: String) -> some View {
        Button {
            loginState.serviceRoot.navigationManager.navigate(.detailView(postId: data.id, dirrectComments: true))
        } label: {
            HStack(spacing: 2) {
                Image(systemName: icon)
                Text(label)
            }
            .font(.system(size: 14))
            .foregroundStyle(.white)
            .padding(.vertical, 7)
            .padding(.horizontal, 10)
            .background(Color.darkGray2, in: .rect(cornerRadius: 34))
        }
    }

    private var detailResultButton: some View {
        Button {
            loginState.serviceRoot.navigationManager.navigate(.detailView(postId: data.id))
        } label: {
                Text("상세보기")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Color.blue100, in: Capsule())
        }
    }

    private func votePost(choice: Bool) {
        guard haveConsumerType else {
            loginState.serviceRoot.navigationManager.navigate(.testIntroView)
            return
        }

        if isButtonTapped {
            isAlertShown = true
        } else {
            isButtonTapped = true
            viewModel.votePost(postId: data.id,
                               choice: choice,
                               index: index)

        }
    }
}
