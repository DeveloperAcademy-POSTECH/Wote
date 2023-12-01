//
//  DetailCommentsView.swift
//  TwoHoSun
//
//  Created by 235 on 11/5/23.
//

import SwiftUI

struct CommentsView: View {
    @State private var scrollSpot: Int = 0
    @FocusState private var isFocus: Bool
    // MARK: eclips버튼눌렸을떄 관련된 변수들
    @State private var ismyCellconfirm = false
    @State private var showConfirm = false
    @Binding var showComplaint : Bool
    @Binding var applyComplaint: Bool
    @ObservedObject var viewModel: CommentsViewModel
    @State private var replyForAnotherName: String?
    @Environment(AppLoginState.self) private var loginStateManager
    @State private var lastCommentClick = false

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
            if viewModel.presentAlert {
                ZStack {
                    Color.black.opacity(0.7)
                        .ignoresSafeArea()
                    CustomAlertModalView(alertType: ismyCellconfirm ?
                        .erase : .ban(nickname: viewModel.commentsDatas
                            .filter { $0.commentId == scrollSpot }
                            .first?.author?.nickname ?? ""),
                                         isPresented: $viewModel.presentAlert) {
                        if ismyCellconfirm {
                            viewModel.deleteComments(commentId: scrollSpot)
                        } else {
                            if let commentIDtoBlock = viewModel.commentsDatas.first(where: {$0.commentId == scrollSpot})?.author?.id {
                                loginStateManager.serviceRoot.memberManager.blockUser(memberId: commentIDtoBlock)
                                viewModel.presentAlert.toggle()
                                viewModel.refreshComments()
                            }
                        }
                    }
                    .padding(.bottom, UIScreen.main.bounds.height * 0.05)
                }
            }
            if applyComplaint {
                ZStack {
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
                    .padding(.bottom, UIScreen.main.bounds.height * 0.05)
                }
                .onTapGesture {
                    applyComplaint.toggle()
                }
            }
        }
        .onTapGesture {
            isFocus = false
            replyForAnotherName = nil
        }
        .fullScreenCover(isPresented: $showComplaint, content: {
            NavigationStack {
                ComplaintView(isSheet: $showComplaint, isComplaintApply: $applyComplaint)
            }
        })
        .customConfirmDialog(isPresented: $showConfirm, isMine: $ismyCellconfirm, actions: { bindIsMine in
            let isMine = bindIsMine.wrappedValue
            VStack(spacing: 15) {
                if !isMine {
                    Button {
                        showComplaint.toggle()
                        showConfirm.toggle()
                    } label: {
                        Text("신고하기")
                            .frame(maxWidth: .infinity)
                    }
                    Divider()
                        .background(Color.gray300)
                }
                Button {
                    viewModel.presentAlert.toggle()
                    showConfirm.toggle()
                } label: {
                    Text(isMine ? "삭제하기" : "차단하기")
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.vertical, 15)
        }
        )
    }
}

extension CommentsView {
    var comments : some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 28) {
                    ForEach(viewModel.commentsDatas, id: \.commentId) { comment in
                        CommentCell(comment: comment) {
                            scrollSpot = comment.commentId
                            if let author = comment.author {
                                replyForAnotherName = author.nickname
                            } else {
                                replyForAnotherName = "알 수 없음"
                            }
                            isFocus = true
                        } onConfirmDiaog: { ismine, commentId in
                            scrollSpot = commentId
                            isFocus = false
                            ismyCellconfirm = ismine
                            showConfirm.toggle()
                        }
                    }
                    Color.clear
                        .frame(height:1, alignment: .bottom)
                        .onAppear {
                            lastCommentClick = true
                        }
                    .onChange(of: scrollSpot) { _, _ in
                        proxy.scrollTo(scrollSpot, anchor: .top)
                    }
                    .padding(.bottom, isFocus && lastCommentClick ? 20 : 0)
                }
            }
            .scrollIndicators(.hidden)
        }
        .padding(.horizontal, 24)
    }

    var commentInputView: some View {
        HStack {
            ProfileImageView(imageURL: loginStateManager.serviceRoot.memberManager.profile?.profileImage)
                .frame(width: 32, height: 32)
            withAnimation(.easeInOut) {
                TextField("", text: $viewModel.comments, prompt: Text("소비고민을 함께 나누어 보세요")
                    .foregroundStyle(viewModel.comments.isEmpty ? Color.subGray1 :Color.white)
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
            .animation(.easeInOut(duration: 0.3), value: viewModel.comments)
            if isFocus {
                Button(action: {
                    if replyForAnotherName != nil {
                        viewModel.postReply(commentId: scrollSpot)
                    } else {
                        viewModel.postComment()
                    }
                    isFocus = false
                }, label: {
                    Image(systemName: "paperplane")
                        .foregroundStyle(viewModel.comments.isEmpty ?  Color.subGray1 : Color.white)
                        .font(.system(size: 20))
                })
            }
        }
        .frame(maxWidth: .infinity)
        .padding(EdgeInsets(top: 11, leading: 24, bottom: 9, trailing: 24))
        .overlay(Divider().background(Color.subGray1), alignment: .top)
    }
    @ViewBuilder
    var forReplyLabel: some View {
        if let replyname = replyForAnotherName {
            HStack {
                Text("\(replyname)님에게 답글달기")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.grayC4C4)
                Spacer()
                Button {
                    replyForAnotherName = nil
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
    }
}
