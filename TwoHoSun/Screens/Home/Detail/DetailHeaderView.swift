//
//  DetailHeaderView.swift
//  TwoHoSun
//
//  Created by 김민 on 11/16/23.
//

import SwiftUI

enum ClosedPostStatus: Codable {
    case myPostWithReview
    case myPostWithoutReview
    case othersPostWithReview
    case othersPostWithoutReview

    init?(isMine: Bool?, hasReview: Bool?) {
        switch (isMine, hasReview) {
        case (true, true):
            self = .myPostWithReview
        case (true, false):
            self = .myPostWithoutReview
        case (false, true):
            self = .othersPostWithReview
        case (false, false):
            self = .othersPostWithoutReview
        case (_, _):
            return nil
        }
    }

    var description: String {
        switch self {
        case .myPostWithReview:
            return "님의 소비 후기"
        case .myPostWithoutReview:
            return "님! 상품에 대한 후기를 들려주세요!"
        case .othersPostWithReview:
            return "님의 소비후기 보러가기"
        case .othersPostWithoutReview:
            return "님이 아직 소비후기를 작성하기 전이에요!"
        }
    }

    @ViewBuilder
    var buttonView: some View {
        switch self {
        case .myPostWithoutReview:
            Image(systemName: "pencil.line")
                .font(.system(size: 20))
        case .othersPostWithoutReview:
            EmptyView()
        default:
            Image("icnReview")
        }
    }
}

struct DetailHeaderView: View {
    @Environment(AppLoginState.self) private var loginState
    @State private var alertOn = false
//    var author: AuthorModel
//    var postStatus: PostStatus
//    var isMine: Bool?
//    var hasReview: Bool?
    var data: PostDetailModel

    var body: some View {
        switch PostStatus(rawValue: data.post.postStatus) {
        case .active:
            activeVoteHeaderView(author: data.post.author, isMine: data.post.isMine)
        case .closed:
            if let isMine = data.post.isMine,
                let hasReview = data.post.hasReview {
                let closedPostState = ClosedPostStatus(isMine: isMine, hasReview: hasReview)!
                closedVoteHeaderView(author: data.post.author,
                                     closedState: closedPostState)
            } else {
                EmptyView()
            }
        default:
            EmptyView()
        }
    }

    private func activeVoteHeaderView(author: AuthorModel, isMine: Bool?) -> some View {
        HStack(spacing: 3) {
            ProfileImageView(imageURL: author.profileImage)
                .frame(width: 32, height: 32)
                .padding(.trailing, 7)
            Text(author.nickname)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.whiteGray)
            if let isMine = isMine {
                if isMine {
                    Text("님의 소비 고민")
                        .font(.system(size: 13))
                        .foregroundStyle(Color.whiteGray)
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

    private func closedVoteHeaderView(author: AuthorModel, closedState: ClosedPostStatus) -> some View {
        HStack(spacing: 3) {
            ProfileImageView(imageURL: author.profileImage)
                .frame(width: 32, height: 32)
                .padding(.trailing, 7)
            Text(author.nickname)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.whiteGray)
            Text(closedState.description)
                .font(.system(size: 13))
                .foregroundStyle(Color.whiteGray)
            Spacer()
            NavigationLink {
//                destinationForHeaderButton(closedState)
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
    private func destinationForHeaderButton(_ closedPostState: ClosedPostStatus, id: Int) -> some View {
        switch closedPostState {
        case .myPostWithoutReview:
            ReviewWriteView()
        case .othersPostWithoutReview:
            EmptyView()
        default:
            // TODO: - post Id 수정
            ReviewDetailView(viewModel: ReviewDetailViewModel(apiManager: loginState.serviceRoot.apimanager),
                             reviewId: id)
        }
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
