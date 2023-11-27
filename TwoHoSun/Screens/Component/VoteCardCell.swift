//
//  VoteCardView.swift
//  TwoHoSun
//
//  Created by 김민 on 11/6/23.
//
import SwiftUI
import Kingfisher

enum VoteResultType: String {
    case buy = "BUY"
    case draw = "NOT_BUY"
    case notBuy = "DRAW"

    init(voteResult: String) {
        switch voteResult {
        case "BUY":
            self = .buy
        case "NOT_BUY":
            self = .notBuy
        case "DRAW":
            self = .draw
        default:
            self = .buy
        }
    }

    var stampImage: Image {
        switch self {
        case .buy:
            Image("imgBuy")
        case .draw:
            Image("imgDraw")
        case .notBuy:
            Image("imgNotBuy")
        }
    }
}

struct VoteCardCell: View {
    enum VoteCardCellType {
        case standard
        case simple
        case myVote
    }

    var cellType: VoteCardCellType
    var progressType: PostStatus
    var voteResultType: VoteResultType? {
        if let voteresult = data.voteResult {
            if voteresult == "DRAW" {
                return .draw
            } else if voteresult == "NOT_BUY" {
                return .notBuy
            } else {
                return .buy
            }
        }
        return nil
    }
    var data: SummaryPostModel
    @Environment(AppLoginState.self) private var loginStateManager

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            if cellType == .standard {
                HStack(spacing: 8) {
                    if let profileImage = data.author?.profileImage {
                        KFImage(URL(string: profileImage)!)
                            .placeholder {
                                ProgressView()
                                    .preferredColorScheme(.dark)
                            }
                            .onFailure { error in
                                print(error.localizedDescription)
                            }
                            .cancelOnDisappear(true)
                            .resizable()
                            .frame(width: 32, height: 32)
                            .clipShape(.circle)
                    }
                    Text(data.author?.nickname ?? "")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                    Spacer()
                    if let consumerType = data.author?.consumerType {
                        ConsumerTypeLabel(consumerType: ConsumerType(rawValue: consumerType) ?? .ecoWarrior ,usage: .cell)
                    }
                }
            }
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 4) {
                        if data.postStatus == PostStatus.closed.rawValue {
                            EndLabel()
                        }
                        Text(data.title)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.white)
                            .lineLimit(1)
                    }
                    Text(data.contents ?? "")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .padding(.bottom, 9)
                    HStack(spacing: 0) {
                        if let price = data.price {
                            Text("가격: \(price)원")
                            Text(" · ")
                        }
                        Text(data.createDate.convertToStringDate() ?? "")
                    }
                    .font(.system(size: 14))
                    .foregroundStyle(Color.gray100)
                }
                Spacer()
                ZStack {
                    CardImageView(imageURL: data.image)
                        .opacity(data.postStatus == PostStatus.closed.rawValue
                                 ? 0.5 : 1.0)
                    if data.postStatus == PostStatus.closed.rawValue {
                        Group {
                            if let voteResult = data.voteResult {
                                switch VoteResultType(voteResult: voteResult) {
                                case .buy:
                                    Image("imgBuy")
                                case .draw:
                                    Image("imgDraw")
                                case .notBuy:
                                    Image("imgNotBuy")
                                }
                            }
                        }
                        .offset(x: -10, y: 10)
                    }
                }
            }

            if progressType == .closed && cellType == .myVote && data.hasReview == false {
//            if progressType == .closed && cellType == .myVote && data.hasReview == false {
                Button {
                    loginStateManager.serviceRoot.navigationManager.navigate(.reviewWriteView(post: data))
                } label: {
                    Text("후기 작성하기")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.lightBlue)
                        .frame(height: 52)
                        .frame(maxWidth: .infinity)
                        .clipShape(.rect(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(Color.lightBlue, lineWidth: 1)
                        )
                        .padding(.top, 6)
                        .padding(.bottom, -6)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
        .background(cellType != .myVote ? Color.disableGray : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
