//
//  DetailView.swift
//  TwoHoSun
//
//  Created by 235 on 10/19/23.
//

import SwiftUI
// TODO: 후에 모델작업은 수정 예정 여기서 사용하기 위해 임의로 제작
struct DetailView : View {

    @State private var commentText: String = ""
    @State private var alertOn: Bool = false
    @FocusState var isFocus: Bool
    @State private var isSendMessage: Bool = false
    @State private var scrollSpot: Int = 0
    @State private var isOpenComment: Bool = false
    //    @State private var parentCommentId: Int = 0

    let postData: PostModel
    let viewModel: DetailViewModel

    init(postData: PostModel) {
        self.postData = postData
        self.viewModel = DetailViewModel(postId: postData.postId)
    }

    var body: some View {
        ScrollView {
            if !isFocus {
                detailHeaderView
                Divider()
                VoteContentView(postData: postData, isMainCell: false)
            }
            seperatorView
            commentView
        }
            commentInputView
                .ignoresSafeArea(.all, edges: .bottom)

        .onChange(of: viewModel.isSendMessage) { _, newVal in
            if newVal {
                viewModel.postComments(commentPost: CommentPostModel(content: commentText, parentId: scrollSpot, postId: postData.postId))
            }
        }
        .onTapGesture {
            self.endTextEditing()
        }
        .onAppear {
            viewModel.getComments()
        }

    }
}
extension DetailView {
    private var detailHeaderView: some View {
        HStack {
            Image(systemName: "person")
                .frame(width: 30, height: 30)
                .clipShape(Circle())
            Text(postData.author.userNickname)
                .font(.system(size: 16))
            Text("님의 구매후기 받기")
                .font(.system(size: 14))
            Spacer()
            Toggle("", isOn: $alertOn)
                .toggleStyle(AlertCustomToggle())

        }
        .padding(.horizontal, 26)
    }
}
struct AlertCustomToggle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        let isOn = configuration.isOn
        return ZStack {
            RoundedRectangle(cornerRadius: 17)
                .frame(width: 61, height: 21)
                .foregroundStyle(Color.gray)
                .overlay(alignment: .leading) {
                    Text(isOn ? "ON" : "OFF")
                        .font(.system(size: 14, weight: .bold))
                        .offset(x: isOn ? 5 : 25)
                        .padding(.trailing, 8)
                }
                .overlay(alignment: .leading) {
                    Image("smile")
                        .resizable()
                        .frame(width: 15,height: 15)
                        .clipShape(Circle())
                        .rotationEffect(Angle.degrees(isOn ? 180 : 0))
                        .offset(x: isOn ? 35 : 5)
                }
                .mask {
                    RoundedRectangle(cornerRadius: 17)
                        .frame(width: 61, height: 21)
                }

        }
        .onTapGesture {
            withAnimation {
                configuration.isOn.toggle()
            }

        }
    }
}

extension DetailView {
    var seperatorView: some View {
        Rectangle()
            .fill(.ultraThickMaterial)
            .frame(width: UIScreen.main.bounds.width, height: 10)
    }
    var commentView : some View {
        ScrollViewReader { proxy in
//            ScrollView {
                LazyVStack(alignment: .leading, spacing: 24) {
                    Text("댓글 \(viewModel.commentsDatas.count)개")
                        .font(.system(size: 14))
                        .foregroundStyle(.gray)
                        .padding(.bottom, 16)
                        .padding(.top, 20)
                    ForEach(viewModel.commentsDatas) { comment in
                        CommentCell(comment: comment) {
                            scrollSpot = comment.commentId
                            isFocus = true
                        }
                        .id(comment.commentId)
                    }
                    .onChange(of: scrollSpot) { _, _ in
                        proxy.scrollTo(scrollSpot, anchor: .top)
                    }
                }
//            }
        }
        .padding(.horizontal, 26)
    }

    var commentInputView: some View {
        withAnimation(.easeInOut) {
            TextField("소비고민을 함께 나누어 보세요", text: $commentText, axis: .vertical)
                .lineLimit(5)
                .focused($isFocus)
                .textFieldStyle(CommentTextFieldStyle(viewModel: viewModel))
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
                .frame(width: 342)
                .frame(minHeight: 40)
                .background(.white)
                .cornerRadius(5)
        }
        .padding(EdgeInsets(top: 17, leading: 26, bottom: 0, trailing: 22))
        .frame(maxWidth: .infinity)
        .frame(minHeight: 82)
        .background(.ultraThinMaterial)
        .animation(.easeInOut(duration: 0.3), value: commentText)
    }
    struct CommentTextFieldStyle: TextFieldStyle {
        @Bindable var viewModel: DetailViewModel
        func _body(configuration: TextField<Self._Label>) -> some View {
            HStack {
                configuration
                    .font(.system(size: 16))
                Spacer()
                Button(action: {
                    viewModel.isSendMessage = true
                }, label: {
                    Image(systemName: "paperplane")
                        .foregroundStyle(.black)
                        .font(.system(size: 20))
                })
            }
        }
    }
}
