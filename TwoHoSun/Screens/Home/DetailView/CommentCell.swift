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
    @State var isOpenComment: Bool = false

    var hasChildComments: Bool {
        return !comment.childComments!.isEmpty
    }

    var lastEdit: (String , Int) {
        return comment.modifiedDate.toDate()!.differenceCurrentTime()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            makeCellView(comment: comment)
            if hasChildComments {
                HStack {
                    Spacer()
                        .frame(width: 32,height: 32)
                    if isOpenComment {
                        VStack {
                            ForEach(comment.childComments!) { comment in
                                makeCellView(comment: comment)
                            }
                        }
                    } else {
                        moreCommentButton
                    }
                }
            }
        }
    }
    func makeCellView(comment: CommentsModel) -> some View {
        HStack(alignment: .top) {
            Image(systemName: "person")
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .clipShape(Circle())
            VStack(alignment: .leading) {
                HStack {
                    Text(comment.author.userNickname!)
                        .font(.system(size: 14, weight: .medium))
                    Text("\(lastEdit.1) \(lastEdit.0)")
                        .opacity(0.5)
                        .font(.system(size: 12))
                    Spacer()
                    Button(action: {}, label: {
                        Image(systemName: "ellipsis")
                            .foregroundStyle(.gray)
                    })
                }
                .padding(.bottom, 6)
                Text("\(comment.content)")
                    .foregroundColor(.black)
                    .font(.system(size: 14))
                    .padding(.bottom, 4)
                if comment.childComments != nil {
                    Button(action: {}, label: {
                        Text("답글달기")
                            .font(.system(size: 12))
                            .foregroundStyle(.gray)
                            .onTapGesture {
                                onReplyButtonTapped()
                            }
                    })
                }
            }
        }
    }

    var moreCommentButton: some View {
            Button(action: {
                isOpenComment.toggle()
            }, label: {
                HStack {
                    Rectangle()
                        .fill(.gray)
                        .frame(width: 29, height: 1)
                    Text("답글 \(comment.childComments!.count)개 더보기")
                        .font(.system(size: 12))
                        .foregroundStyle(.gray)
                }
            })
    }
//    @ViewBuilder
//    var forReplayButton: some View {
//        if comment.childComments!= nil {
//            
//        }
//
//    }
}
