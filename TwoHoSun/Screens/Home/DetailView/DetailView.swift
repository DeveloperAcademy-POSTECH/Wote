//
//  DetailView.swift
//  TwoHoSun
//
//  Created by 235 on 10/19/23.
//

import SwiftUI
// TODO: 후에 모델작업은 수정 예정 여기서 사용하기 위해 임의로 제작
struct Comment : Hashable {
    let nickname: String
    let writetime: Int
    let profileImage: String
    let commentData: String
    var isReply: Bool
    let hasResponse: Bool
}

struct DetailView : View {
    var userData : [Comment] = [
        Comment(nickname: "우왁굳", writetime: 1, profileImage: "profile", commentData: "이야 이걸 안사? ", isReply: false, hasResponse: true),
        Comment(nickname: "주용킴", writetime: 2, profileImage: "profile", commentData: "지금 세일이야?", isReply: true, hasResponse: false),
        Comment(nickname: "고맙다링", writetime: 3, profileImage: "profile", commentData: "돈좀", isReply: false, hasResponse: true),
        Comment(nickname: "헤이기가", writetime: 2, profileImage: "profile", commentData: "이안사? ", isReply: false, hasResponse: true),
        Comment(nickname: "스크롤이안돼", writetime: 2, profileImage: "profile", commentData: "지금 세일이야?", isReply: true, hasResponse: false),
        Comment(nickname: "전생에원빈", writetime: 3, profileImage: "profile", commentData: "돈좀", isReply: false, hasResponse: true)
    ]
    @State private var commentText: String = ""
    @State private var writerName: String = "김아무개"
    @State private var alertOn: Bool = false
    @FocusState var isFocus: Bool
    @State private var isSendMessage: Bool = false
    @State private var scrollSpot: Int = 0

    var body: some View {
        VStack {
            if !isFocus {
                detailHeaderView
                Image("splash")
            }
            seperatorView
            commentView
            commentInputView
                .ignoresSafeArea(.all, edges: .bottom)
        }
        .onTapGesture {
            self.endTextEditing()
        }
    }
}
extension DetailView {
    private var detailHeaderView: some View {
        HStack {
            Image(systemName: "person")
                .frame(width: 30, height: 30)
                .clipShape(Circle())
            Text(writerName)
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
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 24) {
                    Text("댓글 20개")
                        .font(.system(size: 14))
                        .foregroundStyle(.gray)
                        .padding(.bottom, 16)
                        .padding(.top, 20)
                    ForEach(userData, id: \.self) { comment in
                        CommentCell(comment: comment) {
                            scrollSpot = comment.hashValue
                            isFocus = true
                        }
                        .id(comment.hashValue)
                    }
                    .onChange(of: scrollSpot) { _ in
                        proxy.scrollTo(scrollSpot, anchor: .top)
                    }
                }
            }
        }
        .padding(.horizontal, 26)
    }

    var commentInputView: some View {
        withAnimation(.easeInOut) {
            TextField("소비고민을 함께 나누어 보세요", text: $commentText, axis: .vertical)
                .lineLimit(5)
                .focused($isFocus)
                .textFieldStyle(CommentTextFieldStyle(isSendMessage: $isSendMessage))
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
                .frame(width: 342)
                .frame(minHeight: 40)
                .background(.white)
                .cornerRadius(5)
        }
        .padding(EdgeInsets(top: 17, leading: 26, bottom: 25, trailing: 22))
        .frame(maxWidth: .infinity)
        .frame(minHeight: 82)
        .background(.ultraThinMaterial)
        .animation(.easeInOut(duration: 0.3), value: commentText)
    }
    struct CommentTextFieldStyle: TextFieldStyle {
        @Binding var isSendMessage: Bool
        func _body(configuration: TextField<Self._Label>) -> some View {
            HStack {
                configuration
                    .font(.system(size: 16))
                Spacer()
                Button(action: { isSendMessage.toggle()}, label: {
                    Image(systemName: "paperplane")
                        .foregroundStyle(.black)
                        .font(.system(size: 20))
                })
            }
        }
    }
}

#Preview {
    DetailView()
}
