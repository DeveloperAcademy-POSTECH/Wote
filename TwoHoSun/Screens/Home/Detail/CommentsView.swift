//
//  DetailCommentsView.swift
//  TwoHoSun
//
//  Created by 235 on 11/5/23.
//

import SwiftUI

struct CommentsView: View {
    @State private var commentText = ""
    @FocusState private var isFocus: Bool
    let commentsModel: [CommentsModel] = [CommentsModel(commentId: 1, createDate: "2023-11-04T17:43:48.467Z", modifiedDate: "2023-11-04T17:43:48.467Z", content: "와 이걸 안먹어?", author: Author(id: 2, userNickname: "우왕 ㅋ", userProfileImage: nil), childComments: nil),
                                          CommentsModel(commentId: 2, createDate: "2023-11-04T17:43:48.467Z", modifiedDate: "2023-11-04T17:43:48.467Z", content: "와 이?", author: Author(id: 3, userNickname: "ㅓㅓㅗ", userProfileImage: nil), childComments: nil),
                                          CommentsModel(commentId: 3, createDate: "2023-11-04T17:43:48.467Z", modifiedDate: "2023-11-04T17:43:48.467Z", content: "먹어?", author: Author(id: 4, userNickname: "ㅎ ㅋ", userProfileImage: nil), childComments: nil),
                                          CommentsModel(commentId: 4, createDate: "2023-11-04T17:43:48.467Z", modifiedDate: "2023-11-04T17:43:48.467Z", content: "와 이걸 안먹어?", author: Author(id: 2, userNickname: "우왕 ㅋ", userProfileImage: nil), childComments: nil),
                                          CommentsModel(commentId: 5, createDate: "2023-11-04T17:43:48.467Z", modifiedDate: "2023-11-04T17:43:48.467Z", content: "와 이?", author: Author(id: 3, userNickname: "ㅓㅓㅗ", userProfileImage: nil), childComments: nil),
                                          CommentsModel(commentId: 6, createDate: "2023-11-04T17:43:48.467Z", modifiedDate: "2023-11-04T17:43:48.467Z", content: "먹어?", author: Author(id: 4, userNickname: "ㅎ ㅋ", userProfileImage: nil), childComments: nil)]
    var body: some View {
        ZStack(alignment: .top) {
            Color.lightGray
                .ignoresSafeArea()
            VStack {
                Text("댓글")
                    .foregroundStyle(.white)
                    .font(.system(size: 15))
                    .padding(.bottom, 16)
                    .padding(.top, 38)
                Divider()
                    .padding(.bottom, 15)
                comments
                Divider()
                commentInputView
            }
        }
        .ignoresSafeArea(.keyboard)
    }
}

extension CommentsView {
    var comments : some View {
        ScrollViewReader { proxy in
            LazyVStack(alignment: .leading, spacing: 28) {
                ForEach(commentsModel, id: \.commentId) { comment in
                    CommentCell(comment: comment) {
                        //                                scrollSpot = comment.commentId
                        //                                isReplyButtonTap = true
                        //                                isFocus = true
                    }
                    //                            .id(comment.commentId)
                    //                            makeChildComments(comment: comment)
                }
                //                        .onChange(of: scrollSpot) { _, _ in
                //                            proxy.scrollTo(scrollSpot, anchor: .top)
                //                        }
            }
        }
        .padding(.horizontal, 24)
    }
    var commentInputView: some View {
        HStack {
            Image("defaultProfile")
                .resizable()
                .frame(width: 32, height: 32)
            withAnimation(.easeInOut) {
                TextField("", text: $commentText, 
                          prompt: Text("소비고민을 함께 나누어 보세요")
                    .foregroundStyle(Color.white)
                    .font(.system(size: 14)) ,axis: .vertical)
                    .font(.system(size: 14))
                    .foregroundStyle(Color.white)
                    .lineLimit(5)
                    .focused($isFocus)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 10)
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 37)
                    .background(isFocus ? Color.darkblue2325 : Color.textFieldGray)
                    .cornerRadius(12)
            }
            .animation(.easeInOut(duration: 0.3), value: commentText)
            if isFocus {
                Image(systemName: "paperplane")
                    .foregroundStyle(Color.subGray1)
                    .font(.system(size: 20))
            }
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: 82)
        .padding(EdgeInsets(top: 11, leading: 24, bottom: 34, trailing: 24))
        .modifier(Keyboard())
    }
}
