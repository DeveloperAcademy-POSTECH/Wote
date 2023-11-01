//
//  MainVoteView.swift
//  TwoHoSun
//
//  Created by 김민 on 11/1/23.
//

import SwiftUI

enum UserVoteType {
    case agree, disagree

    var title: String {
        switch self {
        case .agree:
            return "산다"
        case .disagree:
            return "안 산다"
        }
    }

    var iconImage: String {
        switch self {
        case .agree:
            return "circle"
        case .disagree:
            return "xmark"
        }
    }
}

struct MainVoteView: View {

    @State private var isVoted = false
    @State private var selectedVoteType = UserVoteType.agree
    let viewModel: MainVoteViewModel

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color.background
                .ignoresSafeArea()
            votePagingView
            createVoteButton
                .padding(.bottom, 21)
                .padding(.trailing, 24)
        }
    }

}

extension MainVoteView {

    private var voteCategory: some View {
        Text("고등학교 투표")
            .font(.system(size: 20, weight: .bold))
            .foregroundStyle(.white)
    }

    private var votePagingView: some View {
        GeometryReader { proxy in
            TabView {
                ForEach(0..<5) { _ in
                    voteContentCell
                }
                .rotationEffect(.degrees(-90))
                .frame(width: proxy.size.width, height: proxy.size.height)
            }
            .frame(width: proxy.size.height, height: proxy.size.width)
            .rotationEffect(.degrees(90), anchor: .topLeading)
            .offset(x: proxy.size.width)
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }

    private var voteContentCell: some View {
        VStack(alignment: .leading, spacing: 6) {
            Spacer()
            HStack(spacing: 8) {
                Image("imgDefaultProfile")
                    .frame(width: 32, height: 32)
                Text("얄루")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
            }
            .padding(.bottom, 10)
            Text("ACG 마운틴 플라이 할인하는데 살까?")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(.white)
            Text("텍스트 내용 100자 미만")
                .font(.system(size: 14))
                .foregroundStyle(.white)
                .padding(.bottom, 8)
            HStack(spacing: 0) {
                Text("161,100원 · 64명 투표 · ")
                Image(systemName: "message")
                Text("245명")
            }
            .font(.system(size: 14))
            .foregroundStyle(Color.gray100)
            .padding(.bottom, 14)
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(Color.disableGray, lineWidth: 1)
                .frame(height: 218)
            voteView
                .padding(.vertical, 10)
            detailResultButton
                .padding(.bottom, 18)
            nextVoteButton
            Spacer()
        }
        .frame(maxHeight: .infinity)
        .padding(.horizontal, 24)
    }

    private var detailResultButton: some View {
        NavigationLink {
            Text("상세 결과 뷰")
        } label: {
            Text("상세보기")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(Color.blue100)
                .clipShape(RoundedRectangle(cornerRadius: 28))
        }
    }

    @ViewBuilder
    private var voteView: some View {
        VStack(spacing: 8) {
            if isVoted {
                completedVoteButton(voteType: .agree, selectedType: selectedVoteType)
                completedVoteButton(voteType: .disagree, selectedType: selectedVoteType)
            } else {
                incompletedVoteButton(.agree)
                incompletedVoteButton(.disagree)
            }
        }
    }

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
        .frame(height: 48)
    }

    private func completedVoteButton(voteType: UserVoteType, selectedType: UserVoteType) -> some View {
        ZStack(alignment: .leading) {
            let voteRatio = voteType == .agree ? viewModel.buyCountRatio : viewModel.notBuyCountRatio
            Capsule()
                .foregroundStyle(Color.black100)
                .overlay(alignment: .leading) {
                    let voteButtonWidth = UIScreen.main.bounds.width - 48
                    Rectangle()
                        .frame(width: voteButtonWidth * voteRatio * 0.01, height: 48)
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
        .frame(height: 48)
    }

    private var nextVoteButton: some View {
        HStack {
            Spacer()
            Button {
                print("swipe gesture")
            } label: {
                Image("icnCaretDown")
            }
            Spacer()
        }
    }

    private var createVoteButton: some View {
        NavigationLink {
            Text("Write View")
        } label: {
            HStack(spacing: 2) {
                Image(systemName: "plus")
                    .font(.system(size: 14))
                Text("투표만들기")
                    .font(.system(size: 14, weight: .medium))
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 11)
            .padding(.vertical, 12)
            .background(Color.lightBlue)
            .clipShape(Capsule())
        }
    }

    private func getFirstDecimalNum(_ voteRatio: Double) -> Int {
        return Int((voteRatio * 10).truncatingRemainder(dividingBy: 10))
    }
}

#Preview {
    WoteTabView()
}
