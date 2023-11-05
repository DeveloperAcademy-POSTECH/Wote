//
//  VoteView.swift
//  TwoHoSun
//
//  Created by 김민 on 11/2/23.
//

import SwiftUI

struct VoteView: View {
    @State var isVoted = false
    @State var selectedVoteType = UserVoteType.agree

    var body: some View {
        VStack(spacing: 8) {
            if isVoted {
                completedVoteButton(voteType: .agree,
                                    selectedType: selectedVoteType,
                                    voteRatio: 50)
                completedVoteButton(voteType: .disagree,
                                    selectedType: selectedVoteType,
                                    voteRatio: 50)
            } else {
                incompletedVoteButton(.agree)
                incompletedVoteButton(.disagree)
            }
        }
    }
}

extension VoteView {

    private func incompletedVoteButton(_ voteType: UserVoteType) -> some View {
        Button {
            isVoted = true
            selectedVoteType = voteType
        } label: {
            ZStack(alignment: .leading) {
                Capsule()
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color.black100)
                HStack(spacing: 4) {
                    Image(systemName: voteType.iconImage)
                    Text(voteType.title)
                }
                .font(.system(size: 16))
                .foregroundStyle(.white)
                .padding(.leading, 20)
            }
        }
        .frame(minHeight: 43, maxHeight: 48)
    }

    private func completedVoteButton(voteType: UserVoteType, selectedType: UserVoteType, voteRatio: Double) -> some View {
        ZStack(alignment: .leading) {
            Capsule()
                .foregroundStyle(Color.black100)
                .overlay(alignment: .leading) {
                    let voteButtonWidth = UIScreen.main.bounds.width - 48
                    Rectangle()
                        .frame(width: voteButtonWidth * voteRatio * 0.01)
                        .foregroundStyle(voteType == selectedType ? Color.lightBlue : Color.gray200)
                }
                .clipShape(Capsule())
            HStack(spacing: 4) {
                Image(systemName:voteType.iconImage)
                Text(voteType.title)
                Spacer()
                Text(String(format: getFirstDecimalNum(voteRatio) == 0 ?
                            "%.0f" : "%.1f", voteRatio) + "%")
            }
            .foregroundStyle(.white)
            .font(.system(size: 16))
            .padding(.horizontal, 20)
        }
        .frame(minHeight: 43, maxHeight: 48)
    }

    private func getFirstDecimalNum(_ voteRatio: Double) -> Int {
        return Int((voteRatio * 10).truncatingRemainder(dividingBy: 10))
    }
}

#Preview {
    VoteView()
}
