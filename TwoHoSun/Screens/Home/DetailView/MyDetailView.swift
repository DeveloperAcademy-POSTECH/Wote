//
//  MyDetailView.swift
//  TwoHoSun
//
//  Created by 관식 on 10/22/23.
//

import SwiftUI

struct MyDetailView: View {
    
    @State private var writerName: String = "깜찍이머리핀용주"
    @State private var model = PostModel(from: PostResponse(postId: 0, createDate: "2023-10-23T06:38:59.279Z", modifiedDate: "2023-10-23T06:38:59.279Z", postType: PostType.allSchool, postStatus: PostStatus.active, author: Author(id: 1234, userNickname: "김민", userProfileImage: ""), title: "김민의 살까말까", contents: "뭐살까요", image: "", externalURL: "", likeCount: 12, viewCount: 24, commentCount: 23, voteCounts: VoteCounts(agreeCount: 12, disagreeCount: 32), voteInfoList: [VoteInfo(grade: 1, regionType: .busan, schoolType: .highSchool, gender: .female, agree: true)], postCategoryType: PostCategoryType.food, voted: true, mine: true))
    
    var body: some View {
        ScrollView {
            VStack {
                detailHeaderView
                VoteContentView(postData: model)
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
