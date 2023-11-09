//
//  VoteContentCell.swift
//  TwoHoSun
//
//  Created by 김민 on 11/9/23.
//

import SwiftUI

struct VoteContentCell: View {
    @State var isVoted = false
    @State var isEnd = false
    @State var selectedVoteType = UserVoteType.agree
    @Binding var currentVote: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                Image("imgDefaultProfile")
                    .frame(width: 32, height: 32)
                Text("얄루")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                Spacer()
                SpendTypeLabel(spendType: .saving, usage: .standard)
            }
            .padding(.bottom, 10)
            HStack(spacing: 4) {
                if isEnd {
                    Text("종료")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.white)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 5)
                        .background(Color.disableGray)
                        .clipShape(RoundedRectangle(cornerRadius: 3))
                }
                Text("ACG 마운틴 플라이 할인하는데 살까?")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
            }
            Text("텍스트 내용 100자 미만")
                .font(.system(size: 14))
                .foregroundStyle(.white)
                .padding(.bottom, 8)
            HStack(spacing: 0) {
                Text("가격: 120,000원")
                Text(" · ")
                Text("2020년 3월 12일")
            }
            .font(.system(size: 14))
            .foregroundStyle(Color.gray100)
            .padding(.bottom, 10)
            HStack {
                voteInfoButton(label: "256명 투표", icon: "person.2.fill")
                Spacer()
                voteInfoButton(label: "댓글 20개", icon: "message.fill")
            }
            .padding(.bottom, 2)
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(Color.disableGray, lineWidth: 1)
                .frame(maxWidth: .infinity)
                .aspectRatio(1.5, contentMode: .fit)
            VStack(spacing: 10) {
                VoteView(isVoted: isVoted,
                         isEnd: isEnd,
                         selectedVoteType: selectedVoteType)
                detailResultButton
            }
            .padding(.top, 2)
            nextVoteButton
                .padding(.top, 16)
        }
        .padding(.horizontal, 24)
    }
}

extension VoteContentCell {
    
    private var endLabel: some View {
        Text("종료")
            .font(.system(size: 12, weight: .medium))
            .foregroundStyle(.white)
            .padding(.vertical, 4)
            .padding(.horizontal, 5)
            .background(Color.disableGray)
            .clipShape(RoundedRectangle(cornerRadius: 3))
    }

    private func voteInfoButton(label: String, icon: String) -> some View {
        HStack(spacing: 2) {
            Image(systemName: icon)
            Text(label)
        }
        .font(.system(size: 14))
        .foregroundStyle(.white)
        .padding(.vertical, 7)
        .padding(.horizontal, 10)
        .background(Color.darkGray2)
        .clipShape(.rect(cornerRadius: 34))
    }

    private var detailResultButton: some View {
        NavigationLink {
            DetailView(isDone: false)
        } label: {
            Text("상세보기")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(Color.blue100)
                .clipShape(Capsule())
        }
    }

    @ViewBuilder
    private var nextVoteButton: some View {
        HStack {
            Spacer()
            Button {
                withAnimation {
                    if currentVote != 4 {
                        currentVote += 1
                    }
                }
            } label: {
                Image("icnCaretDown")
                    .opacity(currentVote != 4 ? 1 : 0)
            }
            Spacer()
        }
    }
}

#Preview {
    VoteContentCell(currentVote: .constant(0))
}
