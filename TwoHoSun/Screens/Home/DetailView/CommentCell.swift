//
//  CommentCell.swift
//  TwoHoSun
//
//  Created by 235 on 10/19/23.
//

import SwiftUI
struct CommentCell: View {
    
    let comment: Comment
    @State var isOpenComment: Bool = false
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "person")
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .clipShape(Circle())
            VStack(alignment: .leading) {
                HStack {
                    Text(comment.nickname)
                        .font(.system(size: 14, weight: .medium))
                    Text(" \(comment.writetime)시간전")
                        .opacity(0.5)
                        .font(.system(size: 12))

                    Spacer()
                    Button(action: {}, label: {
                        Image(systemName: "ellipsis")
                            .foregroundStyle(.gray)
                    })
                }
                .padding(.bottom, 6)
                Text("\(comment.commentData)")
                    .foregroundColor(.black)
                    .font(.system(size: 14))
                    .padding(.bottom, 4)
                Button(action: {}, label: {
                    Text("답글달기")
                        .font(.system(size: 12))
                        .foregroundStyle(.gray)
                })
                Button(action: {
                    isOpenComment.toggle()
                }, label: {
                    HStack {
                        Rectangle()
                            .fill(.gray)
                            .frame(width: 29, height: 1)
                        Text("답글 \(comment.commentData.count)개 더보기")
                            .font(.system(size: 12))
                            .foregroundStyle(.gray)
                    }
                })
                .padding(.top, 18)
            }
        }
    }
}

extension CommentCell {

}

#Preview {
    CommentCell(comment: Comment(nickname: "우왁굳", writetime: 1, profileImage: "profile", commentData: "이야 이걸 안사? ") )
}
