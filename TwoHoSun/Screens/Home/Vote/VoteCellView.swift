//
//  VoteCellView.swift
//  TwoHoSun
//
//  Created by 김민 on 10/20/23.
//

import SwiftUI

struct VoteCellView: View {
    var postData: PostModel

//    init() {
//        postModel = PostModel(date: postModel.date,
//                              postType: .allSchool,
//                              postStatus: .active,
//                              author: AuthorModel(userNickname: "김아무개",
//                                                  userProfileImage: ""),
//                              title: "GS25 통살치킨 살까요 말까요",
//                              contents: "너무너무 배고파혀 빨리정래줘 꾸예우에웨에ㅐㅜ엑으우어우양아ㅔㅇㅇ엥",
//                              image: "https://picsum.photos/200/300",
//                              externalURL: "https://www.youtube.com/watch?v=A_S2RECiiTg",
//                              likeCount: 3,
//                              viewCount: 77,
//                              commentCount: 20,
//                              voteCount: VoteCountModel(agreeCount: 73, disagreeCount: 74))
//    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            voteHeaderView
            VoteContentView(title: postData.title,
                            contents: postData.contents,
                            imageURL: postData.image,
                            externalURL: postData.externalURL,
                            likeCount: postData.likeCount,
                            viewCount: postData.viewCount,
                            commentCount: postData.commentCount,
                            agreeCount: postData.voteCount.agreeCount,
                            disagreeCount: postData.voteCount.disagreeCount)
        }
    }
}

extension VoteCellView {

    private var voteHeaderView: some View {
        VStack(spacing: 0) {
            HStack {
                userInfoView
                Spacer()
                moreButton
            }
            .padding(.horizontal, 26)
            .padding(.top, 16)
            .padding(.bottom, 14)
            divider
                .padding(.horizontal, 11)
        }
    }

    private var userInfoView: some View {
        HStack(spacing: 12) {
            Circle()
                .frame(width: 30, height: 30)
                .foregroundStyle(Color.gray)
            Text(postData.author.userNickname)
                .font(.system(size: 16, weight: .medium))
        }
    }

    private var moreButton: some View {
        Button {
            print("more button did tap")
        } label: {
            Image(systemName: "ellipsis")
                .font(.system(size: 16))
                .foregroundStyle(.gray)
        }
    }

    private var divider: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundStyle(.gray)
    }
}
//#Preview {
//    VoteCellView()
//}
