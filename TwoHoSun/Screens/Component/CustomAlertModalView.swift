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

    var title: String {
        switch self {
        case .ban:
            return "차단"
        case .erase:
            return "삭제"
        }
    }

    var subDescription: String {
        switch self {
        case .ban(let nickname):
            return "\(nickname)님의 게시글이 더 이상 보이지 않습니다."
        case .erase:
            return "지금 댓글을 삭제하시면 댓글을 영구히\n복구할 수 없습니다."
        }
    }
    var optionalDescription: String {
        switch self {
        case .ban:
            return "(‘마이페이지 > 앱 설정 > 사용자 차단 목록'에서 취소할 수 \n있습니다.)"
        case .erase:
            return ""
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
                        Text("\(alertType.title)하기")
                            .foregroundStyle(.white)
                            .font(.system(size: 16, weight: .semibold))
                            .frame(width: 136, height: 41)
                    }
                    .background(Color.darkGray)
                    .clipShape(.rect(cornerRadius: 10))

                    Button {
                        isPresented.toggle()
                    } label: {
                        Text("취소")
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
        }
    }
}

//#Preview {
////    CustomAlertModalView(alertType: .ban(nickname: "선호"))
////    CustomAlertModalView(alertType: .erase)
//}
