//
//  VoteContentCell.swift
//  TwoHoSun
//
//  Created by 김민 on 11/9/23.
//

import SwiftUI

import Kingfisher

struct VoteContentCell: View {
    var postData: PostModel
    @State var myChoice: Bool?
    @State var voteCount: Int
//    @State var agreeCount: Int
//    @State var disagreeCount: Int
    @Environment(AppLoginState.self) private var loginState
    @StateObject var viewModel: ConsiderationViewModel

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
                voteInfoButton(label: "\(viewModel.voteCount ?? postData.voteCount)명 투표", icon: "person.2.fill")
                Spacer()
                voteInfoButton(label: "댓글 \(postData.commentCount)개", icon: "message.fill")
            }
            .padding(.bottom, 2)
            voteImageView
            VStack(spacing: 10) {
                VStack(spacing: 8) {
                    if postData.postStatus == PostStatus.closed.rawValue || postData.myChoice != nil {
                        voteResultView(choice: true, 
                                       myChoice: postData.myChoice,
                                       voteRatio: 30.0)
                        voteResultView(choice: false,
                                       myChoice: postData.myChoice,
                                       voteRatio: 70.0)
                    } else if let myChoice = self.myChoice { // 내가 투표했을 때 반영되는
                        voteResultView(choice: true,
                                       myChoice: myChoice,
                                       voteRatio: 30.0)
                        voteResultView(choice: false,
                                       myChoice: myChoice,
                                       voteRatio: 70.0)
                    } else {
                        incompletedVoteButton(true)
                        incompletedVoteButton(false)
                    }
                }
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

    private func incompletedVoteButton(_ choice: Bool) -> some View {
        Button {
            // TODO: - 결과 업데이트
            myChoice = choice
            viewModel.votePost(postId: postData.id, choice: choice)
        } label: {
            ZStack(alignment: .leading) {
                Capsule()
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color.black100)
                HStack(spacing: 4) {
                    Image(systemName: choice ? "circle" : "xmark")
                    Text(choice ? "산다" : "안 산다")
                }
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(.white)
                .padding(.leading, 20)
            }
        }
        .frame(height: 48)
    }

    private func voteResultView(choice: Bool, myChoice: Bool? ,voteRatio: Double) -> some View {
        ZStack(alignment: .leading) {
            Capsule()
                .foregroundStyle(Color.black100)
                .overlay(alignment: .leading) {
                    let voteButtonWidth = UIScreen.main.bounds.width - 48
                    Rectangle()
                        .frame(width: voteButtonWidth * voteRatio)
//                        .foregroundStyle(isAgreeVoteRatioHigher && choice ||
//                                         !isAgreeVoteRatioHigher && !choice ?
//                                         Color.lightBlue : Color.gray200)
                }
                .overlay {
                    if let myChoice = myChoice {
                        Capsule()
                            .strokeBorder(Color.lightBlue,
                                          lineWidth: choice == myChoice ? 1 : 0)
                    }
                }
                .clipShape(Capsule())
            HStack(spacing: 4) {
                Image(systemName: choice ? "circle" : "xmark")
                Text(choice ? "산다" : "안 산다")
                    .fontWeight(.bold)
                Spacer()
                Text(String(format: voteRatio.getFirstDecimalNum == 0 ? "%.0f" : "%.1f", voteRatio) + "%")
            }
            .foregroundStyle(.white)
            .font(.system(size: 16))
            .padding(.horizontal, 20)
        }
        .frame(height: 48)
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
