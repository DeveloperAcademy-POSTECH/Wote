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
    @State private var isOpenComment: Bool = false
    @State private var isExpended = false
    var onConfirmDiaog: (Bool) -> Void
//    var moreButtonClick: () -> Void
    var childComments: [CommentsModel]?
    init(comment: CommentsModel, onReplyButtonTapped: @escaping () -> Void, onConfirmDiaog: @escaping (Bool) -> Void) {
        self.comment = comment
        self.onReplyButtonTapped = onReplyButtonTapped
        self.onConfirmDiaog = onConfirmDiaog
//        self.moreButtonClick = moreButtonClick
        if let subComments = comment.subComments {
            self.childComments = subComments
        }
    }

    //    @State private var showConfirm = false
    //    var hasChildComments: Bool {
    //        return !comment.childComments!.isEmpty
    //    }


    var body: some View {
        VStack {
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
                            onConfirmDiaog(comment.isMine)
                        }, label: {
                            Image(systemName: "ellipsis")
                                .foregroundStyle(Color.subGray1)
                        })
                    }
                    .padding(.bottom, 6)
                    //                    ExpandableTextView(comment.content, lineLimit: 3)
                    Text("\(comment.content)")
                        .foregroundStyle(Color.white)
                        .font(.system(size: 14))
                        .lineLimit(isExpended ? nil : 3)
                        .padding(.bottom, 4)
                    //                        .overlay(
                    //                            GeometryReader { proxy in
                    //                                Color.clear.onAppear() {
                    //                                    let size = CGSize(width: proxy.size.width, height: .greatestFiniteMagnitude)
                    ////                                    let attributes: [NSAttributedString.Key:Any] = [NSAttributedString.Key.font: ]
                    //                                    var low = 0
                    //                                    var high = comment.content.count
                    //                                    var mid = high
                    //                                    while ((high - low) > 1) {
                    //                                        let attributedText = NSAttributedString(string: )
                    //                                    }
                    //
                    //                                }
                    //                                Button(action: {
                    //                                    isExpended.toggle()
                    //                                }) {
                    //                                    Text(isExpended ? "" : "자세히보기")
                    //                                        .font(.system(size: 12))
                    //                                        .foregroundStyle(Color.subGray1)
                    //
                    //                                }
                    //                                .frame(width: proxy.size.width, height: proxy.size.height, alignment: .bottomTrailing)
                    //                            }
                    //                        )

                    Button(action: {onReplyButtonTapped()}, label: {
                        Text("답글달기")
                            .font(.system(size: 12))
                            .foregroundStyle(Color.subGray1)
                    })
//                    moreCommentButton
                    //                moreComments
                }
            }
//            moreComments
//                .padding(.leading, 26)
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

//    @ViewBuilder
//    var moreCommentButton: some View {
//        if let subcomments = comment.subComments, !isOpenComment {
//            Button(action: {
//                /*moreButtonClick*/()
//                isOpenComment.toggle()
//            }, label: {
//                HStack {
//                    Rectangle()
//                        .fill(.gray)
//                        .frame(width: 29, height: 1)
//                    Text("답글 \(subcomments.count)개 더보기")
//                        .font(.system(size: 12))
//                        .foregroundStyle(.gray)
//                }
//            })
//            .padding(.top, 18)
//        }
//    }

//    @ViewBuilder
//    var moreComments: some View {
//        if let childcomments = childComments, isOpenComment {
//            ForEach(childcomments, id: \.commentId) { comment in
//                CommentCell(comment: comment, onReplyButtonTapped: {
////                    scrollSpot = comment.commentId
////                    replyForAnotherName =  comment.author.nickname
////                    isFocus = true
//                }){ ismine in
////                    scrollSpot = comment.commentId
////                    isFocus = false
////                    ismyCellconfirm = ismine
////                    showConfirm.toggle()
//                }
//            }
//        }
//    }
}
