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
                    VoteContentCell(isVoted: false,
                                    isEnd: Bool.random(),
                                    selectedVoteType: selectedVoteType,
                                    currentVote: $currentVote)
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
    
    private var createVoteButton: some View {
        NavigationLink {
            WriteView(viewModel: WriteViewModel())
        } label: {
            HStack(spacing: 2) {
                Image(systemName: "plus")
                Text("투표만들기")
            }
            .font(.system(size: 14, weight: .bold))
            .foregroundStyle(.white)
            .padding(.horizontal, 11)
            .padding(.vertical, 12)
            .background(Color.lightBlue)
            .clipShape(Capsule())
        }
    }

    private var endLabel: some View {
        Text("종료")
            .font(.system(size: 12, weight: .medium))
            .foregroundStyle(.white)
            .padding(.vertical, 4)
            .padding(.horizontal, 5)
            .background(Color.disableGray)
            .clipShape(RoundedRectangle(cornerRadius: 3))
    }

    private func getFirstDecimalNum(_ voteRatio: Double) -> Int {
        return Int((voteRatio * 10).truncatingRemainder(dividingBy: 10))
    }
}

#Preview {
    WoteTabView()
}
