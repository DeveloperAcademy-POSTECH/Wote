//
//  DetailView.swift
//  TwoHoSun
//
//  Created by 235 on 10/19/23.
//

import SwiftUI
// TODO: 후에 모델작업은 수정 예정 여기서 사용하기 위해 임의로 제작
struct DetailView : View {
    @Environment(\.dismiss) var dismiss
    //    @Namespace var commentId
    //    @State private var commentText: String = ""
    @State private var alertOn = false
    @State private var showDetailComments = false
    //    @FocusState var isFocus: Bool
    //    @State private var isSendMessage = false
    //    @State private var scrollSpot: Int = 0
    //    @State private var isOpenComment = false
    //    @State private var keyboardHeight: CGFloat = 0.0
    //    @State private var isReplyButtonTap = false

    //    let viewModel: DetailViewModel
    //    let postId: Int

    enum VoteType {
        case agree, disagree
        var title: String {
            switch self {
            case .agree:
                return "추천"
            case .disagree:
                return "비추천"
            }
        }
    }
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            ScrollView {
                detailHeaderView
                    .padding(.top, 35)
                Divider()
                    .padding(.horizontal, 12)
                detailCell
                    .padding(.top, 30)
                    .padding(.bottom, 24)
                commentPreview
                    .padding(.horizontal, 24)
                voteResultView(.agree, 0.47)
                    .padding(EdgeInsets(top: 32, leading: 0, bottom: 48, trailing: 0))
                voteResultView(.disagree, 0.33)
            }
         
        }

        //
        //        .onAppear(perform: {
        //            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
        //                if let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
        //                    keyboardHeight = keyboardSize.height
        //                }
        //            }
        //            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
        //                keyboardHeight = 0
        //            }
        //        })
        //        .toolbar(.hidden, for: .tabBar)
        //        .onChange(of: viewModel.isSendMessage) { _, newVal in
        //            if newVal {
        //                viewModel.postComments(commentPost: CommentPostModel(content: commentText,
        //                                                                     parentId: scrollSpot,
        //                                                                     postId: viewModel.detailPostData?.postId ?? 0))
        //                commentText = ""
        //            }
        //        }
        //        .onTapGesture {
        //            self.endTextEditing()
        //            self.isReplyButtonTap = false
        //        }
        //        .onAppear {
        //            viewModel.fetchVoteDetailPost()
        //            viewModel.getComments()
        //        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Label("소비고민", systemImage: "chevron.backward")
                        .foregroundStyle(Color.accentBlue)
                }
            }
            ToolbarItem(placement: .principal) {
                Text("상세보기")
                    .foregroundStyle(Color.white)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {}, label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(Color.subGray1)
                })
            }
        }
        .sheet(isPresented: $showDetailComments, content: {

        })
    }
}
extension DetailView {
    private var detailHeaderView: some View {
        HStack(spacing: 0) {
            // TODO: 추후에 서버의 이미지와 연동
            Image("defaultProfile")
                .resizable()
                .frame(width: 32, height: 32)
                .clipShape(Circle())
                .padding(.trailing, 10)
            Text( "일단써놈 ")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.whiteGray)
            Text("님의 구매후기 받기")
                .font(.system(size: 14))
                .foregroundStyle(Color.whiteGray)
            Spacer()
            Toggle("", isOn: $alertOn)
                .toggleStyle(AlertCustomToggle())
        }
        .padding(.horizontal, 24)

    }

    private var detailCell: some View {
        //TODO: 데이터 연결할것
        VStack(alignment: .leading) {
           detailTextView(title: "ACG마운틴 플라이 할인 살말?", price: 1000, description: "어쩌고저쩌고사고말고어쩌라고")
            VStack(spacing: 8) {
                Text("O사다")
                Text("X안사다")
            }
            .padding(.bottom, 24)
            .padding(.horizontal, 24)

            Image("logo")
                .resizable()
                .frame(height: 218)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 24)
            Link(destination: URL(string: "https://naver.com")!, label: {
                Text("https://naver.comeeeefqefewqfewqfewqfewqffqewfq")
                    .tint(Color.white)
                    .font(.system(size: 16))
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.leading)
                    .truncationMode(.tail)
                    .lineLimit(1)
                    .padding(.vertical,10)
                    .padding(.horizontal,14)
                    .background(Color.lightGray)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }).padding(.horizontal,24)

            HStack {
                Label("0명 투표", systemImage: "person.2.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.white)
                    .frame(width: 94, height: 29)
                    .background(Color.darkGray2)
                    .clipShape(RoundedRectangle(cornerRadius: 34))
                Spacer()
                Button {
                    print("이야 공유하자")
                } label: {
                    Label("공유", systemImage: "square.and.arrow.up")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.white)
                        .frame(width: 63, height: 29)
                        .background(Color.lightBlue)
                        .clipShape(RoundedRectangle(cornerRadius: 34))
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 18)
        }
    }
    
    @ViewBuilder
    func detailTextView(title: String, price: Int, description: String) -> some View {
            VStack(alignment: .leading) {
                Text(title)
                    .foregroundStyle(Color.white)
                    .font(.system(size: 18, weight: .bold))
                    .padding(.bottom, 4)
                Text("금액: \(price)원")
                    .foregroundStyle(Color.priceGray)
                    .font(.system(size: 14))
                    .padding(.bottom, 18)
            }
            .padding(.leading, 20)

            Text(description)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(3)
                .multilineTextAlignment(.leading)
                .foregroundStyle(Color.whiteGray)
                .padding(.horizontal, 24)
    }


    var commentPreview: some View {
        //TODO: 뷰모델에서 댓글이 있는지를 체크한담에 있으면 삼항연산자를 통해 할 예정
        VStack {
            HStack(spacing: 4) {
                Text("댓글")
                    .foregroundStyle(Color.priceGray)
                    .font(.system(size: 14, weight: .medium))
                //                if data가 있으면 {
                //                    Text("개")
                //                }
                Spacer()
            }
            HStack(spacing: 7) {
                Image("defaultProfile")
                    .resizable()
                    .frame(width: 24, height: 24)
                HStack {
                    Text("댓글 추가...")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.priceGray)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .background(Color.textFieldGray)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 14)
        .background(Color.lightGray)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .onTapGesture {
            showDetailComments.toggle()
        }
    }

    func voteResultView(_ type: VoteType, _ percent: Double) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("구매 \(type.title) 의견")
                .font(.system(size: 14))
                .foregroundStyle(Color.priceGray)
            HStack(spacing: 8) {
                //TODO: viewModel로 부터 데이터를 받아서 어떤 유형인지 여기에 알려주면 댐.
                SpendTypeLabel(spendType: .saving)
                SpendTypeLabel(spendType: .ecoWarrior)

            }
            Text("투표 후 구매 \(type.title) 의견을 선택한 유형을 확인해봐요!")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.white)
            ProgressView(value: percent)
                .frame(height: 8)
                .tint(Color.lightBlue)
                .background(Color.darkGray2)
        }
        .padding(.horizontal, 24)
    }
    //    struct VoteResultProgressStyle: ProgressViewStyle {
    //        func makeBody(configuration: Configuration) -> some View {
    //            ProgressView(configuration)
    //                .tint(Color.lightBlue)
    //                .background(Color.darkGray2)
    //        }
    //    }
    //    var commentView : some View {
    //        ScrollViewReader { proxy in
    //            LazyVStack(alignment: .leading, spacing: 24) {
    //                Text("댓글 \(viewModel.commentsDatas.count)개")
    //                    .font(.system(size: 14))
    //                    .foregroundStyle(.gray)
    //                    .padding(.bottom, 16)
    //                    .padding(.top, 20)
    //                    .id(commentId)
    //                ForEach(viewModel.commentsDatas) { comment in
    //                    CommentCell(comment: comment) {
    //                        scrollSpot = comment.commentId
    //                        isReplyButtonTap = true
    //                        isFocus = true
    //                    }
    //                    .id(comment.commentId)
    //                    makeChildComments(comment: comment)
    //                }
    //                .onChange(of: scrollSpot) { _, _ in
    //                    proxy.scrollTo(scrollSpot, anchor: .top)
    //                }
    //            }
    //        }
    //        .padding(.horizontal, 26)
    //    }
    //
    //    @ViewBuilder
    //    func makeChildComments(comment: CommentsModel) -> some View {
    //        if let childComments = comment.childComments, !childComments.isEmpty {
    //            HStack {
    //                Spacer()
    //                    .frame(width: 32,height: 32)
    //                if isOpenComment {
    //                    VStack {
    //                        ForEach(childComments) { comment in
    //                            CommentCell(comment: comment) {
    //                            }
    //                        }
    //                    }
    //                } else {
    //                    Button(action: {
    //                        isOpenComment.toggle()
    //                    }, label: {
    //                        HStack {
    //                            Rectangle()
    //                                .fill(.gray)
    //                                .frame(width: 29, height: 1)
    //                            Text("답글 \(comment.childComments!.count)개 더보기")
    //                                .font(.system(size: 12))
    //                                .foregroundStyle(.gray)
    //                        }
    //                    })
    //                }
    //            }
    //
    //        }
    //    }
    //
    //    @ViewBuilder
    //    var forReplayButton: some View {
    //        if isReplyButtonTap {
    //            if let nickName = viewModel.getNicknameForComment(commentId: scrollSpot) {
    //                HStack {
    //                    Text("\(nickName)님에게 답글달기")
    //                        .font(.system(size: 14, weight: .medium))
    //                    Spacer()
    //                    Button {
    //                        isReplyButtonTap = false
    //                    } label: {
    //                        Image(systemName: "xmark")
    //                            .foregroundStyle(.gray)
    //                            .font(.system(size: 14))
    //                    }
    //                }
    //                .frame(height: 50)
    //                .padding(.horizontal, 26)
    //            }
    //
    //        }
    //
    //    }
    //    var commentInputView: some View {
    //        withAnimation(.easeInOut) {
    //            TextField("소비고민을 함께 나누어 보세요", text: $commentText, axis: .vertical)
    //                .lineLimit(5)
    //                .focused($isFocus)
    //                .textFieldStyle(CommentTextFieldStyle(viewModel: viewModel))
    //                .padding(.vertical, 10)
    //                .padding(.horizontal, 12)
    //                .frame(width: 342)
    //                .frame(minHeight: 40)
    //                .background(.white)
    //                .cornerRadius(5)
    //        }
    //        .padding(EdgeInsets(top: 17, leading: 26, bottom: 0, trailing: 22))
    //        .frame(maxWidth: .infinity)
    //        .frame(minHeight: 82)
    //        .background(.ultraThinMaterial)
    //        .animation(.easeInOut(duration: 0.3), value: commentText)
    //    }
    //
    //    struct CommentTextFieldStyle: TextFieldStyle {
    //        @Bindable var viewModel: DetailViewModel
    //        func _body(configuration: TextField<Self._Label>) -> some View {
    //            HStack {
    //                configuration
    //                    .font(.system(size: 16))
    //                Spacer()
    //                Button(action: {
    //                    viewModel.isSendMessage = true
    //                }, label: {
    //                    Image(systemName: "paperplane")
    //                        .foregroundStyle(.black)
    //                        .font(.system(size: 20))
    //                })
    //            }
    //        }
    //    }
}
struct AlertCustomToggle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        let isOn = configuration.isOn
        return ZStack {
            RoundedRectangle(cornerRadius: 17)
                .strokeBorder(Color.white, lineWidth: 2)
                .frame(width: 65, height: 25)
                .background(isOn ? Color.lightBlue : Color.darkblue)
                .overlay(alignment: .leading) {
                    Text(isOn ? "ON" : "OFF")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color.white)
                        .offset(x: isOn ? 6 : 28)
                        .padding(.trailing, 8)
                }
                .overlay(alignment: .leading) {
                    Image("smile")
                        .resizable()
                        .foregroundStyle(Color.white)
                        .frame(width: 15,height: 15)
                        .clipShape(Circle())
                        .rotationEffect(Angle.degrees(isOn ? 180 : 0))
                        .offset(x: isOn ? 45 : 6)
                }
                .mask {
                    RoundedRectangle(cornerRadius: 17)
                        .frame(width: 65, height: 25)
                }
        }
        .onTapGesture {
            withAnimation {
                configuration.isOn.toggle()
            }
        }
    }
}

#Preview {
    NavigationStack {
        DetailView()
    }
}
