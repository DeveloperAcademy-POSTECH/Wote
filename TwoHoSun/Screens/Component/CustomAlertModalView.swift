//
//  CustomAlertModal.swift
//  TwoHoSun
//
//  Created by 235 on 11/7/23.
//

import SwiftUI
enum AlertType {
    case ban(nickname: String)
    case erase
    case withdrawal
    case logOut
    case closeVote
    case deleteVote
    case deleteReview

    var title: String {
        switch self {
        case .ban:
            return "차단"
        case .withdrawal:
            return "탈퇴"
        case .logOut:
            return ""
        case .closeVote:
            return "마감"
        case .deleteVote, .deleteReview, .erase:
            return "삭제"
        }
    }

    var subDescription: String {
        switch self {
        case .ban(let nickname):
            return "\(nickname)님의 게시글이 더 이상 보이지 않습니다."
        case .erase:
            return "지금 댓글을 삭제하시면 댓글을 영구히\n복구할 수 없습니다."
        case .withdrawal:
            return "계정을 삭제하면 투표, 후기 등 모든 활동 정보가\n삭제 되며 7일간 다시 가입할 수 없어요."
        case .logOut:
            return "로그아웃하면 재 로그인 할 때까지 Wote의\n콘텐츠들을 이용하기 어려워요."
        case .closeVote:
            return "지금 투표를 마감하면 다른 친구들의 의견을\n더 들을 수 없어요."
        case .deleteVote:
            return "지금 투표를 삭제하면 해당 게시물이\n영구히 삭제됩니다."
        case .deleteReview:
            return "지금 후기를 삭제하면 해당 게시물이\n영구히 삭제됩니다."
        }
    }
    var optionalDescription: String {
        switch self {
        case .ban:
            return "(‘마이페이지 > 앱 설정 > 사용자 차단 목록'에서 취소할 수 \n있습니다.)"
        default:
            return ""
        }
    }
    
    var leftButtonLabel: String {
        switch self {
        case .ban:
            return "차단하기"
        case .withdrawal:
            return "탈퇴"
        case .logOut:
            return "로그아웃"
        case .closeVote:
            return "종료하기"
        case .deleteVote, .deleteReview, .erase:
            return "삭제하기"
        }
    }
    
    var rightButtonLabel: String {
        switch self {
        case .withdrawal:
            return "유지하기"
        case .logOut:
            return "유지하기"
        default:
            return "취소"
        }
    }
}
struct CustomAlertModalView: View {
    let alertType: AlertType
    @Binding var isPresented: Bool
    var leftButtonAction: () -> Void

    var titleText: String {
        switch alertType {
        case .ban(let nickname):
            return "\(nickname)님을 "
        case .erase:
            return "댓글을 "
        case .withdrawal:
            return "정말 Wote를 "
        case .logOut:
            return "로그아웃 "
        case .closeVote:
            return "투표를 "
        case .deleteVote:
            return "투표를 "
        case .deleteReview:
            return "후기를 "
        }
    }

    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            VStack {
                Text(titleText)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
                + Text(alertType.title)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.red)
                + Text("하시겠어요?")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
                Text(alertType.subDescription)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, 3)
                    .padding(.bottom, alertType.optionalDescription.isEmpty ? 18 : 4)
                if(!alertType.optionalDescription.isEmpty) {
                    Text(alertType.optionalDescription)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Color.darkGray)
                        .padding(.bottom, 8)
                }
                HStack {
                    Button {
                        leftButtonAction()
                    } label: {
                        Text(alertType.leftButtonLabel)
                            .foregroundStyle(.white)
                            .font(.system(size: 16, weight: .semibold))
                            .frame(width: 136, height: 41)
                    }
                    .background(Color.darkGray)
                    .clipShape(.rect(cornerRadius: 10))

                    Button {
                        isPresented.toggle()
                    } label: {
                        Text(alertType.rightButtonLabel)
                            .foregroundStyle(.white)
                            .font(.system(size: 16, weight: .semibold))
                            .frame(width: 136, height: 41)
                    }
                    .background(Color.lightBlue)
                    .clipShape(.rect(cornerRadius: 10))

                }
            }
            .padding(EdgeInsets(top: 32, leading: 28, bottom: 28, trailing: 28))
            .background(Color.disableGray)
            .clipShape(.rect(cornerRadius: 10))
            .padding(.horizontal, 16)
        }
    }
}
