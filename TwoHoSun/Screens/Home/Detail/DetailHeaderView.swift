//
//  DetailHeaderView.swift
//  TwoHoSun
//
//  Created by 김민 on 11/16/23.
//

import SwiftUI

struct DetailHeaderView: View {
    @State private var alertOn = false
    var author: Author
    var postStatus: PostStatus
    var isMine: Bool?
    var hasReview: Bool?

    var body: some View {
        switch postStatus {
        case .active:
            activeVoteHeaderView(author: author, isMine: isMine)
        case .closed:
            if let isMine = isMine, let hasReview = hasReview {
                let closedPostState = ClosedPostStatus(isMine: isMine, hasReview: hasReview)!
                closedVoteHeaderView(author: author, closedState: closedPostState)
            } else {
                EmptyView()
            }
        default:
            EmptyView()
        }
    }

    private func activeVoteHeaderView(author: Author, isMine: Bool?) -> some View {
        HStack(spacing: 0) {
            ProfileImageView(imageURL: author.profileImage)
                .frame(width: 32, height: 32)
                .padding(.trailing, 10)
            Text(author.nickname)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.whiteGray)
            if let isMine = isMine {
                if isMine {
                    Spacer()
                } else {
                    Text("님의 구매후기 받기")
                        .font(.system(size: 13))
                        .foregroundStyle(Color.whiteGray)
                    Spacer()
                    Toggle("", isOn: $alertOn)
                        .toggleStyle(AlertCustomToggle())
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 13)
    }

    private func closedVoteHeaderView(author: Author, closedState: ClosedPostStatus) -> some View {
        HStack(spacing: 0) {
            ProfileImageView(imageURL: author.profileImage)
                .frame(width: 32, height: 32)
                .padding(.trailing, 10)
            Text(author.nickname)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.whiteGray)
            Text(closedState.description)
                .font(.system(size: 13))
                .foregroundStyle(Color.whiteGray)
            Spacer()
            NavigationLink {
                destinationForHeaderButton(closedState)
            } label: {
                if closedState != ClosedPostStatus.othersPostWithoutReview {
                    headerButton(closedState.buttonView)
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 8)
    }

    private func headerButton(_ buttonView: some View) -> some View {
        ZStack {
            Rectangle()
                .frame(width: 50, height: 42)
                .foregroundStyle(Color.gray200)
                .clipShape(.rect(cornerRadius: 6))
            buttonView
                .foregroundStyle(Color.lightBlue500)
        }
    }

    @ViewBuilder
    private func destinationForHeaderButton(_ closedPostState: ClosedPostStatus) -> some View {
        switch closedPostState {
        case .myPostWithoutReview:
            ReviewWriteView()
        case .othersPostWithoutReview:
            EmptyView()
        default:
            ReviewDetailView()
        }
    }
}

#Preview {
    Group {
        DetailHeaderView(author: Author(id: 0,
                                        nickname: "얄루",
                                        profileImage: nil,
                                        consumerType: ConsumerType.flexer.rawValue),
                         postStatus: PostStatus.active,
                         isMine: true,
                         hasReview: nil)
        DetailHeaderView(author: Author(id: 0,
                                        nickname: "얄루",
                                        profileImage: nil,
                                        consumerType: ConsumerType.flexer.rawValue),
                         postStatus: PostStatus.active,
                         isMine: false,
                         hasReview: nil)
        DetailHeaderView(author: Author(id: 0,
                                        nickname: "얄루",
                                        profileImage: nil,
                                        consumerType: ConsumerType.flexer.rawValue),
                         postStatus: PostStatus.closed,
                         isMine: true,
                         hasReview: true)
        DetailHeaderView(author: Author(id: 0,
                                        nickname: "얄루",
                                        profileImage: nil,
                                        consumerType: ConsumerType.flexer.rawValue),
                         postStatus: PostStatus.closed,
                         isMine: true,
                         hasReview: false)
        DetailHeaderView(author: Author(id: 0,
                                        nickname: "얄루",
                                        profileImage: nil,
                                        consumerType: ConsumerType.flexer.rawValue),
                         postStatus: PostStatus.closed,
                         isMine: false,
                         hasReview: false)
        DetailHeaderView(author: Author(id: 0,
                                        nickname: "얄루",
                                        profileImage: nil,
                                        consumerType: ConsumerType.flexer.rawValue),
                         postStatus: PostStatus.closed,
                         isMine: false,
                         hasReview: true)
    }
}

struct AlertCustomToggle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        let isOn = configuration.isOn
        return ZStack {
            RoundedRectangle(cornerRadius: 17)
                .strokeBorder(Color.white, lineWidth: 2)
                .frame(width: 65, height: 25)
                .background(isOn ? Color.lightBlue : Color.darkblue)
                .overlay(alignment: .leading) {
                    Text(isOn ? "ON" : "OFF")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color.white)
                        .offset(x: isOn ? 6 : 28)
                        .padding(.trailing, 8)
                }
                .overlay(alignment: .leading) {
                    Image("smile")
                        .resizable()
                        .foregroundStyle(Color.white)
                        .frame(width: 15,height: 15)
                        .clipShape(Circle())
                        .rotationEffect(Angle.degrees(isOn ? 180 : 0))
                        .offset(x: isOn ? 45 : 6)
                }
                .mask {
                    RoundedRectangle(cornerRadius: 17)
                        .frame(width: 65, height: 25)
                }
        }
        .onTapGesture {
            withAnimation {
                configuration.isOn.toggle()
            }
        }
    }
}
