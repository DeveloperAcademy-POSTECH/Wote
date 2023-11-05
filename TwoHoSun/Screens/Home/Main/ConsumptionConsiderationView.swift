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

struct ConsumptionConsiderationView: View {
    @State private var isVoted = false
    @State private var selectedVoteType = UserVoteType.agree
    @State private var selectedVoteCategoryType = VoteCategoryType.all
    @State private var isVoteCategoryButtonDidTap = false
    @State private var currentVote = 0
    let viewModel: MainVoteViewModel

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color.background
                .ignoresSafeArea()
            ZStack(alignment: .topLeading) {
                VStack(spacing: 0) {
                    navigationBar
                    Spacer()
                    votePagingView
                    Spacer()
                }

                if isVoteCategoryButtonDidTap {
                    voteCategoryMenu
                        .offset(x: 16, y: 40)
                }
            }
            createVoteButton
                .padding(.bottom, 21)
                .padding(.trailing, 24)
        }
        .onTapGesture {
            isVoteCategoryButtonDidTap = false
        }
    }

}

extension ConsumptionConsiderationView {

    private var navigationBar: some View {
        HStack(spacing: 0) {
            voteCategoryButton
            Spacer()
            notificationButton
                .padding(.trailing, 8)
            searchButton
        }
        .padding(.horizontal, 16)
    }

    private var notificationButton: some View {
        NavigationLink {
            NotificationView()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .frame(width: 39, height: 39)
                    .foregroundStyle(Color.disableGray)
                Image(systemName: "bell.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(Color.woteWhite)
            }
        }
    }

    private var searchButton: some View {
        NavigationLink {
            SearchView()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .frame(width: 39, height: 39)
                    .foregroundStyle(Color.disableGray)
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16))
                    .foregroundStyle(Color.woteWhite)
            }
        }
    }

    private var voteCategoryMenu: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                selectedVoteCategoryType = .all
                isVoteCategoryButtonDidTap = false
                // TODO: - fetch new data
            } label: {
                Text("전국 투표")
                    .padding(.leading, 15)
                    .padding(.top, 14)
                    .padding(.bottom, 12)
            }
            Divider()
                .background(Color.gray300)
            Button {
                selectedVoteCategoryType = .mySchool
                isVoteCategoryButtonDidTap = false
                // TODO: - fetch new data
            } label: {
                Text("우리 학교 투표")
                    .padding(.leading, 15)
                    .padding(.top, 12)
                    .padding(.bottom, 14)
            }
        }
        .frame(width: 131, height: 88)
        .font(.system(size: 14))
        .foregroundStyle(Color.woteWhite)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.disableGray)
                .strokeBorder(Color.gray300, lineWidth: 1)
        )
    }

    private var voteCategoryButton: some View {
        ZStack(alignment: .topLeading) {
            Button {
                isVoteCategoryButtonDidTap.toggle()
            } label: {
                HStack(spacing: 5) {
                    Text(selectedVoteCategoryType.title)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.white)
                    Image(systemName: "chevron.down")
                        .font(.system(size: 16))
                        .foregroundStyle(Color.descriptionGray)
                }
            }
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
                SpendTypeLabel(spendType: .saving)
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
                .frame(maxHeight: 218)
            VStack(spacing: 16) {
                VoteView(isVoted: isVoted,
                         selectedVoteType: selectedVoteType)
                detailResultButton
            }
            .padding(.top, 8)
            nextVoteButton
                .padding(.top, 24)
        }
        .padding(.horizontal, 24)
    }

    private var detailResultButton: some View {
        NavigationLink {
            Text("상세 결과 뷰")
        } label: {
            Text("상세보기")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, maxHeight: 48)
                .background(Color.blue100)
                .clipShape(Capsule())
        }
    }

    @ViewBuilder
    private var nextVoteButton: some View {
        if currentVote != 4 {
            HStack {
                Spacer()
                Button {
                    withAnimation {
                        currentVote += 1
                    }
                } label: {
                    Image("icnCaretDown")
                }
                Spacer()
            }
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
