//
//  VoteView.swift
//  TwoHoSun
//
//  Created by 김민 on 11/2/23.
//

import SwiftUI

struct VoteView: View {
    @State var postStatus: String
    @State var myChoice: Bool?
    @State var voteCount: Int
    @State var voteCounts: VoteCounts

    var agreeVoteRatio: Double {
        return voteCount != 0 ? Double(voteCounts.agreeCount) / Double(voteCount) * 100 : 0
    }

    var disagreeVoteRatio: Double {
        return voteCount != 0 ? Double(voteCounts.disagreeCount) / Double(voteCount) * 100 : 0
    }

    var isAgreeVoteRatioHigher: Bool {
        agreeVoteRatio > disagreeVoteRatio
    }

    var body: some View {
        VStack(spacing: 8) {
            if postStatus == PostStatus.closed.rawValue || myChoice != nil {
                voteResultView(choice: true,
                                    myChoice: myChoice,
                                    voteRatio: agreeVoteRatio)
                voteResultView(choice: false,
                                    myChoice: myChoice,
                                    voteRatio: disagreeVoteRatio)
            } else {
                incompletedVoteButton(true)
                incompletedVoteButton(false)
            }
        }
    }
}

extension VoteView {

    private func incompletedVoteButton(_ choice: Bool) -> some View {
        Button {
            // TODO: - 투표하기 api 추가 후 결과 업데이트
            myChoice = choice
        } label: {
            ZStack(alignment: .leading) {
                Capsule()
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color.black100)
                HStack(spacing: 4) {
                    Image(systemName: choice ? "circle" : "xmark")
                    Text(choice ? "산다" : "안 산다")
                }
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(.white)
                .padding(.leading, 20)
            }
        }
        .frame(height: 48)
    }

    private func voteResultView(choice: Bool, myChoice: Bool?, voteRatio: Double) -> some View {
        ZStack(alignment: .leading) {
            Capsule()
                .foregroundStyle(Color.black100)
                .overlay(alignment: .leading) {
                    let voteButtonWidth = UIScreen.main.bounds.width - 48
                    Rectangle()
                        .frame(width: voteButtonWidth * voteRatio)
                        .foregroundStyle(isAgreeVoteRatioHigher && choice ||
                                         !isAgreeVoteRatioHigher && !choice ?
                                         Color.lightBlue : Color.gray200)
                }
                .overlay {
                    if let myChoice = myChoice {
                        Capsule()
                            .strokeBorder(Color.lightBlue,
                                          lineWidth: choice == myChoice ? 1 : 0)
                    }
                }
                .clipShape(Capsule())
            HStack(spacing: 4) {
                Image(systemName: choice ? "circle" : "xmark")
                Text(choice ? "산다" : "안 산다")
                    .fontWeight(.bold)
                Spacer()
                Text(String(format: voteRatio.getFirstDecimalNum == 0 ? "%.0f" : "%.1f", voteRatio) + "%")
            }
            .foregroundStyle(.white)
            .font(.system(size: 16))
            .padding(.horizontal, 20)
        }
        .frame(height: 48)
    }

    private func getFirstDecimalNum(_ voteRatio: Double) -> Int {
        return Int((voteRatio * 10).truncatingRemainder(dividingBy: 10))
    }
}
