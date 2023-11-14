//
//  VoteView.swift
//  TwoHoSun
//
//  Created by 김민 on 11/2/23.
//

import SwiftUI

struct VoteView: View {
    @State var isVoted: Bool
    @State var postStatus: String
    @State var selectedVoteType: UserVoteType
    @State var agreeVoteRatio = 30.0
    @State var disagreeVoteRatio = 70.0

    var isAgreeVoteRatioHigher: Bool {
        agreeVoteRatio > disagreeVoteRatio
    }

    var body: some View {
        VStack(spacing: 8) {
            if postStatus == PostStatus.closed.rawValue {
                resultVoteButton(voteType: .agree,
                                 voteRatio: agreeVoteRatio)
                resultVoteButton(voteType: .disagree,
                                 voteRatio: disagreeVoteRatio)
            } else if isVoted {
                completedVoteButton(voteType: .agree,
                                    selectedType: selectedVoteType,
                                    voteRatio: agreeVoteRatio)
                completedVoteButton(voteType: .disagree,
                                    selectedType: selectedVoteType,
                                    voteRatio: disagreeVoteRatio)
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
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(.white)
                .padding(.leading, 20)
            }
        }
        .frame(height: 48)
    }

    private func resultVoteButton(voteType: UserVoteType, voteRatio: Double) -> some View {
        ZStack(alignment: .leading) {
            Capsule()
                .foregroundStyle(Color.black100)
                .overlay(alignment: .leading) {
                    voteBackgroundButtonView(voteType: voteType,
                                             voteRatio: voteRatio)
                }
                .clipShape(Capsule())
            voteDescriptionView(voteType: voteType,
                                voteRatio: voteRatio)
        }
        .frame(height: 48)
    }

    private func completedVoteButton(voteType: UserVoteType, selectedType: UserVoteType, voteRatio: Double) -> some View {
        ZStack(alignment: .leading) {
            Capsule()
                .foregroundStyle(Color.black100)
                .overlay(alignment: .leading) {
                    voteBackgroundButtonView(voteType: voteType,
                                             voteRatio: voteRatio)
                }
                .overlay {
                    Capsule()
                        .strokeBorder(Color.lightBlue,
                                      lineWidth: !(postStatus == PostStatus.closed.rawValue) && voteType == selectedType ? 1 : 0)
                }
                .clipShape(Capsule())
            voteDescriptionView(voteType: voteType,
                                voteRatio: voteRatio)
        }
        .frame(height: 48)
    }

    private func voteBackgroundButtonView(voteType: UserVoteType, voteRatio: Double) -> some View {
        let voteButtonWidth = UIScreen.main.bounds.width - 48

        return Rectangle()
            .frame(width: voteButtonWidth * voteRatio * 0.01)
            .foregroundStyle(isAgreeVoteRatioHigher && voteType == .agree ||
                             !isAgreeVoteRatioHigher && voteType == .disagree ?
                             Color.lightBlue : Color.gray200)
    }

    private func voteDescriptionView(voteType: UserVoteType, voteRatio: Double) -> some View {
        HStack(spacing: 4) {
            Image(systemName: voteType.iconImage)
            Text(voteType.title)
                .fontWeight(.bold)
            Spacer()
            Text(String(format: getFirstDecimalNum(voteRatio) == 0 ?
                        "%.0f" : "%.1f", voteRatio) + "%")
        }
        .foregroundStyle(.white)
        .font(.system(size: 16))
        .padding(.horizontal, 20)
    }

    private func getFirstDecimalNum(_ voteRatio: Double) -> Int {
        return Int((voteRatio * 10).truncatingRemainder(dividingBy: 10))
    }
}

#Preview {
    VoteView(isVoted: Bool.random(),
             postStatus: PostStatus.closed.rawValue,
             selectedVoteType: .agree)
}
