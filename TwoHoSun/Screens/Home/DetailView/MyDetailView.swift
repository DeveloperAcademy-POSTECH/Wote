//
//  MyDetailView.swift
//  TwoHoSun
//
//  Created by 관식 on 10/22/23.
//

import SwiftUI

struct MyDetailView: View {
    
    @State private var writerName: String = "깜찍이머리핀용주"
    @State private var model = PostModel(date: "",
                                             postType: .allSchool,
                                             postStatus: .active,
                                             author: AuthorModel(userNickname: "김아무개",
                                                                 userProfileImage: ""),
                                             title: "GS25 통살치킨 살까요 말까요",
                                             contents: "너무너무 배고파혀 빨리정래줘 꾸예우에웨에ㅐㅜ엑으우어우양아ㅔㅇㅇ엥",
                                             image: "https://picsum.photos/200/300",
                                             externalURL: "https://www.youtube.com/watch?v=A_S2RECiiTg",
                                             likeCount: 3,
                                             viewCount: 77,
                                             commentCount: 20,
                                             voteCount: VoteCountModel(agreeCount: 73, disagreeCount: 74))
    
    var body: some View {
        ScrollView {
            VStack {
                detailHeaderView
                VoteContentView(title: model.title, contents: model.contents, imageURL: model.image, externalURL: model.externalURL, likeCount: model.likeCount, viewCount: model.viewCount, commentCount: model.commentCount, agreeCount: model.voteCount.agreeCount, disagreeCount: model.voteCount.disagreeCount)
            }
        }
    }
}

extension MyDetailView {
    private var detailHeaderView: some View {
        HStack {
            Image(systemName: "person.fill")
                .frame(width: 30, height: 30)
                .clipShape(Circle())
            Text(writerName)
                .font(.system(size: 16, weight: .medium))
            Spacer()
        }
        .padding(.horizontal, 26)
    }
}

#Preview {
    MyDetailView()
}
