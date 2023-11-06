//
//  DetailCommentsView.swift
//  TwoHoSun
//
//  Created by 235 on 11/5/23.
//

import SwiftUI

struct CommentsView: View {
    @State private var commentText = ""
    @State private var isReplyButtonTap = false
    @State private var scrollSpot: Int = 0
    @FocusState private var isFocus: Bool
    let commentsModel: [CommentsModel] = [CommentsModel(commentId: 1,
                                                        createDate: "2023-11-04T17:43:48.467Z",
                                                        modifiedDate: "2023-11-04T17:43:48.467Z",
                                                        content: """
                                                        와 이걸 안먹어와 이걸 안먹어와 이걸 안먹어와 이걸 안먹어와 이걸 안먹어와 이걸 안먹어와 이걸 안먹어와 이걸 안먹어와
                                                        이걸 안먹어와 이걸 안먹어와 이걸 안먹어와 이걸 안먹어와 이걸 안먹어와 이걸 안먹어와 이걸 안먹어와 이걸 안먹어와
                                                        이걸 안먹어와 이걸 안먹어와 이걸 안먹어와 이걸 안먹어와 이걸 안먹어와 이걸 안먹어와 이걸 안먹어와 이걸 안먹어와
                                                        이걸 안먹어와 이걸 안먹어와 이걸 안먹어와 이걸 안먹어와 이걸 안먹어와 이걸 안먹어와 이걸 안먹어와 이걸 안먹어?
                                                        """,
                                                        author: Author(id: 2, userNickname: "우왕 ㅋ", userProfileImage: nil),
                                                        childComments: nil),
                                          CommentsModel(commentId: 2,
                                                        createDate: "2023-11-04T17:43:48.467Z",
                                                        modifiedDate: "2023-11-04T17:43:48.467Z",
                                                        content: "와 이?",
                                                        author: Author(id: 3, userNickname: "ㅓㅓㅗ", userProfileImage: nil),
                                                        childComments: nil),
                                          CommentsModel(commentId: 3,
                                                        createDate: "2023-11-04T17:43:48.467Z",
                                                        modifiedDate: "2023-11-04T17:43:48.467Z",
                                                        content: "먹어?", author: Author(id: 4, userNickname: "ㅎ ㅋ", userProfileImage: nil),
                                                        childComments: nil),
                                          CommentsModel(commentId: 4,
                                                        createDate: "2023-11-04T17:43:48.467Z",
                                                        modifiedDate: "2023-11-04T17:43:48.467Z",
                                                        content: "와 이걸 안먹어?",
                                                        author: Author(id: 2, userNickname: "우왕 ㅋ", userProfileImage: nil),
                                                        childComments: nil),
                                          CommentsModel(commentId: 5,
                                                        createDate: "2023-11-04T17:43:48.467Z",
                                                        modifiedDate: "2023-11-04T17:43:48.467Z",
                                                        content: "와 이?",
                                                        author: Author(id: 3, userNickname: "ㅓㅓㅗ", userProfileImage: nil),
                                                        childComments: nil),
                                          CommentsModel(commentId: 6,
                                                        createDate: "2023-11-04T17:43:48.467Z",
                                                        modifiedDate: "2023-11-04T17:43:48.467Z",
                                                        content: "먹어?",
                                                        author: Author(id: 4, userNickname: "ㅎ ㅋ", userProfileImage: nil),
                                                        childComments: nil)]
    var body: some View {
        ZStack {
            Color.lightGray
                .ignoresSafeArea()
            VStack(spacing: 0) {
                Text("댓글")
                    .foregroundStyle(.white)
                    .font(.system(size: 15, weight: .medium))
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 13)
                    .padding(.top, 38)
                    .overlay(Divider().background(Color.subGray1), alignment: .bottom)
                    .padding(.bottom, 13)
                comments
                forReplyLabel
                commentInputView
            }
        }
    }
}

extension CommentsView {
    var comments : some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 28) {
                    ForEach(commentsModel, id: \.commentId) { comment in
                        CommentCell(comment: comment) {
                            scrollSpot = comment.commentId
                            isReplyButtonTap = true
                            isFocus = true
                        }
                        //                            .id(comment.commentId)
                        //                            makeChildComments(comment: comment)
                    }
                    .onChange(of: scrollSpot) { _, _ in
                        proxy.scrollTo(scrollSpot, anchor: .top)
                    }
                }
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
                TextField("", text: $commentText, prompt: Text("소비고민을 함께 나누어 보세요")
                    .foregroundStyle(Color.white)
                    .font(.system(size: 14)) ,axis: .vertical)
                .font(.system(size: 14))
                .foregroundStyle(Color.white)
                .lineLimit(5)
                .focused($isFocus)
                .padding(.all, 10)
                .frame(maxWidth: .infinity, minHeight: 37)
                .background {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(isFocus ? Color.darkBlueStroke : Color.textFieldGray, lineWidth: 1)
                            .background(isFocus ? Color.darkblue2325 : Color.textFieldGray)
                    }
                }
            }
            .cornerRadius(12)
            .animation(.easeInOut(duration: 0.3), value: commentText)
            if isFocus {
                Image(systemName: "paperplane")
                    .foregroundStyle(commentText.isEmpty ?  Color.subGray1 : Color.white)
                    .font(.system(size: 20))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(EdgeInsets(top: 11, leading: 24, bottom: 9, trailing: 24))
        .overlay(Divider().background(Color.subGray1), alignment: .top)
    }

    @ViewBuilder
    var forReplyLabel: some View {
        // TODO: 추후에 유저 닉네임 가져오기
        if isReplyButtonTap {
            //             if let nickName = viewModel.getNicknameForComment(commentId: scrollSpot) {
            HStack {
                Text("선ㅋ호ㅋ님에게 답글달기")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.grayC4C4)
                Spacer()
                Button {
                    isReplyButtonTap = false
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.white)
                        .font(.system(size: 14))
                }
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 24)
            .background(Divider().background(Color.subGray1), alignment: .top)
        }
        //         }
    }
}