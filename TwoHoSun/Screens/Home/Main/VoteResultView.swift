//
//  HiddenResultView.swift
//  TwoHoSun
//
//  Created by 김민 on 11/17/23.
//

import SwiftUI

struct IncompletedVoteButton: View {
    @AppStorage("haveConsumerType") var haveConsumerType: Bool = false
    var choice: VoteType
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            ZStack(alignment: .leading) {
                Capsule()
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color.black100)
                HStack(spacing: 4) {
                    Image(systemName: choice.isAgree ? "circle" : "xmark")
                    Text(choice.isAgree ? "산다" : "안 산다")
                }
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(.white)
                .padding(.leading, 20)
            }
        }
        .frame(height: 48)
    }
}

struct VoteResultView: View {
    var myChoice: Bool?
    var agreeRatio: Double
    var disagreeRatio: Double

    var body: some View {
        VStack {
            voteBar(for: .agree, 
                    ratio: agreeRatio,
                    isHighlighted: agreeRatio >= disagreeRatio)
            voteBar(for: .disagree,
                    ratio: disagreeRatio,
                    isHighlighted: disagreeRatio >= agreeRatio)
        }
    }

    private func voteBar(for type: VoteType, ratio: Double, isHighlighted: Bool) -> some View {
        ZStack(alignment: .leading) {
            Capsule()
                .foregroundStyle(Color.black100)
                .overlay(alignment: .leading) {
                    let voteButtonWidth = UIScreen.main.bounds.width - 48
                    Rectangle()
                        .frame(width: voteButtonWidth * ratio * 0.01)
                        .foregroundStyle(isHighlighted ? Color.lightBlue : Color.gray200)
                }
                .overlay {
                    if myChoice == type.isAgree {
                        Capsule()
                            .strokeBorder(Color.lightBlue, lineWidth: 1)
                    }
                }
                .clipShape(Capsule())

            HStack(spacing: 4) {
                Image(systemName: type.isAgree ? "circle" : "xmark")
                Text(type.isAgree ? "산다": "안 산다")
                    .fontWeight(.bold)
                Spacer()
                Text(String(format: ratio.getFirstDecimalNum == 0 ? "%.0f" : "%.1f", ratio) + "%")
            }
            .foregroundStyle(.white)
            .font(.system(size: 16))
            .padding(.horizontal, 20)
        }
        .frame(height: 48)
    }
}
