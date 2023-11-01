//
//  VoteCellView.swift
//  TwoHoSun
//
//  Created by 김민 on 10/20/23.
//

import SwiftUI

struct MainCellView: View {
    var postData: PostModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            voteHeaderView
//            VoteContentView(postData: postData)
        }
    }
}

extension MainCellView {

    private var voteHeaderView: some View {
        VStack(spacing: 0) {
            HStack {
                userInfoView
                Spacer()
                moreButton
            }
            .padding(.horizontal, 26)
            .padding(.top, 16)
            .padding(.bottom, 14)
            Divider()
                .padding(.horizontal, 11)
        }
    }

    private var userInfoView: some View {
        HStack(spacing: 12) {
            Circle()
                .frame(width: 30, height: 30)
                .foregroundStyle(Color.gray)
            Text(postData.author.userNickname)
                .font(.system(size: 16, weight: .medium))
        }
    }

    private var moreButton: some View {
        Button {
            print("more button did tap")
        } label: {
            Image(systemName: "ellipsis")
                .font(.system(size: 16))
                .foregroundStyle(.gray)
        }
    }

}
