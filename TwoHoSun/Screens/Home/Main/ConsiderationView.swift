//
//  MainVoteView.swift
//  TwoHoSun
//
//  Created by 김민 on 11/1/23.
//

import SwiftUI

struct ConsiderationView: View {
    @State private var currentVote = 0
    @Binding var selectedVisibilityScope: VisibilityScopeType
    @Environment(AppLoginState.self) private var loginState
    @State private var isRefreshing = false
    @StateObject var viewModel: ConsiderationViewModel

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color.background
                .ignoresSafeArea()
            VStack(spacing: 0) {
                Spacer()
                if !viewModel.isPostFetching {
                    if viewModel.votes.isEmpty {
                        NoVoteView()
                    } else {
                        votePagingView
                    }
                }
                Spacer()

            }
            createVoteButton
                .padding(.bottom, 21)
                .padding(.trailing, 24)
        }
        .onChange(of: selectedVisibilityScope) { _, newScope in
            currentVote = 0
            viewModel.fetchPosts(visibilityScope: newScope.type)
        }
    }
}

extension ConsiderationView {

    private var votePagingView: some View {
        GeometryReader { proxy in
            TabView(selection: $currentVote) {
                ForEach(Array(zip(viewModel.votes.indices, viewModel.votes)), id: \.0) { index, item in
                    VStack(spacing: 0) {
                        VoteContentCell(voteData: item)
                        nextVoteButton
                            .padding(.top, 16)
                    }
                    .tag(index)
                    .onAppear {
                        if (index == viewModel.votes.count - 2) {
                            viewModel.fetchMorePosts(selectedVisibilityScope.type)
                        }
                    }
                }
                .rotationEffect(.degrees(-90))
                .frame(width: proxy.size.width, height: proxy.size.height)
            }
            .frame(width: proxy.size.height, height: proxy.size.width)
            .rotationEffect(.degrees(90), anchor: .topLeading)
            .offset(x: proxy.size.width)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if currentVote == 0 && value.translation.height > 0 {
                            isRefreshing = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                viewModel.fetchPosts(visibilityScope: selectedVisibilityScope.type)
                                isRefreshing = false
                            }
                        }
                    }
            )
            if isRefreshing {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.gray100))
                    .scaleEffect(1.3, anchor: .center)
                    .offset(x: UIScreen.main.bounds.width / 2, y: 30)
            }
        }
    }
    
    private var createVoteButton: some View {
        NavigationLink {
            VoteWriteView(viewModel: VoteWriteViewModel())
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

    @ViewBuilder
    private var nextVoteButton: some View {
        HStack {
            Spacer()
            Button {
                withAnimation {
                    if currentVote != viewModel.votes.count - 1 {
                        currentVote += 1
                    }
                }
            } label: {
                // TODO: - 마지막 cell이면 화살표 버튼을 어떻게 처리할 것인가?
                Image("icnCaretDown")
//                    .opacity(currentVote != viewModel.posts.count - 1 ? 1 : 0)
            }
            Spacer()
        }
    }

    private func getFirstDecimalNum(_ voteRatio: Double) -> Int {
        return Int((voteRatio * 10).truncatingRemainder(dividingBy: 10))
    }
}
