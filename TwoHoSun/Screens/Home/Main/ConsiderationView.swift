//
//  MainVoteView.swift
//  TwoHoSun
//
//  Created by 김민 on 11/1/23.
//

import SwiftUI

struct ConsiderationView: View {
    @State private var didFinishSetup = false
    @State private var currentVote = 0
    @Binding var visibilityScope: VisibilityScopeType
    @Binding var scrollToTop: Bool
    @Environment(AppLoginState.self) private var loginState
    @State private var isRefreshing = false
    @StateObject var viewModel: ConsiderationViewModel
    @AppStorage("haveConsumerType") var haveConsumerType: Bool = false
    @State var isPostCreated = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color.background
                .ignoresSafeArea()
            VStack(spacing: 0) {
                Spacer()
                if !viewModel.isLoading {
                    if loginState.appData.postManager.posts.isEmpty {
                        NoVoteView(selectedVisibilityScope: $visibilityScope)
                    } else {
                        votePagingView
                    }
                } else {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.gray100))
                                .scaleEffect(1.3, anchor: .center)
                            Spacer()
                        }
                        Spacer()
                    }
                }
                Spacer()
            }
            createVoteButton
                .padding(.bottom, 21)
                .padding(.trailing, 24)
        }
        .onChange(of: visibilityScope) { _, newScope in
            viewModel.fetchPosts(visibilityScope: newScope)
            currentVote = 0
        }
        .onChange(of: scrollToTop) { _, _ in
            withAnimation {
                currentVote = 0
            }
        }
        .onAppear {
            if !didFinishSetup {
                viewModel.fetchPosts(visibilityScope: visibilityScope)
                didFinishSetup = true
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(NSNotification.voteCreated)
            NotificationCenter.default.removeObserver(NSNotification.userBlockStateUpdated)
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.voteCreated)) { _ in
            viewModel.fetchPosts(visibilityScope: visibilityScope)
            currentVote = 0
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.userBlockStateUpdated)) { _ in
            viewModel.fetchPosts(visibilityScope: visibilityScope)
            currentVote = 0
        }
        .errorAlert(error: $viewModel.error) {
            viewModel.fetchPosts(visibilityScope: visibilityScope)
            currentVote = 0
        }
    }
}

extension ConsiderationView {

    private var votePagingView: some View {
        GeometryReader { proxy in
            let datas = loginState.appData.postManager.posts
            TabView(selection: $currentVote) {
                ForEach(Array(zip(datas.indices,
                                  datas)), id: \.0) { index, item in
                    VStack(spacing: 0) {
                        VoteContentCell(viewModel: viewModel,
                                        data: item,
                                        index: index)
                        nextVoteButton
                            .padding(.top, 16)
                    }
                    .tag(index)
                    .onAppear {
                        if (index == datas.count - 2) {
                            viewModel.fetchMorePosts(visibilityScope)
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
                        if currentVote == 0 && value.translation.height > 0 && !isRefreshing {
                            isRefreshing = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                viewModel.fetchPosts(visibilityScope: visibilityScope,
                                                     isRefresh: true)
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
        Button {
            guard haveConsumerType else {
                return loginState.serviceRoot.navigationManager.navigate(.testIntroView)
            }
            loginState.serviceRoot.navigationManager.navigate(.makeVoteView)
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
                    if currentVote != loginState.appData.postManager.posts.count - 1 {
                        currentVote += 1
                    }
                }
            } label: {
                Image("icnCaretDown")
                    .opacity(currentVote != loginState.appData.postManager.posts.count - 1 ? 1 : 0)
            }
            Spacer()
        }
    }
}
