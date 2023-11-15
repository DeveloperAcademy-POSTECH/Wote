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
    @ObservedObject var viewModel: ConsiderationViewModel
    @Binding var selectedVisibilityScope: VisibilityScopeType
    @Environment(AppLoginState.self) private var loginState
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color.background
                .ignoresSafeArea()
            VStack(spacing: 0) {
                Spacer()
                if viewModel.posts.isEmpty {
                    NoVoteView(selectedVisibilityScope: $selectedVisibilityScope)
                } else {
                    votePagingView
                }
                Spacer()
            }
            createVoteButton
                .padding(.bottom, 21)
                .padding(.trailing, 24)
        }
        .onAppear {
            viewModel.fetchPosts(visibilityScope: selectedVisibilityScope.type)
        }
        .onChange(of: selectedVisibilityScope) { _, newScope in
            viewModel.fetchPosts(visibilityScope: newScope.type)
        }
    }
}

extension ConsiderationView {

    private var votePagingView: some View {
        GeometryReader { proxy in
            TabView(selection: $currentVote) {
                // TODO: - cell 5개로 설정해 둠
                ForEach(Array(zip(viewModel.posts.indices, viewModel.posts)), id: \.0) { index, item in
                    VStack(spacing: 0) {
                        VoteContentCell(voteData: item)
                        nextVoteButton
                            .padding(.top, 16)
                    }
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
            VoteWriteView(viewModel: VoteWriteViewModel(visibilityScope: selectedVisibilityScope, apiManager: loginState.serviceRoot.apimanager))
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
                    if currentVote != viewModel.posts.count - 1 {
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
