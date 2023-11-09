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

struct ConsiderationView: View {
    @State private var isVoted = false
    @State private var selectedVoteType = UserVoteType.agree
    @State private var currentVote = 0
    let viewModel: ConsiderationViewModel

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color.background
                .ignoresSafeArea()
            VStack(spacing: 0) {
                Spacer()
                votePagingView
                Spacer()
            }
            createVoteButton
                .padding(.bottom, 21)
                .padding(.trailing, 24)
        }
    }

}

extension ConsiderationView {

    // TODO: - 투표 없을 시에 noVoteView 보여주기
    private var noVoteView: some View {
        HStack {
            Spacer()
            VStack(spacing: 16) {
                Image("imgNoVote")
                Text("아직 소비고민이 없어요.\n투표 만들기를 통해 소비고민을 등록해보세요.")
                    .foregroundStyle(Color.subGray1)
                    .multilineTextAlignment(.center)
                    .padding(.top, 8)
                NavigationLink {
                    WriteView(viewModel: WriteViewModel())
                } label: {
                    Text("고민 등록하러 가기")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.lightBlue)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(Color.lightBlue, lineWidth: 1)
                        }
                }
            }
            Spacer()
        }
    }

    private var votePagingView: some View {
        GeometryReader { proxy in
            TabView(selection: $currentVote) {
                // TODO: - cell 5개로 설정해 둠
                ForEach(0..<5) { index in
                    voteContentCell
                        .tag(index)
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
            HStack(spacing: 8) {
                Image("imgDefaultProfile")
                    .frame(width: 32, height: 32)
                Text("얄루")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                SpendTypeLabel(spendType: .saving, size: .large)
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
                         selectedVoteType: selectedVoteType)
                detailResultButton
            }
            .padding(.top, 2)
            nextVoteButton
                .padding(.top, 16)
        }
        .padding(.horizontal, 24)
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
                .font(.system(size: 16, weight: .semibold))
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

    private var createVoteButton: some View {
        NavigationLink {
            WriteView(viewModel: WriteViewModel())
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
