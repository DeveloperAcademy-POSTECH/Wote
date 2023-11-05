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

    //    var lastEdit: (String , Int) {
    //        return comment.modifiedDate.toDate()!.differenceCurrentTime()
    //    }

    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "person")
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .clipShape(Circle())
            VStack(alignment: .leading) {
                HStack(spacing: 8) {
                    SpendTypeLabel(spendType: .ecoWarrior, usage: .comments)
                    Text(comment.author.userNickname!)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color.white)
//                    Text("\(comment.modifiedDate)")
                    Text("1시간전")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.subGray1)
                    Spacer()
                    Button(action: {}, label: {
                        Image(systemName: "ellipsis")
                            .foregroundStyle(Color.subGray1)
                    })
                }
                .padding(.bottom, 6)
                Text("\(comment.content)")
                    .foregroundStyle(Color.white)
                    .font(.system(size: 14))
                    .padding(.bottom, 4)
                Button(action: {onReplyButtonTapped()}, label: {
                    Text("답글달기")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.subGray1)
                })
            }
        }
    }
}

#Preview {
    CommentCell(comment: CommentsModel(commentId: 1, createDate: "2023-11-04T17:43:48.467Z", modifiedDate: "2023-11-04T17:43:48.467Z", content: "와 이걸 안먹어?", author: Author(id: 2, userNickname: "우왕 ㅋ", userProfileImage: nil), childComments: nil), onReplyButtonTapped: {})
}
