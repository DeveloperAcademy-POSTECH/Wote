//
//  CommentCell.swift
//  TwoHoSun
//
//  Created by 235 on 10/19/23.
//

enum TimeCalendar {
    case year
    case month
    case day
    case hour
    case minutes
    case seconds
    var beforeString: String {
        switch self {
        case .year:
            return "년전"
        case .month:
            return "개월전"
        case .day:
            return "일전"
        case .hour:
            return "시간전"
        case .minutes:
            return "분전"
        case .seconds:
            return "초전"
        }
    }
}

import SwiftUI
struct CommentCell: View {
    let comment: CommentsModel
    var onReplyButtonTapped: () -> Void
    var onConfirmDiaog: (Bool, Int) -> Void
    var childComments: [CommentsModel]?
    @State private var isOpenComment: Bool = false
    @State private var isExpended = false
    @State private var canExpended = false
    init(comment: CommentsModel, onReplyButtonTapped: @escaping () -> Void, onConfirmDiaog: @escaping (Bool, Int) -> Void) {
        self.comment = comment
        self.onReplyButtonTapped = onReplyButtonTapped
        self.onConfirmDiaog = onConfirmDiaog
        if let subComments = comment.subComments {
            self.childComments = subComments
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            makeCellView(comment: comment, parent: true)
            if let childComments = childComments {
                if isOpenComment {
                    VStack {
                        ForEach(Array(childComments.enumerated()), id:  \.1.commentId) { index, comment in
                            let last = index == childComments.count - 1
                            makeCellView(comment: comment, parent: false)
                                .padding(.bottom, last ? 0 : 12)
                            if last {
                                moreToggleButton()
                            }
                        }
                    }
                    .padding(.leading, 26)
                    .padding(.top, 22)
                } else {
                    moreToggleButton()
                }
            }
        }
    }
}

extension CommentCell {
    var lastEditTimeText: some View {
        var isEdited: String {
            return comment.modifiedDate != comment.createDate ? "수정됨" : ""
        }
        var lastEdit: (String , Int) {
            return comment.modifiedDate.toDate()!.differenceCurrentTime()
        }
        return Text("\(lastEdit.1)"+lastEdit.0 + isEdited)
            .font(.system(size: 12, weight: .regular))
            .foregroundStyle(Color.subGray1)
    }

    func makeCellView(comment: CommentsModel, parent: Bool) -> some View {
        HStack(alignment: .top) {
            Image(systemName: "person")
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .clipShape(Circle())
            VStack(alignment: .leading) {
                HStack(spacing: 8) {
                    ConsumerTypeLabel(consumerType: .ecoWarrior, usage: .comments)
                    Text(comment.author.nickname)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color.white)
                    lastEditTimeText
                    Spacer()
                    Button(action: {
                        onConfirmDiaog(comment.isMine, comment.commentId)
                    }, label: {
                        Image(systemName: "ellipsis")
                            .foregroundStyle(Color.subGray1)
                    })
                }
                .padding(.bottom, 6)
                Text("\(comment.content)")
                    .foregroundStyle(Color.white)
                    .font(.system(size: 14))
                    .lineLimit(isExpended ? nil : 3)
                    .padding(.bottom, 4)
                    .padding(.trailing, 20)
                    .background {
                        ViewThatFits(in: .vertical) {
                            Text("\(comment.content)")
                                .hidden()
                            Color.clear
                                .onAppear {
                                    canExpended = true
                                }
                        }
                    }
                HStack {
                    if parent {
                        Button(action: {onReplyButtonTapped()}, label: {
                            Text("답글달기")
                                .font(.system(size: 12))
                                .foregroundStyle(Color.subGray1)
                        })
                        Spacer()
                        if canExpended {
                            Button {
                                withAnimation(nil) {
                                    isExpended.toggle()
                                }
                            } label: {
                                Text(isExpended ? "줄이기" : "자세히보기")
                                    .font(.system(size: 12))
                                    .foregroundStyle(Color.subGray1)
                            }
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    func moreToggleButton() -> some View {
        if let subcomments = comment.subComments {
            Button(action: {
                isOpenComment.toggle()
            }, label: {
                HStack {
                    Rectangle()
                        .fill(.gray)
                        .frame(width: 29, height: 1)
                    Text(isOpenComment ? "답글닫기" : "답글 \(subcomments.count)개 더보기")
                        .font(.system(size: 12))
                        .foregroundStyle(.gray)
                    Spacer()
                }
            })
            .padding(.leading, 40)
            .padding(.top, 18)
        }
    }
}
